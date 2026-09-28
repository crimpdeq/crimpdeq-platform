//
// Standalone Crimpdeq hand-dynamometer preview and STL export entry point.
//
// Examples:
//   openscad dynamometer_assembly.scad
//   openscad -D 'part="frame_left"' -o /tmp/dyno-frame-left.stl dynamometer_assembly.scad
//   openscad -D 'part="frame_right"' -o /tmp/dyno-frame-right.stl dynamometer_assembly.scad
//   openscad -D 'part="grip"' -o /tmp/dyno-grip.stl dynamometer_assembly.scad
//   openscad -D 'part="wrist_rest"' -o /tmp/dyno-wrist-rest.stl dynamometer_assembly.scad
//   openscad -D 'part="stoppers"' -o /tmp/dyno-stoppers.stl dynamometer_assembly.scad
//   openscad -D 'part="grip"' -D on_plate=true -o /tmp/dyno-grip-on-plate.stl dynamometer_assembly.scad
//
// The view options below are literals so that OpenSCAD's Customizer
// (Window > Customizer) lists them; -D still overrides them.
//

use <dynamometer_parts.scad>
use <crimpdeq_reference.scad>
include <dynamometer_dimensions.scad>

/* [View] */
// Part to preview or export
part = "assembly"; // [assembly, frame_left, frame_right, grip, wrist_rest, stoppers]
// Preview pose; rated exaggerates the grip displacement
pose = "unloaded"; // [unloaded, rated, exploded]
// Export the part at its place on the print plate instead of the origin
on_plate = false;
// Wrist rest position, from the smallest (-1) to the largest (1) opening
wrist_position = 0; // [-1:0.25:1]

/* [Show] */
show_case = true;
show_internals = true;
show_hardware = true;
show_wrist_rest = true;
// Pocket stoppers; any not in the pocket stay in their storage well
show_stoppers = true;
// Stoppers fitted in the finger pocket, by thickness in mm
pocket_stoppers = "none"; // [none, 5, 10, both]
// Largest supported phone in its slot
show_phone = false;

/* [Hidden] */
render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

right_preview_offset = pose == "rated" ? rated_preview_deflection : 0;
exploded_xy = pose == "exploded" ? 24 : 0;
exploded_pin_z = pose == "exploded" ? 12 : 0;
wrist_requested_offset = wrist_position * wrist_adjust_range;
wrist_x_offset =
    round(wrist_requested_offset / wrist_index_pitch) * wrist_index_pitch;

assert(pose == "unloaded" || pose == "rated" || pose == "exploded",
    str("Unknown pose: ", pose));

// Stopper indices in the pocket (bottom first) and in the storage well.
stoppers_in_pocket = [for (i = [0 : stopper_count - 1])
    // The Customizer passes 5 and 10 as numbers; -D may pass strings.
    if (pocket_stoppers == "both" || str(stopper_t_list[i]) == str(pocket_stoppers)) i];
stoppers_stored = [for (i = [0 : stopper_count - 1])
    if (len(search(i, stoppers_in_pocket)) == 0) i];
assert(pocket_stoppers == "none" || len(stoppers_in_pocket) > 0,
    str("Unknown pocket_stoppers: ", pocket_stoppers));
assert(wrist_position >= -1 && wrist_position <= 1,
    "wrist_position must be between -1 and +1.");

module crimpdeq_enclosure_preview() {
    color([0.12, 0.18, 0.25, 0.9])
        crimpdeq_main_reference();
    color([0.18, 0.28, 0.38, 0.85])
        crimpdeq_lid_reference();

    if (show_internals)
        %crimpdeq_internals_reference();
}

module stopper_stack(indices) {
    // The listed stoppers stacked from the pocket floor datum, in order.
    if (len(indices) > 0)
        for (k = [0 : len(indices) - 1])
            translate([0, 0, k == 0 ? 0 : stopper_t_list[indices[0]]])
                pocket_stopper(indices[k]);
}

module dynamometer_complete() {
    color([0.12, 0.12, 0.14])
        translate([-exploded_xy, 0, 0])
            fixed_frame();

    color([0.32, 0.34, 0.38])
        translate([right_preview_offset + exploded_xy, 0, 0])
            moving_finger_grip();

    if (show_wrist_rest)
        color([0.24, 0.26, 0.3])
            translate([-exploded_xy, 0, 0])
                adjustable_wrist_rest(x_offset = wrist_x_offset);

    if (show_case)
        crimpdeq_enclosure_preview();

    if (show_stoppers)
        color([0.2, 0.6, 0.55]) {
            // Stacked on the pocket floor, moving with the grip.
            translate([right_preview_offset + exploded_xy, 0, 0])
                stopper_stack(stoppers_in_pocket);
            // The rest stacked in the storage well.
            translate([
                (stopper_well_x_min + stopper_well_x_max) / 2 - stopper_center_x
                    - exploded_xy,
                0,
                stopper_well_z_min - hangboard_pocket_back_z
            ])
                stopper_stack(stoppers_stored);
        }

    if (show_phone)
        color([0.1, 0.1, 0.1, 0.6])
            translate([-exploded_xy, 0, 0])
                phone_reference();

    color([0.88, 0.62, 0.18])
        dynamometer_bushings(
            right_x_offset = right_preview_offset,
            exploded_z = exploded_pin_z
        );

    if (show_hardware)
        union() {
            dynamometer_hardware(
                right_x_offset = right_preview_offset,
                exploded_z = exploded_pin_z
            );
            translate([-exploded_xy, 0, 0]) {
                wrist_rest_hardware_model(x_offset = wrist_x_offset);
                frame_split_hardware_model();
            }
        }
}

if (part == "assembly") {
    dynamometer_complete();
} else if (on_plate) {
    print_plate_placement(part) print_layout(part);
} else {
    print_layout(part);
}
