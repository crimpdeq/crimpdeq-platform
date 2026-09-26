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
//

use <dynamometer_parts.scad>
use <crimpdeq_reference.scad>
include <dynamometer_dimensions.scad>

render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

part = is_undef(part) ? "assembly" : part;
pose = is_undef(pose) ? "unloaded" : pose;
show_case = is_undef(show_case) ? true : show_case;
show_internals = is_undef(show_internals) ? true : show_internals;
show_hardware = is_undef(show_hardware) ? true : show_hardware;
show_wrist_rest = is_undef(show_wrist_rest) ? true : show_wrist_rest;
show_stoppers = is_undef(show_stoppers) ? true : show_stoppers;
show_phone = is_undef(show_phone) ? false : show_phone;
wrist_position = is_undef(wrist_position) ? 0 : wrist_position; // -1 to +1

right_preview_offset = pose == "rated" ? rated_preview_deflection : 0;
exploded_xy = pose == "exploded" ? 24 : 0;
exploded_pin_z = pose == "exploded" ? 12 : 0;
wrist_requested_offset = wrist_position * wrist_adjust_range;
wrist_x_offset =
    round(wrist_requested_offset / wrist_index_pitch) * wrist_index_pitch;

assert(pose == "unloaded" || pose == "rated" || pose == "exploded",
    str("Unknown pose: ", pose));
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
        color([0.2, 0.6, 0.55])
            translate([-exploded_xy, 0, 0])
                stored_pocket_stoppers();

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
} else if (part == "frame_left") {
    fixed_frame_half_print_layout("left");
} else if (part == "frame_right") {
    fixed_frame_half_print_layout("right");
} else if (part == "grip") {
    moving_finger_grip_print_layout();
} else if (part == "wrist_rest") {
    wrist_rest_print_layout();
} else if (part == "stoppers") {
    pocket_stoppers_print_layout();
} else {
    assert(false, str("Unknown part: ", part));
}
