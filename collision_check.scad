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
    x_min = frame_x_min - wrist_saddle_depth_x;
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

module stopper_in_pocket(i, dx = 0, dy = 0, dz = 0) {
    translate([dx, dy, dz]) pocket_stopper(i);
}

module phone_slot_neighbours() {
    fixed_frame();
    crimpdeq_case_reference();
    moving_finger_grip();
    adjustable_wrist_rest(x_offset = -wrist_adjust_range);
    wrist_rest_hardware_model(x_offset = -wrist_adjust_range);
    dynamometer_hardware();
    dynamometer_bushings();
    frame_split_hardware_model();
    stored_pocket_stoppers();
}

if (mode == "frame_case") {
    intersection() { fixed_frame(); crimpdeq_case_reference(); }
} else if (mode == "grip_case") {
    intersection() { moving_finger_grip(); crimpdeq_case_reference(); }
} else if (mode == "frame_grip") {
    intersection() { fixed_frame(); moving_finger_grip(); }
} else if (mode == "frame_grip_rated") {
    intersection() {
        fixed_frame();
        translate([rated_preview_deflection, 0, 0]) moving_finger_grip();
    }
} else if (mode == "grip_guide_support") {
    // Dropped by just more than the guide gap, the grip lands on the guide
    // ledge of the selected side and on nothing else in that half.
    assert(test_position < 2, "Guide index must be 0-1.");
    intersection() {
        fixed_frame();
        translate([0, 0, -grip_guide_gap_z - 0.02]) moving_finger_grip();
        translate([hangboard_body_x_min - 1,
                   test_position == 0 ? frame_outer_y_min : frame_center_y,
                   grip_guide_z_min])
            cube([hangboard_body_w_x + 2,
                  (frame_outer_y_max - frame_outer_y_min) / 2,
                  grip_guide_t + 0.01]);
    }
} else if (mode == "stopper_pocket") {
    assert(test_position < stopper_count, "Stopper index out of range.");
    // Lifted 0.01 mm off the floor, so its seating face is not an overlap.
    intersection() { moving_finger_grip(); stopper_in_pocket(test_position, dz = 0.01); }
} else if (mode == "stopper_seated") {
    // Each stopper rests on the pocket floor.
    assert(test_position < stopper_count, "Stopper index out of range.");
    intersection() {
        moving_finger_grip();
        stopper_in_pocket(test_position, dz = -0.02);
    }
} else if (mode == "stopper_located") {
    // The pocket walls stop each stopper within its clearance in X and Y.
    assert(test_position < 2 * stopper_count, "Stopper index out of range.");
    shift = stopper_clearance + 0.1;
    intersection() {
        moving_finger_grip();
        stopper_in_pocket(test_position % stopper_count,
            dx = test_position < stopper_count ? shift : 0,
            dy = test_position < stopper_count ? 0 : shift);
    }
} else if (mode == "stopper_stack_pocket") {
    // Both stoppers stacked, either one at the bottom, clear of the grip and
    // of each other. Seating faces are backed off 0.01 mm so face contact is
    // not an overlap.
    assert(test_position < 2, "Stack order must be 0-1.");
    intersection() {
        moving_finger_grip();
        translate([0, 0, 0.01]) stacked_pocket_stoppers(test_position, dz_top = 0.01);
    }
    intersection() {
        pocket_stopper(test_position);
        translate([0, 0, stopper_t_list[test_position] + 0.01])
            pocket_stopper(1 - test_position);
    }
} else if (mode == "stopper_stack_contact") {
    // The top stopper rests on the bottom one.
    assert(test_position < 2, "Stack order must be 0-1.");
    intersection() {
        pocket_stopper(test_position);
        translate([0, 0, stopper_t_list[test_position] - 0.02])
            pocket_stopper(1 - test_position);
    }
} else if (mode == "stopper_stack_located") {
    // The drafted pocket walls still stop the top stopper in X and Y.
    assert(test_position < 4, "Stack index must be 0-3.");
    bottom = test_position % 2;
    shift = stopper_clearance + 0.1
        + hangboard_draft * stopper_t_list[bottom] / hangboard_pocket_depth_z;
    intersection() {
        moving_finger_grip();
        translate([test_position < 2 ? shift : 0, test_position < 2 ? 0 : shift,
                   stopper_t_list[bottom]])
            pocket_stopper(1 - bottom);
    }
} else if (mode == "stopper_finger_width") {
    // Nothing stands above the top stopper's full plate, alone or stacked,
    // so the tabs don't narrow the edge.
    assert(test_position < 4, "Index must be 0-3.");
    stacked = test_position >= 2;
    i = test_position % 2;
    top_z = hangboard_pocket_back_z + stopper_t_list[i]
        + (stacked ? stopper_t_list[1 - i] : 0);
    intersection() {
        if (stacked) stacked_pocket_stoppers(i); else pocket_stopper(i);
        translate([stopper_x_min, stopper_y_min, top_z + 0.01])
            cube([stopper_x_max - stopper_x_min, stopper_y_max - stopper_y_min, 50]);
    }
} else if (mode == "stopper_tab_proud") {
    // With the stopper on the pocket floor, its pull tab stands above the
    // grip top.
    assert(test_position < 2, "Stopper index out of range.");
    intersection() {
        pocket_stopper(test_position);
        translate([-500, -500, hangboard_front_z + stopper_tab_rise - 1])
            cube([1000, 1000, 0.5]);
    }
} else if (mode == "stopper_stored") {
    intersection() {
        fixed_frame();
        translate([0, 0, 0.01]) stored_pocket_stoppers();
    }
} else if (mode == "stopper_stored_seated") {
    intersection() {
        fixed_frame();
        translate([0, 0, -0.02]) stored_pocket_stoppers();
    }
} else if (mode == "phone_slot") {
    // The largest phone clears everything in either orientation, including
    // the grip, the wrist rest and the stored stoppers.
    intersection() {
        union() {
            phone_reference(portrait = false, drop = -0.02);
            phone_reference(portrait = true, drop = -0.02);
        }
        phone_slot_neighbours();
    }
} else if (mode == "phone_seated") {
    intersection() { fixed_frame(); phone_reference(drop = 0.02); }
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
    // The two halves rebuild the whole frame.
    difference() {
        fixed_frame();
        fixed_frame_half("left");
        fixed_frame_half("right");
    }
} else if (mode == "frame_split_overlap") {
    // The halves only share the lap faces; neither crosses them by >0.01 mm.
    difference() {
        fixed_frame_half("left");
        frame_split_left_region(grow = 0.01);
    }
    intersection() {
        fixed_frame_half("right");
        frame_split_left_region(grow = -0.01);
    }
} else if (mode == "frame_split_bore_wall") {
    // Bolt holes, counterbores and nut pockets break out only through the
    // top and bottom faces, never through a rail side.
    difference() {
        intersection() {
            frame_split_bolt_cuts();
            translate([-500, -500, frame_z_min]) cube([1000, 1000, frame_depth_z]);
        }
        fixed_frame_body();
    }
} else if (mode == "frame_split_hardware_frame") {
    // Bolts and nuts sit in their holes, counterbores and pockets. Back them
    // 0.01 mm off their seating faces so face contact is not an overlap.
    intersection() {
        frame_split_hardware_model(bolt_dz = 0.01, nut_dz = 0.01);
        fixed_frame();
    }
} else if (mode == "frame_split_hardware_recessed") {
    // No head, nut or bolt tip stands proud of the top or bottom face.
    difference() {
        frame_split_hardware_model();
        translate([-500, -500, frame_z_min + 0.01])
            cube([1000, 1000, frame_depth_z - 0.02]);
    }
} else if (mode == "frame_split_hardware_clear") {
    // The joint hardware stays clear of the moving and mounted parts,
    // including the wrist rest at minimum travel, the grip at rated
    // deflection and the tabletop.
    intersection() {
        frame_split_hardware_model();
        union() {
            for (x_offset = [0, rated_preview_deflection])
                translate([x_offset, 0, 0])
                    moving_finger_grip();
            crimpdeq_case_reference();
            adjustable_wrist_rest(x_offset = -wrist_adjust_range);
            wrist_rest_hardware_model(x_offset = -wrist_adjust_range);
            dynamometer_hardware();
            dynamometer_bushings();
            support_surface_probe(clearance = 5);
        }
    }
} else if (mode == "frame_split_clamp") {
    // Each bolt clamps both halves: an annulus around its hole bears on the
    // left half above the lap face and the right half below it.
    assert(test_position < 2 * frame_split_bolt_count, "Clamp index must be 0-7.");
    bolt = floor(test_position / 2);
    x_pos = frame_split_bolt_x[bolt % 2];
    y_pos = frame_split_bolt_y[floor(bolt / 2)];
    intersection() {
        fixed_frame_half(test_position % 2 == 0 ? "left" : "right");
        translate([x_pos, y_pos, frame_z_min])
            difference() {
                cylinder(d = frame_split_bolt_hole_d + 1, h = frame_depth_z);
                translate([0, 0, -0.1])
                    cylinder(d = frame_split_bolt_hole_d - 0.02, h = frame_depth_z + 0.2);
            }
    }
} else if (mode == "wrist_slide_on") {
    // Before the halves are joined, the wrist rest slides onto the right
    // half from its lap end, starting fully clear of the lap.
    start = frame_split_x_min - 1 - wrist_saddle_x_max;
    steps = ceil((-wrist_adjust_range - start) / wrist_index_pitch);
    intersection() {
        fixed_frame_half("right");
        for (i = [0 : steps])
            adjustable_wrist_rest(
                x_offset = min(-wrist_adjust_range, start + i * wrist_index_pitch));
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
    // No part of the saddle rises above the bolster top.
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
    // The pocket cutter must stop at the nominal floor, not below it.
    intersection() {
        moving_finger_grip();
        translate([(hangboard_opening_x_min + hangboard_opening_x_max) / 2,
            0, hangboard_pocket_back_z - 0.02])
            cube([2, 2, 0.01]);
    }
} else {
    assert(false, str("Unknown collision mode: ", mode));
}
