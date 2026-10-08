// Standalone collision/fit probes for the all-printed Crimpdeq dynamometer.
// Seating faces are backed off 0.01 mm where contact is intended, so face
// contact is not reported as an overlap.

use <dynamometer_parts.scad>
use <crimpdeq_reference.scad>
include <dynamometer_dimensions.scad>

render_fn = is_undef(render_fn) ? 24 : render_fn;
$fn = render_fn;
mode = is_undef(mode) ? "anchor_case" : mode;
test_position = is_undef(test_position) ? 0 : test_position;
assert(test_position >= 0 && test_position < rest_index_count &&
    test_position == floor(test_position), "Invalid test index.");

module lifted(dz = 0.01) { translate([0, 0, dz]) children(); }

module fixed_parts() {
    base_front();
    base_rear();
    anchor_block();
}

module service_probe() {
    // Finger and cable room in front of the switch and USB openings.
    z_min = case_switch_z - case_switch_h / 2;
    z_max = case_usb_z + case_usb_h / 2 + 8;
    translate([-service_w / 2, case_y_max + 0.01, z_min])
        cube([service_w, service_y_max - case_y_max, z_max - z_min]);
}

module stopper_in_pocket(i, dx = 0, dy = 0, dz = 0) {
    translate([dx, dy, dz]) pocket_stopper(i);
}

if (mode == "anchor_case") {
    intersection() { anchor_block(); crimpdeq_case_reference(); }
} else if (mode == "grip_case") {
    intersection() {
        union() { finger_grip(); translate([rated_preview_deflection, 0, 0]) finger_grip(); }
        crimpdeq_case_reference();
    }
} else if (mode == "base_case") {
    // The case floats: even lowered by nearly its gap it clears the base.
    intersection() {
        union() { base_front(); base_rear(); }
        translate([0, 0, -case_float_gap + 0.1]) crimpdeq_case_reference();
    }
} else if (mode == "clips_case") {
    intersection() { eye_clips(); crimpdeq_case_reference(); }
} else if (mode == "case_drop") {
    // The case, with its load cell, lowers onto both lugs from above
    // without touching the tongues or lugs.
    intersection() {
        union() { anchor_block(); finger_grip(); }
        for (dz = [0.01, 1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 20])
            translate([0, 0, dz]) {
                crimpdeq_case_reference();
                loadcell_reference();
            }
    }
} else if (mode == "anchor_base") {
    intersection() { lifted() anchor_block(); union() { base_front(); base_rear(); } }
} else if (mode == "anchor_seated") {
    intersection() { lifted(-0.02) anchor_block(); base_front(); }
} else if (mode == "anchor_bears") {
    // Pulled toward the grip, the anchor bears on the pocket's +X wall.
    intersection() {
        translate([anchor_play_x + 0.05, 0, 0.01]) anchor_block();
        base_front();
    }
} else if (mode == "grip_base") {
    intersection() {
        union() { finger_grip(); translate([rated_preview_deflection, 0, 0]) finger_grip(); }
        union() { fixed_parts(); }
    }
} else if (mode == "grip_guide_support") {
    // Dropped by just more than the guide gap, the grip lands on the ledge
    // of the selected side.
    assert(test_position < 2, "Guide index must be 0-1.");
    intersection() {
        translate([0, 0, -grip_guide_gap_z - 0.02]) finger_grip();
        base_front();
        translate([trench_x_min - 1, test_position == 0 ? -base_half_w_y : 0,
                   grip_guide_z_max - 1])
            cube([trench_x_max - trench_x_min + 2, base_half_w_y, 1.01]);
    }
} else if (mode == "tab_seated") {
    // The load cell rests on the anchor (0) and grip (1) seats.
    assert(test_position < 2, "Seat index must be 0-1.");
    intersection() {
        lifted(-0.02) loadcell_reference();
        if (test_position == 0) anchor_block(); else finger_grip();
    }
} else if (mode == "lug_clear") {
    // Both lugs pass through the eyes without touching the load cell.
    intersection() {
        lifted() loadcell_reference();
        union() { anchor_block(); finger_grip(); }
    }
} else if (mode == "lug_bearing") {
    // Pulling the grip (+X) brings each eye's outer rim onto its lug.
    assert(test_position < 2, "Lug index must be 0-1.");
    shift = lug_fit + 0.05;
    if (test_position == 0)
        intersection() { translate([shift, 0, 0.01]) loadcell_reference(); anchor_block(); }
    else
        intersection() { lifted() loadcell_reference(); translate([shift, 0, 0]) finger_grip(); }
} else if (mode == "clip_parts") {
    intersection() {
        lifted() eye_clips();
        union() { anchor_block(); finger_grip(); loadcell_reference(); }
    }
} else if (mode == "clip_clamp") {
    // Each clip presses on its end of the load cell.
    assert(test_position < 2, "Clip index must be 0-1.");
    intersection() {
        lifted(-0.02) eye_clip(test_position == 0 ? "left" : "right");
        loadcell_reference();
    }
} else if (mode == "clip_retained") {
    // Lifted (0-1), a clip catches its lug head; pulled outboard (2-3), its
    // fork snaps against the neck.
    assert(test_position < 4, "Clip index must be 0-3.");
    side = test_position % 2 == 0 ? "left" : "right";
    intersection() {
        if (test_position < 2)
            translate([0, 0, clip_head_gap + 0.05]) eye_clip(side);
        else
            lifted() eye_clip(side, dx = 1);
        if (side == "left") anchor_block(); else finger_grip();
    }
} else if (mode == "clip_path") {
    // Each clip drops into its U-slot beside the lug head, then slides in
    // over the load cell. Only the snap at the neck may touch on the way.
    assert(test_position < 2, "Clip index must be 0-1.");
    side = test_position == 0 ? "left" : "right";
    x_eye = test_position == 0 ? dyno_eye_x_left : dyno_eye_x_right;
    intersection() {
        union() {
            for (dz = [0.01, 2, 5, 10, 15, 20, 25])
                translate([0, 0, dz]) eye_clip(side, dx = clip_install_travel);
            for (dx = [0 : 1 : clip_install_travel])
                lifted() eye_clip(side, dx = dx);
        }
        difference() {
            union() {
                crimpdeq_case_reference(); anchor_block(); finger_grip();
                loadcell_reference();
            }
            translate([x_eye, dyno_eye_y, loadcell_top_z - 0.1])
                cylinder(r = lug_neck_r + 0.01, h = lug_head_z_min - loadcell_top_z + 0.1);
        }
    }
} else if (mode == "service_path") {
    intersection() {
        service_probe();
        union() {
            fixed_parts(); finger_grip(); eye_clips();
            palm_rest(-rest_adjust_range); index_key(-rest_adjust_range);
            stored_pocket_stoppers();
        }
    }
} else if (mode == "base_halves_overlap") {
    intersection() { base_front(); translate([0.01, 0, 0.01]) base_rear(); }
} else if (mode == "base_joint_locked") {
    // Pulled apart, the rear half's sockets catch the dovetail tongues.
    intersection() { base_front(); translate([joint_catch_travel + 0.05, 0, 0.01]) base_rear(); }
} else if (mode == "base_joint_bears") {
    // Pushed together, the halves bear on their butt faces.
    intersection() { base_front(); translate([-0.02, 0, 0.01]) base_rear(); }
} else if (mode == "rest_position") {
    // The rest and the key at each of the seven positions.
    o = rest_offset(test_position);
    intersection() {
        lifted() palm_rest(o);
        union() { fixed_parts(); finger_grip(); eye_clips(); crimpdeq_case_reference(); }
    }
    intersection() {
        lifted() index_key(o);
        union() { fixed_parts(); palm_rest(o); finger_grip(); }
    }
} else if (mode == "rest_locked") {
    // At both travel ends, the key catches its floor groove and the plate's
    // groove in X.
    assert(test_position < 4, "Lock index must be 0-3.");
    o = test_position < 2 ? -rest_adjust_range : rest_adjust_range;
    shift = (test_position % 2 == 0 ? -1 : 1) * (key_fit / 2 + 0.05);
    intersection() { translate([shift, 0, 0.02]) index_key(o); base_rear(); }
    intersection() { translate([shift, 0, 0.02]) index_key(o); palm_rest(o); }
} else if (mode == "rest_retained") {
    // Lifted off the channel floor at its least-engaged position, the
    // plate's flanks catch the channel's lips.
    intersection() {
        translate([0, 0, rest_catch_travel + 0.05]) palm_rest(rest_adjust_range);
        base_rear();
    }
} else if (mode == "rest_slide_on") {
    // Without the key, the rest slides on from the rear end to its first position.
    start = base_x_max + 1 - rest_face_x(0);
    steps = ceil((start + rest_adjust_range) / rest_index_pitch);
    intersection() {
        union() { fixed_parts(); finger_grip(); }
        for (i = [0 : steps])
            lifted() palm_rest(max(-rest_adjust_range, start - i * rest_index_pitch));
    }
} else if (mode == "finger_entry") {
    // Minimum drafted pocket envelope and its unobstructed +Z approach.
    intersection() {
        dyno_rounded_prism_xy(
            hangboard_opening_x_min + hangboard_draft + 0.01,
            hangboard_opening_x_max - hangboard_draft - 0.01,
            hangboard_opening_y_min + hangboard_draft + 0.01,
            hangboard_opening_y_max - hangboard_draft - 0.01,
            hangboard_pocket_back_z + 0.01, hangboard_front_z + 40,
            hangboard_opening_r - hangboard_draft
        );
        union() {
            fixed_parts(); finger_grip(); eye_clips();
            palm_rest(-rest_adjust_range); index_key(-rest_adjust_range);
            crimpdeq_case_reference();
        }
    }
} else if (mode == "pocket_floor") {
    // The pocket cutter must stop at the nominal floor, not below it.
    intersection() {
        finger_grip();
        translate([(hangboard_opening_x_min + hangboard_opening_x_max) / 2,
            0, hangboard_pocket_back_z - 0.02])
            cube([2, 2, 0.01]);
    }
} else if (mode == "stopper_pocket") {
    assert(test_position < stopper_count, "Stopper index out of range.");
    intersection() { finger_grip(); stopper_in_pocket(test_position, dz = 0.01); }
} else if (mode == "stopper_seated") {
    assert(test_position < stopper_count, "Stopper index out of range.");
    intersection() { finger_grip(); stopper_in_pocket(test_position, dz = -0.02); }
} else if (mode == "stopper_located") {
    // The pocket walls stop each stopper within its clearance in X and Y.
    assert(test_position < 2 * stopper_count, "Stopper index out of range.");
    shift = stopper_clearance + 0.1;
    intersection() {
        finger_grip();
        stopper_in_pocket(test_position % stopper_count,
            dx = test_position < stopper_count ? shift : 0,
            dy = test_position < stopper_count ? 0 : shift, dz = 0.01);
    }
} else if (mode == "stopper_stack_pocket") {
    // Both stoppers stacked, either one at the bottom, clear of the grip and
    // of each other.
    assert(test_position < 2, "Stack order must be 0-1.");
    intersection() {
        finger_grip();
        translate([0, 0, 0.01]) stacked_pocket_stoppers(test_position, dz_top = 0.01);
    }
    intersection() {
        pocket_stopper(test_position);
        translate([0, 0, stopper_t_list[test_position] + 0.01])
            pocket_stopper(1 - test_position);
    }
} else if (mode == "stopper_stack_contact") {
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
        finger_grip();
        translate([test_position < 2 ? shift : 0, test_position < 2 ? 0 : shift,
                   stopper_t_list[bottom] + 0.01])
            pocket_stopper(1 - bottom);
    }
} else if (mode == "stopper_finger_width") {
    // Nothing stands above the top stopper's plate, alone or stacked.
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
    // On the pocket floor, each pull tab stands above the grip top.
    assert(test_position < 2, "Stopper index out of range.");
    intersection() {
        pocket_stopper(test_position);
        translate([-500, -500, hangboard_front_z + stopper_tab_rise - 1])
            cube([1000, 1000, 0.5]);
    }
} else if (mode == "stopper_stored") {
    intersection() {
        lifted() stored_pocket_stoppers();
        union() {
            fixed_parts(); finger_grip(); eye_clips(); crimpdeq_case_reference();
        }
    }
} else if (mode == "phone_slot") {
    // The largest phone clears everything in either orientation.
    intersection() {
        union() {
            phone_reference(portrait = false, drop = -0.02);
            phone_reference(portrait = true, drop = -0.02);
        }
        union() {
            fixed_parts(); finger_grip(); eye_clips(); crimpdeq_case_reference();
            palm_rest(-rest_adjust_range); index_key(-rest_adjust_range);
            stored_pocket_stoppers();
        }
    }
} else if (mode == "phone_seated") {
    intersection() { base_front(); phone_reference(drop = 0.02); }
} else if (mode == "stopper_stored_seated") {
    intersection() { base_front(); lifted(-0.02) stored_pocket_stoppers(); }
} else {
    assert(false, str("Unknown collision mode: ", mode));
}
