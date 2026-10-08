//
// All-printed Crimpdeq finger dynamometer: preview and STL export entry point.
//
// Examples:
//   openscad platform/assembly.scad
//   openscad -D 'part="base_front"' -o /tmp/dyno-base-front.stl platform/assembly.scad
//   openscad -D 'part="grip"' -D on_plate=true -o /tmp/dyno-grip.stl platform/assembly.scad
//
// Parts: base_front, base_rear, anchor, grip, clips, key, rest, stoppers, liner.
// The view options below are literals so that OpenSCAD's Customizer
// (Window > Customizer) lists them; -D still overrides them.
//

use <parts.scad>
use <crimpdeq_reference.scad>
include <dimensions.scad>

/* [View] */
// Part to preview or export
part = "assembly"; // [assembly, base_front, base_rear, anchor, grip, clips, key, rest, stoppers, liner]
// Preview pose; rated exaggerates the grip displacement
pose = "unloaded"; // [unloaded, rated, exploded]
// Export the part at its place on the print plate instead of the origin
on_plate = false;
// Palm rest position, from the smallest (-1) to the largest (1) opening
rest_position = 0; // [-1:0.25:1]

/* [Show] */
show_case = true;
show_internals = true;
show_rest = true;
// Pocket stoppers; any not in the pocket stay in their storage well
show_stoppers = true;
// Stoppers fitted in the finger pocket, by thickness in mm
pocket_stoppers = "none"; // [none, 5, 10, both]
// Edge liner: unlevel for either hand, or against the back wall for a level edge
liner_fit = "level"; // [level, right, left]
// Largest supported phone in its slot
show_phone = false;

/* [Hidden] */
render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

grip_preview_offset = pose == "rated" ? rated_preview_deflection : 0;
explode = pose == "exploded" ? 1 : 0;
rest_x_offset = round(rest_position * rest_adjust_range / rest_index_pitch) * rest_index_pitch;

assert(pose == "unloaded" || pose == "rated" || pose == "exploded",
    str("Unknown pose: ", pose));
assert(rest_position >= -1 && rest_position <= 1,
    "rest_position must be between -1 and +1.");

// Stopper indices in the pocket (bottom first) and in the storage well.
stoppers_in_pocket = [for (i = [0 : stopper_count - 1])
    // The Customizer passes 5 and 10 as numbers; -D may pass strings.
    if (pocket_stoppers == "both" || str(stopper_t_list[i]) == str(pocket_stoppers)) i];
stoppers_stored = [for (i = [0 : stopper_count - 1])
    if (len(search(i, stoppers_in_pocket)) == 0) i];
assert(pocket_stoppers == "none" || len(stoppers_in_pocket) > 0,
    str("Unknown pocket_stoppers: ", pocket_stoppers));

module stopper_stack(indices) {
    // The listed stoppers stacked from the pocket floor datum, in order.
    if (len(indices) > 0)
        for (k = [0 : len(indices) - 1])
            translate([0, 0, k == 0 ? 0 : stopper_t_list[indices[0]]])
                pocket_stopper(indices[k]);
}

module dynamometer_complete() {
    color([0.40, 0.42, 0.46]) base_front();
    color([0.58, 0.60, 0.64]) translate([30 * explode, 0, 0]) base_rear();
    color([0.85, 0.35, 0.20]) translate([0, 0, 30 * explode]) anchor_block();
    color([0.20, 0.45, 0.78]) translate([grip_preview_offset, 0, 30 * explode]) finger_grip();
    color([0.95, 0.80, 0.25]) translate([0, 0, 90 * explode]) eye_clips();
    color([0.85, 0.30, 0.55])
        translate([grip_preview_offset, 0, 60 * explode]) edge_liner(liner_fit);

    if (show_case)
        translate([grip_preview_offset / 2, 0, 60 * explode]) {
            color([0.12, 0.18, 0.25, 0.9]) crimpdeq_main_reference();
            color([0.18, 0.28, 0.38, 0.85]) crimpdeq_lid_reference();
            if (show_internals) %crimpdeq_internals_reference();
        }

    if (show_rest)
        translate([30 * explode, 0, 30 * explode]) {
            color([0.95, 0.55, 0.15]) palm_rest(rest_x_offset);
            color([0.45, 0.80, 0.45])
                index_key(rest_x_offset, 30 * explode);
        }

    if (show_phone)
        color([0.1, 0.1, 0.1, 0.6]) phone_reference();

    if (show_stoppers)
        color([0.2, 0.6, 0.55]) {
            translate([grip_preview_offset + (liner_fit == "level" ? stopper_level_dx : 0),
                       0, 60 * explode])
                stopper_stack(stoppers_in_pocket);
            stopper_well_transform() stopper_stack(stoppers_stored);
        }
}

if (part == "assembly") {
    dynamometer_complete();
} else if (on_plate) {
    print_plate_placement(part) print_layout(part);
} else {
    print_layout(part);
}
