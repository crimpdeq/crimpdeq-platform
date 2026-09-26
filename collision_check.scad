// Standalone collision/fit probes for the Crimpdeq hand dynamometer.

use <dynamometer_parts.scad>
use <crimpdeq_reference.scad>
include <dynamometer_dimensions.scad>

render_fn = is_undef(render_fn) ? 24 : render_fn;
$fn = render_fn;
mode = is_undef(mode) ? "frame_case" : mode;
test_position = is_undef(test_position) ? 0 : test_position;
assert(test_position >= 0 && test_position < wrist_index_count &&
    test_position == floor(test_position), "Invalid wrist test index.");
test_offset = -wrist_adjust_range + test_position * wrist_index_pitch;

module service_probe() {
    // Kept 0.01 mm inside the tunnel floor and roof, so face contact is not
    // an overlap.
    translate([
        0,
        (service_tunnel_y_min + service_tunnel_y_max) / 2,
        (service_tunnel_z_min + service_tunnel_z_max) / 2
    ])
        cube([
            usb_cable_boot_w,
            service_tunnel_y_max - service_tunnel_y_min,
            service_tunnel_z_max - service_tunnel_z_min - 0.02
        ], center = true);
}

module eye_transfer_probe(x_pos) {
    translate([x_pos, dyno_eye_y, loadcell_center_z])
        difference() {
            cylinder(d = eye_d + 0.2, h = lc_T, center = true);
            cylinder(d = eye_d - 0.2, h = lc_T + 0.2, center = true);
        }
}

module support_surface_probe(clearance = 0) {
    x_min = frame_left_post_outer_x - wrist_saddle_depth_x;
    x_max = frame_palm_post_outer_x + wrist_saddle_depth_x + wrist_adjust_range;
    translate([x_min, frame_outer_y_min - 20, support_foot_bottom_z - 1])
        cube([x_max - x_min, frame_outer_y_max - frame_outer_y_min + 40,
              1 + clearance]);
}

module wrist_quick_pin_probe(x_offset = 0) {
    for (y_pos = [wrist_mount_y_bottom, wrist_mount_y_top])
        translate([wrist_mount_x + x_offset, y_pos, wrist_rest_z_min - 0.2])
            cylinder(
                d = wrist_quick_pin_d,
                h = wrist_rest_z_max - wrist_rest_z_min + 0.4
            );
}

if (mode == "frame_case") {
    intersection() { fixed_frame(); crimpdeq_case_reference(); }
} else if (mode == "grip_case") {
    intersection() { moving_finger_grip(); crimpdeq_case_reference(); }
} else if (mode == "frame_grip") {
    intersection() { fixed_frame(); moving_finger_grip(); }
} else if (mode == "interfaces_case") {
    intersection() { dynamometer_bushings(); crimpdeq_case_reference(); }
} else if (mode == "interfaces_frame") {
    intersection() { dynamometer_bushings(); fixed_frame(); }
} else if (mode == "interfaces_grip") {
    intersection() { dynamometer_bushings(); moving_finger_grip(); }
} else if (mode == "interfaces_loadcell_contact") {
    // Give the mating faces 0.01 mm probe-only overlap: exact tangency
    // exports a zero-volume, non-manifold surface rather than a valid STL.
    intersection() { dynamometer_bushings(contact_relief = -0.01); loadcell_reference(); }
} else if (mode == "interfaces_loadcell_relief") {
    intersection() {
        dynamometer_bushings(contact_relief = 0.02);
        loadcell_reference();
    }
} else if (mode == "service_path") {
    intersection() { fixed_frame(); service_probe(); }
} else if (mode == "left_eye_alignment") {
    intersection() { eye_transfer_probe(dyno_eye_x_left); loadcell_reference(); }
} else if (mode == "right_eye_alignment") {
    intersection() { eye_transfer_probe(dyno_eye_x_right); loadcell_reference(); }
} else if (mode == "frame_split_complete") {
    // The two fit-prototype halves rebuild the frame except for peg bores.
    difference() {
        fixed_frame();
        fixed_frame_half("left");
        fixed_frame_half("right");
        frame_split_peg_holes();
    }
} else if (mode == "frame_split_overlap") {
    // The halves only share the cut plane; neither crosses it by >0.01 mm.
    intersection() {
        fixed_frame_half("left");
        translate([frame_split_x + 0.01, -500, -500]) cube(1000);
    }
    intersection() {
        fixed_frame_half("right");
        translate([frame_split_x - 1000.01, -500, -500]) cube(1000);
    }
} else if (mode == "frame_split_peg_wall") {
    // Peg bores stay inside the rails with no break-out to any surface.
    difference() {
        frame_split_peg_holes();
        fixed_frame_body();
    }
} else if (mode == "frame_split_brace_frame") {
    // Braces seat on the rails without penetrating them.
    intersection() { frame_split_braces(contact_relief = 0.01); fixed_frame(); }
} else if (mode == "frame_split_brace_contact") {
    // Each brace bears on BOTH halves of its rail (0.01 mm probe overlap).
    assert(test_position < 4, "Brace contact index must be 0-3.");
    intersection() {
        frame_split_brace(test_position < 2 ? "bottom" : "top", contact_relief = -0.01);
        fixed_frame_half(test_position % 2 == 0 ? "left" : "right");
    }
} else if (mode == "frame_split_brace_sole") {
    // Each leg has a real sole on the corner-foot plane.
    assert(test_position < 2, "Brace sole index must be 0-1.");
    intersection() {
        frame_split_brace(test_position == 0 ? "bottom" : "top");
        translate([frame_split_x - frame_split_brace_sole_x / 2 - 0.1,
                   frame_outer_y_min - 20, support_foot_bottom_z])
            cube([frame_split_brace_sole_x + 0.2,
                  frame_outer_y_max - frame_outer_y_min + 40, 0.1]);
    }
} else if (mode == "frame_split_brace_grip_support") {
    // Each post pad sits under the grip body within the grip gap, so the
    // grip rests level on both sides instead of tipping.
    assert(test_position < 2, "Brace grip-support index must be 0-1.");
    intersection() {
        frame_split_brace(test_position == 0 ? "bottom" : "top",
            contact_relief = -(frame_split_brace_grip_gap + 0.01));
        moving_finger_grip();
    }
} else if (mode == "frame_split_brace_clear") {
    // Minimum wrist travel brings the lower arms closest to the braces. The
    // grip is checked in place, at rated deflection and where it is lowered
    // in before sliding onto the case.
    intersection() {
        frame_split_braces();
        union() {
            for (x_offset = [0, rated_preview_deflection, frame_split_brace_grip_slide_x])
                translate([x_offset, 0, 0])
                    moving_finger_grip();
            crimpdeq_case_reference();
            adjustable_wrist_rest(x_offset = -wrist_adjust_range);
            wrist_rest_hardware_model(x_offset = -wrist_adjust_range);
            dynamometer_hardware();
            dynamometer_bushings();
        }
    }
} else if (mode == "wrist_frame_center") {
    intersection() { adjustable_wrist_rest(); fixed_frame(); }
} else if (mode == "wrist_frame_min") {
    intersection() {
        adjustable_wrist_rest(x_offset = -wrist_adjust_range);
        fixed_frame();
    }
} else if (mode == "wrist_frame_max") {
    intersection() {
        adjustable_wrist_rest(x_offset = wrist_adjust_range);
        fixed_frame();
    }
} else if (mode == "wrist_case") {
    intersection() { adjustable_wrist_rest(); crimpdeq_case_reference(); }
} else if (mode == "wrist_grip") {
    intersection() { adjustable_wrist_rest(); moving_finger_grip(); }
} else if (mode == "wrist_pad_hole_min") {
    intersection() {
        adjustable_wrist_rest(x_offset = -wrist_adjust_range);
        wrist_quick_pin_probe(x_offset = -wrist_adjust_range);
    }
} else if (mode == "wrist_pad_hole_max") {
    intersection() {
        adjustable_wrist_rest(x_offset = wrist_adjust_range);
        wrist_quick_pin_probe(x_offset = wrist_adjust_range);
    }
} else if (mode == "wrist_frame_index_min") {
    intersection() {
        fixed_frame();
        wrist_quick_pin_probe(x_offset = -wrist_adjust_range);
    }
} else if (mode == "wrist_frame_index_max") {
    intersection() {
        fixed_frame();
        wrist_quick_pin_probe(x_offset = wrist_adjust_range);
    }
} else if (mode == "wrist_position") {
    // Check the full saddle, both pin shafts and pin access at EVERY index.
    intersection() {
        adjustable_wrist_rest(x_offset = test_offset);
        union() { fixed_frame(); crimpdeq_case_reference(); moving_finger_grip(); }
    }
    intersection() {
        wrist_quick_pin_probe(x_offset = test_offset);
        union() { fixed_frame(); adjustable_wrist_rest(x_offset = test_offset); }
    }
    intersection() {
        wrist_rest_hardware_model(x_offset = test_offset);
        union() { crimpdeq_case_reference(); moving_finger_grip(); }
    }
    // At each of the nine positions the frame feet, not loose pins, nuts,
    // the moving grip or the case, must be the lowest assembled parts.
    intersection() {
        support_surface_probe(clearance = 5);
        union() {
            adjustable_wrist_rest(x_offset = test_offset);
            wrist_rest_hardware_model(x_offset = test_offset);
            dynamometer_hardware();
            dynamometer_bushings();
            moving_finger_grip();
            crimpdeq_case_reference();
        }
    }
    intersection() {
        adjustable_wrist_rest(x_offset = test_offset);
        // Head diameter + 2 mm, through a full pin withdrawal stroke. Start
        // above the mounting face to exclude intentional head/arm contact.
        for (y_pos = [wrist_mount_y_bottom, wrist_mount_y_top])
            translate([wrist_mount_x + test_offset, y_pos, wrist_rest_z_max + 0.01])
                cylinder(d = wrist_pin_access_d,
                    h = wrist_quick_pin_grip_l + wrist_quick_pin_head_h + 10);
    }
} else if (mode == "foot_contact") {
    // Each of the four feet must have a real (non-tangent) sole at the same Z.
    assert(test_position < 4, "Foot index must be 0-3.");
    x_pos = test_position < 2 ? support_foot_x_left : support_foot_x_right;
    y_pos = test_position % 2 == 0 ? support_foot_y_bottom : support_foot_y_top;
    intersection() {
        fixed_frame();
        translate([x_pos - support_foot_w_x / 2 - 0.1,
                   y_pos - support_foot_w_y / 2 - 0.1, support_foot_bottom_z])
            cube([support_foot_w_x + 0.2, support_foot_w_y + 0.2, 0.1]);
    }
} else if (mode == "wrist_bolster_front_plane") {
    // Nothing on the pad width projects toward the fingers (-X) from the
    // palm-face/bolster plane above the frame's lower face.
    intersection() {
        adjustable_wrist_rest();
        translate([wrist_saddle_x_min - 20, wrist_pad_y_min, frame_z_min])
            cube([20 - 0.01, wrist_pad_y_max - wrist_pad_y_min,
                  wrist_palm_bolster_z_max + 5 - frame_z_min]);
    }
} else if (mode == "wrist_bolster_top") {
    // Negative-volume test: a solid, uncupped, nearly flat top spans the
    // bolster's full width between its end radii.
    difference() {
        translate([
            wrist_palm_bolster_x_min + wrist_palm_bolster_front_r,
            wrist_pad_y_min + wrist_palm_bolster_front_r,
            wrist_palm_bolster_z_max - 0.3
        ])
            cube([wrist_palm_bolster_flat_top_x,
                  wrist_pad_y_max - wrist_pad_y_min - 2 * wrist_palm_bolster_front_r,
                  0.2]);
        adjustable_wrist_rest();
    }
} else if (mode == "wrist_bolster_height") {
    // No part of the saddle rises above the bolster's 12 mm top.
    intersection() {
        adjustable_wrist_rest();
        translate([wrist_arm_x_min - 1, wrist_mount_y_bottom - wrist_arm_h_y,
                   wrist_palm_bolster_z_max + 0.01])
            cube([wrist_saddle_x_max - wrist_arm_x_min + 2,
                  wrist_mount_y_top - wrist_mount_y_bottom + 2 * wrist_arm_h_y, 20]);
    }
} else if (mode == "wrist_bolster_fillet") {
    // The rear face meets the deck through a concave fillet, not a sharp step.
    intersection() {
        adjustable_wrist_rest();
        translate([wrist_palm_bolster_x_max + 0.2,
                   (wrist_pad_y_min + wrist_pad_y_max) / 2 - 0.5,
                   wrist_saddle_z_max + 0.2])
            cube([0.4, 1, 0.8]);
    }
} else if (mode == "wrist_deck_open") {
    // The bolster faces the fingers; behind its rear face and fillet, the
    // 38 mm open heel deck must stay clear for the palm's +Z approach.
    intersection() {
        adjustable_wrist_rest();
        union() {
            translate([wrist_palm_bolster_x_max + wrist_palm_bolster_fillet_r + 0.01,
                       wrist_pad_y_min + wrist_cradle_edge_w + 0.01,
                       wrist_saddle_z_max + 0.01])
                cube([wrist_cradle_open_depth_x - wrist_palm_bolster_fillet_r - 0.02,
                      wrist_cradle_open_width_y - 0.02,
                      wrist_palm_bolster_rise + 1]);
            translate([wrist_palm_bolster_x_max + 0.01,
                       wrist_pad_y_min + wrist_cradle_edge_w + 0.01,
                       wrist_saddle_z_max + wrist_palm_bolster_fillet_r + 0.01])
                cube([wrist_cradle_open_depth_x - 0.02,
                      wrist_cradle_open_width_y - 0.02,
                      wrist_palm_bolster_rise + 1]);
        }
    }
} else if (mode == "wrist_contact_skin") {
    // Negative-volume test: the entire central deck and palm-face skin must
    // be solid, not merely connected by ribs around a collection of gaps.
    difference() {
        union() {
            translate([
                wrist_saddle_x_min + wrist_pad_corner_r,
                wrist_pad_y_min + wrist_pad_corner_r,
                wrist_saddle_z_max - 1
            ])
                cube([wrist_saddle_depth_x - 2 * wrist_pad_corner_r,
                    wrist_saddle_core_width_y, 0.9]);
            translate([
                wrist_saddle_x_min + 0.1,
                wrist_pad_y_min + wrist_pad_corner_r,
                wrist_rest_z_min + wrist_pad_corner_r
            ])
                // Continue through the deck datum into the bolster: one
                // palm-face plane with no groove at the deck top.
                cube([0.9, wrist_saddle_core_width_y,
                    wrist_palm_bolster_z_max - wrist_palm_bolster_front_r - 1
                        - wrist_rest_z_min - wrist_pad_corner_r]);
        }
        adjustable_wrist_rest();
    }
} else if (mode == "finger_entry") {
    // Minimum drafted pocket envelope and its unobstructed +Z approach.
    intersection() {
        dyno_rounded_prism_xy(
            hangboard_opening_x_min + hangboard_draft + 0.01,
            hangboard_opening_x_max - hangboard_draft - 0.01,
            hangboard_opening_y_min + hangboard_draft + 0.01,
            hangboard_opening_y_max - hangboard_draft - 0.01,
            hangboard_pocket_back_z + 0.01, hangboard_front_z + 30,
            hangboard_opening_r - hangboard_draft
        );
        union() {
            fixed_frame(); moving_finger_grip();
            adjustable_wrist_rest(x_offset = -wrist_adjust_range);
            dynamometer_hardware();
        }
    }
} else if (mode == "pocket_floor") {
    // The old cutter extended 0.1 mm below the nominal 20 mm floor.
    intersection() {
        moving_finger_grip();
        translate([(hangboard_opening_x_min + hangboard_opening_x_max) / 2,
            0, hangboard_pocket_back_z - 0.02])
            cube([2, 2, 0.01]);
    }
} else {
    assert(false, str("Unknown collision mode: ", mode));
}
