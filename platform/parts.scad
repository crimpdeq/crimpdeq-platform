//
// Printable parts of the all-printed Crimpdeq finger dynamometer.
// No top-level geometry: use assembly.scad for preview/export.
//

include <dimensions.scad>
// Bundled so every machine engraves the brand in Inter, not a fallback font.
use <fonts/Inter-Bold.ttf>

render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

module dyno_rounded_rect_2d(x_min, x_max, y_min, y_max, r) {
    w = x_max - x_min;
    h = y_max - y_min;
    rr = max(0, min(r, min(w, h) / 2 - 0.01));

    if (rr > 0)
        translate([x_min + rr, y_min + rr])
            offset(r = rr)
                square([w - 2 * rr, h - 2 * rr], center = false);
    else
        translate([x_min, y_min])
            square([w, h], center = false);
}

module dyno_rounded_prism_xy(x_min, x_max, y_min, y_max, z_min, z_max, r) {
    translate([0, 0, z_min])
        linear_extrude(height = z_max - z_min, center = false)
            dyno_rounded_rect_2d(x_min, x_max, y_min, y_max, r);
}

module dyno_rounded_box_xyz(center_v, size_v, r) {
    rr = min(r, min(size_v) / 2 - 0.01);
    hull()
        for (x_sign = [-1, 1])
            for (y_sign = [-1, 1])
                for (z_sign = [-1, 1])
                    translate([
                        center_v[0] + x_sign * (size_v[0] / 2 - rr),
                        center_v[1] + y_sign * (size_v[1] / 2 - rr),
                        center_v[2] + z_sign * (size_v[2] / 2 - rr)
                    ])
                        sphere(r = rr);
}

// Extrudes an XZ profile along Y, centred on y = 0.
module xz_profile_along_y(length) {
    rotate([90, 0, 0])
        linear_extrude(height = length, center = true)
            children();
}

// --- Eye lugs and clips (modelled on the +X side, mirrored for the anchor)

module tongue_2d(x_end) {
    // Round the right eye and out to x_end, u_slot_clear inside the case's
    // U-slot.
    translate([dyno_eye_x_right, dyno_eye_y]) circle(r = tongue_r);
    translate([dyno_eye_x_right, dyno_eye_y - tongue_r])
        square([x_end - dyno_eye_x_right, 2 * tongue_r]);
}

module tongue(x_end) {
    // From the deck up to the load cell's underside, which rests on it.
    translate([0, 0, deck_z - 0.01])
        linear_extrude(height = loadcell_bottom_z - deck_z + 0.01)
            tongue_2d(x_end);
}

module eye_lug() {
    // Round lug filling the right eye, then a neck for the clip and a head
    // with a flat underside ring, a printable chamfer and a lead-in on top.
    // Above the load cell both are cut flat inboard.
    translate([dyno_eye_x_right, dyno_eye_y, loadcell_bottom_z - 1])
        cylinder(r = lug_r, h = loadcell_top_z - loadcell_bottom_z + 1);
    intersection() {
        translate([dyno_eye_x_right, dyno_eye_y, 0]) {
            translate([0, 0, loadcell_top_z - 0.01])
                cylinder(r = lug_neck_r, h = lug_head_z_min - loadcell_top_z + 0.02);
            translate([0, 0, lug_head_z_min])
                cylinder(r1 = lug_neck_r + lug_head_flat_w, r2 = lug_r, h = lug_head_chamfer);
            translate([0, 0, lug_head_z_min + lug_head_chamfer - 0.01])
                cylinder(r = lug_r,
                    h = lug_top_z - lug_top_chamfer - lug_head_z_min - lug_head_chamfer + 0.02);
            translate([0, 0, lug_top_z - lug_top_chamfer])
                cylinder(r1 = lug_r, r2 = lug_r - lug_top_chamfer, h = lug_top_chamfer);
        }
        translate([lug_upper_flat_x, -lug_r - 1, loadcell_top_z - 1])
            cube([2 * lug_r + 2, 2 * lug_r + 2, lug_top_z - loadcell_top_z + 2]);
    }
}

module eye_clip_right(dx = 0) {
    // Fork round the right lug's neck, lying on the load cell, with a pull
    // fin at its outboard end. dx moves it outboard, toward its fitting
    // position.
    c = dyno_eye_x_right;
    translate([dx, 0, 0]) {
        difference() {
            intersection() {
                translate([0, 0, loadcell_top_z])
                    linear_extrude(height = clip_t)
                        tongue_2d(c + clip_tail_x);
                translate([c - clip_tip_x, -50, 0]) cube([100, 100, 50]);
            }
            translate([c, dyno_eye_y, 0]) cylinder(r = clip_seat_r, h = 50);
            translate([c - tongue_r - 1, dyno_eye_y - clip_mouth_w / 2, 0])
                cube([tongue_r + 1, clip_mouth_w, 50]);
        }
        translate([c + clip_tail_x - clip_fin_t, dyno_eye_y - clip_fin_w_y / 2,
                   loadcell_top_z + clip_t - 0.01])
            cube([clip_fin_t, clip_fin_w_y, clip_fin_top_z - loadcell_top_z - clip_t + 0.01]);
    }
}

module eye_clip(side = "right", dx = 0) {
    if (side == "right")
        eye_clip_right(dx);
    else
        mirror([1, 0, 0]) eye_clip_right(dx);
}

module eye_clips() {
    eye_clip("left");
    eye_clip("right");
}

// --- Anchor block --------------------------------------------------------

module anchor_block() {
    mirror([1, 0, 0]) {
        // Lower block in the base pocket, below the floating case.
        dyno_rounded_prism_xy(grip_x_min, -anchor_x_min,
            -anchor_half_w_y, anchor_half_w_y, anchor_z_min, deck_z, 3);
        tongue(-anchor_x_min);
        eye_lug();
    }
}

// --- Finger grip ---------------------------------------------------------

module hangboard_rim_section(angle) {
    // Quarter-circle on the loaded +X edge. Other walls stay full thickness.
    relief = hangboard_lip_radius * (1 - cos(angle));
    z = hangboard_front_z - hangboard_lip_radius + hangboard_lip_radius * sin(angle);
    dyno_rounded_prism_xy(
        hangboard_opening_x_min, hangboard_opening_x_max + relief,
        hangboard_opening_y_min, hangboard_opening_y_max,
        z, z + 0.01, hangboard_opening_r
    );
}

module hangboard_pocket_cut() {
    hull() {
        // Exact floor datum; the draft narrows the floor at the end walls.
        dyno_rounded_prism_xy(
            hangboard_opening_x_min,
            hangboard_opening_x_max,
            hangboard_opening_y_min + hangboard_draft,
            hangboard_opening_y_max - hangboard_draft,
            hangboard_pocket_back_z,
            hangboard_pocket_back_z + 0.01,
            max(1, hangboard_opening_r - hangboard_draft)
        );
        hangboard_rim_section(0);
    }
    steps = max(6, ceil(render_fn / 4));
    for (i = [0 : steps - 1])
        hull() {
            hangboard_rim_section(90 * i / steps);
            hangboard_rim_section(90 * (i + 1) / steps);
        }
    dyno_rounded_prism_xy(
        hangboard_opening_x_min, hangboard_opening_x_max + hangboard_lip_radius,
        hangboard_opening_y_min, hangboard_opening_y_max,
        hangboard_front_z, hangboard_front_z + 0.2, hangboard_opening_r
    );
}

module stopper_tab_slots(x_center = stopper_center_x, z_min = hangboard_pocket_back_z,
        z_max = hangboard_front_z) {
    // Vertical slots in both pocket end walls, from the floor to the top.
    for (y_span = [[stopper_tab_slot_y_min, stopper_y_min + 1],
                   [stopper_y_max - 1, stopper_tab_slot_y_max]])
        translate([x_center - stopper_tab_slot_w_x / 2, y_span[0], z_min])
            cube([stopper_tab_slot_w_x, y_span[1] - y_span[0], z_max + 0.1 - z_min]);
}

module finger_grip() {
    difference() {
        union() {
            dyno_rounded_prism_xy(grip_body_x_min, grip_x_max,
                -grip_half_w_y, grip_half_w_y, grip_z_min, hangboard_front_z, 4);
            // Lower body under the floating case, out to the tongue.
            dyno_rounded_prism_xy(grip_x_min, grip_body_x_min + 5,
                -grip_half_w_y, grip_half_w_y, grip_z_min, deck_z, 4);
            tongue(grip_body_x_min + 1);
        }
        hangboard_pocket_cut();
        stopper_tab_slots();
    }
    eye_lug();
}

// --- Edge liner ----------------------------------------------------------

module liner_2d() {
    // Right-hand footprint with its back face on x = 0 and the finger steps
    // toward -X, rounded where they meet. The back corners follow the
    // pocket's corners.
    r = liner_step_r;
    intersection() {
        offset(r = r) offset(delta = -2 * r) offset(r = r)
            for (i = [0 : len(liner_finger_steps) - 1]) {
                y0 = i == 0 ? liner_y_min - 2 * r : liner_finger_y(i) - liner_finger_w_y / 2;
                y1 = i == len(liner_finger_steps) - 1
                    ? liner_y_max + 2 * r : liner_finger_y(i) + liner_finger_w_y / 2;
                translate([-liner_t(i), y0]) square([liner_t(i) + 2 * r, y1 - y0]);
            }
        dyno_rounded_rect_2d(-liner_t_max - 1, 0, liner_y_min, liner_y_max,
            hangboard_opening_r);
    }
}

module liner_relieved_2d(relief) {
    // The footprint with its stepped face set back by relief.
    intersection() {
        liner_2d();
        translate([relief, 0]) liner_2d();
    }
}

module liner_cap() {
    // The top piece, its stepped face rounded like the lip along both long
    // edges so it can be turned over.
    h = liner_cap_h;
    r = hangboard_lip_radius;
    steps = max(6, ceil(render_fn / 4));
    translate([0, 0, r - 0.01])
        linear_extrude(height = h - 2 * r + 0.02) liner_2d();
    for (z_sign = [-1, 1])
        translate([0, 0, h / 2])
            mirror([0, 0, z_sign < 0 ? 1 : 0])
                for (k = [1 : steps])
                    translate([0, 0, h / 2 - r + (k - 1) * r / steps])
                        linear_extrude(height = r / steps + (k < steps ? 0.01 : 0))
                            liner_relieved_2d(r - sqrt(r * r - pow(k * r / steps, 2)));
}

module liner_piece(i) {
    // Liner piece i on z = 0, back face on x = 0: a spacer, or the cap.
    if (i < stopper_count)
        linear_extrude(height = liner_piece_h(i)) liner_2d();
    else
        liner_cap();
}

module liner_stack(pieces) {
    // The listed pieces stacked from z = 0, bottom first.
    for (k = [0 : len(pieces) - 1])
        translate([0, 0, liner_piece_z(pieces, k)]) liner_piece(pieces[k]);
}

module edge_liner(hand = "right", stoppers = []) {
    // The liner against the lip, stacked on the listed stoppers, for the
    // right or the left hand.
    assert(hand == "right" || hand == "left", str("Unknown hand: ", hand));
    translate([hangboard_opening_x_max - liner_clearance, 0,
               hangboard_pocket_back_z + stoppers_h(stoppers)])
        mirror([0, hand == "left" ? 1 : 0, 0])
            liner_stack(liner_pieces_over(stoppers));
}

// --- Pocket stoppers -----------------------------------------------------

module stopper_tab(i) {
    // Pull tab with a rounded top, standing proud of the grip top when the
    // stopper sits on the pocket floor.
    y0 = stopper_tab_y_min(i);
    r = stopper_tab_w_x / 2;
    hull() {
        translate([stopper_center_x - r, y0, hangboard_pocket_back_z])
            cube([stopper_tab_w_x, stopper_tab_t_y, 0.01]);
        translate([stopper_center_x, y0, hangboard_pocket_back_z + stopper_tab_h - r])
            rotate([-90, 0, 0])
                cylinder(r = r, h = stopper_tab_t_y);
    }
}

module pocket_stopper(i) {
    // Stopper i on the pocket floor; its top face becomes the new edge.
    t = stopper_t_list[i];
    end_y = i == 0 ? stopper_y_min : stopper_y_max;
    union() {
        dyno_rounded_prism_xy(
            stopper_x_min, stopper_x_max, stopper_y_min, stopper_y_max,
            hangboard_pocket_back_z, hangboard_pocket_back_z + t, stopper_r
        );
        stopper_tab(i);
        // Fuse the tab to the plate within the plate thickness only.
        translate([stopper_center_x - stopper_tab_w_x / 2, end_y - 0.5,
                   hangboard_pocket_back_z])
            cube([stopper_tab_w_x, 1, t]);
    }
}

module stacked_pocket_stoppers(bottom = 0, dz_top = 0) {
    // Both stoppers in the pocket, stopper `bottom` on the floor.
    pocket_stopper(bottom);
    translate([0, 0, stopper_t_list[bottom] + dz_top])
        pocket_stopper(1 - bottom);
}

module stopper_well_transform() {
    // From the pocket frame into the storage well.
    translate([stopper_well_center_x - stopper_center_x, 0,
               stopper_well_z_min - hangboard_pocket_back_z])
        children();
}

module stored_pocket_stoppers() {
    stopper_well_transform() stacked_pocket_stoppers();
}

module stopper_well_cut() {
    c = stopper_well_clearance;
    stopper_well_transform() {
        dyno_rounded_prism_xy(
            stopper_x_min - c, stopper_x_max + c, stopper_y_min - c, stopper_y_max + c,
            hangboard_pocket_back_z, hangboard_pocket_back_z + stopper_well_depth_z + 0.1,
            stopper_r + c
        );
        stopper_tab_slots(stopper_center_x, hangboard_pocket_back_z,
            hangboard_pocket_back_z + stopper_well_depth_z);
    }
}

module stopper_leaf_cut() {
    // Relief behind the leaf and the bridged gap under it, open to the well.
    x0 = stopper_well_x_max;
    leaf_z_min = deck_z - stopper_leaf_h_z;
    translate([0, -stopper_leaf_len_y / 2, 0])
        difference() {
            translate([x0 - 0.01, 0, leaf_z_min - stopper_leaf_gap_z])
                cube([stopper_leaf_t_x + stopper_leaf_relief_x + 0.01, stopper_leaf_len_y,
                      stopper_leaf_h_z + stopper_leaf_gap_z + 0.1]);
            translate([x0 - 1, -1, leaf_z_min])
                cube([stopper_leaf_t_x + 1, stopper_leaf_len_y + 2, stopper_leaf_h_z + 1]);
        }
}

module stopper_snap_ridge() {
    // On the leaf's well face, above the stack: a 45-degree lead-in on top
    // and a 45-degree catch underneath.
    x0 = stopper_well_x_max + 0.01;
    r = stopper_snap_ridge;
    xz_profile_along_y(stopper_snap_len_y)
        polygon([[x0, stopper_snap_z], [x0 - r, stopper_snap_z + r],
                 [x0, stopper_snap_z + 2 * r]]);
}

module liner_well_transform() {
    // From the liner's own frame into its storage well, its length along X,
    // clamped with its thickest step against the outer (-Y) wall.
    translate([liner_well_center_x, liner_well_y_min + 0.01 + liner_t_max, liner_well_z_min])
        rotate([0, 0, 90])
            children();
}

module stored_liner(pieces = [for (i = [0 : liner_piece_count - 1]) i]) {
    if (len(pieces) > 0) liner_well_transform() liner_stack(pieces);
}

module liner_well_cut() {
    translate([liner_well_x_min, liner_well_y_min, liner_well_z_min])
        cube([liner_well_x_max - liner_well_x_min, liner_well_y_max - liner_well_y_min,
              deck_z - liner_well_z_min + 0.1]);
    liner_well_notches();
}

module liner_clamp_cut() {
    // Relief behind the clamp leaf and the bridged gap under it, open to the
    // well.
    y0 = liner_well_y_max;
    translate([liner_well_center_x - liner_clamp_len_x / 2, 0, 0])
        difference() {
            translate([0, y0 - 0.01, liner_well_z_min - liner_clamp_gap_z])
                cube([liner_clamp_len_x, liner_clamp_t_y + liner_clamp_relief_y + 0.01,
                      deck_z - liner_well_z_min + liner_clamp_gap_z + 0.1]);
            translate([-1, y0 - 1, liner_well_z_min])
                cube([liner_clamp_len_x + 2, liner_clamp_t_y + 1, deck_z - liner_well_z_min + 1]);
        }
}

module liner_clamp_pad() {
    // On the leaf's well face, from the well floor to a 45-degree lead-in at
    // the deck.
    y0 = liner_well_y_max + 0.01;
    p = liner_clamp_pad_y;
    along_x(liner_well_center_x - liner_clamp_pad_len_x / 2,
            liner_well_center_x + liner_clamp_pad_len_x / 2)
        polygon([[y0, liner_well_z_min], [y0 - p, liner_well_z_min],
                 [y0 - p, deck_z - p], [y0, deck_z]]);
}

module liner_well_notches() {
    // Finger notches at both ends, open through the side face.
    for (x0 = [liner_well_x_min - liner_well_notch_x, liner_well_x_max])
        translate([x0, -base_half_w_y - 1, liner_well_z_min])
            cube([liner_well_notch_x, liner_well_notch_y_max + base_half_w_y + 1,
                  deck_z - liner_well_z_min + 0.1]);
}

// --- Phone slot ----------------------------------------------------------

module phone_stand() {
    // Two solid cheeks rising from the deck; the slot is cut from their tops.
    for (side = [-1, 1])
        mirror([0, side < 0 ? 1 : 0, 0])
            dyno_rounded_prism_xy(base_x_min, phone_stand_x_max,
                phone_stand_gap_half_y, phone_stand_half_w_y,
                deck_z - 1, phone_stand_top_z, 3);
}

module phone_slot_cut() {
    // Leans toward -X so the screen faces the user; the flat floor holds the
    // phone's lower edge. Open at both sides for long phones.
    intersection() {
        translate([phone_slot_x_top, -base_half_w_y - 1, phone_stand_top_z])
            rotate([0, -phone_slot_tilt, 0])
                translate([-phone_slot_w, 0, -2 * phone_slot_depth_z])
                    cube([phone_slot_w, 2 * base_half_w_y + 2, 4 * phone_slot_depth_z]);
        translate([base_x_min - 1, -base_half_w_y - 2, phone_slot_z_min])
            cube([phone_slot_x_top - base_x_min + 10, 2 * base_half_w_y + 4,
                  phone_slot_depth_z + 1]);
    }
}

module phone_reference(portrait = false, drop = 0) {
    // Largest supported phone in its case, resting on the slot floor and
    // leaning against the slot's outer (-X) face.
    height = portrait ? phone_probe_l : phone_probe_w;
    width = portrait ? phone_probe_w : phone_probe_l;
    gap = (phone_slot_w - phone_probe_t) / 2;
    // Lowest (-X) bottom corner sits on the slot floor.
    corner_x = -phone_slot_w + gap;
    z0 = (phone_slot_z_min - phone_stand_top_z - corner_x * sin(phone_slot_tilt))
        / cos(phone_slot_tilt);
    translate([phone_slot_x_top, -width / 2, phone_stand_top_z - drop])
        rotate([0, -phone_slot_tilt, 0])
            translate([corner_x, 0, z0])
                cube([phone_probe_t, width, height]);
}

// --- Base ----------------------------------------------------------------

module base_slab() {
    dyno_rounded_prism_xy(base_x_min, base_x_max, -base_half_w_y, base_half_w_y,
        base_z_min, deck_z, base_corner_r);
    // Joint cheeks, raising the trench side walls across the split.
    for (y_sign = [-1, 1])
        dyno_rounded_box_xyz(
            [(joint_cheek_x_min + joint_cheek_x_max) / 2,
             y_sign * (base_half_w_y - joint_cheek_w_y / 2),
             (base_z_min + joint_cheek_top_z) / 2],
            [joint_cheek_x_max - joint_cheek_x_min, joint_cheek_w_y,
             joint_cheek_top_z - base_z_min],
            joint_cheek_r);
}

module joint_tongue_2d(grow = 0) {
    offset(delta = grow)
        polygon([
            [base_split_x - 1, -joint_tongue_neck_w / 2],
            [base_split_x, -joint_tongue_neck_w / 2],
            [base_split_x + joint_tongue_len_x, -joint_tongue_head_w / 2],
            [base_split_x + joint_tongue_len_x, joint_tongue_head_w / 2],
            [base_split_x, joint_tongue_neck_w / 2],
            [base_split_x - 1, joint_tongue_neck_w / 2]
        ]);
}

module joint_tongues(grow = 0) {
    for (y_pos = [-joint_tongue_y, joint_tongue_y])
        translate([0, y_pos, base_z_min - (grow > 0 ? 0.1 : 0)])
            linear_extrude(height = joint_tongue_z_max + grow - base_z_min
                    + (grow > 0 ? 0.1 : 0))
                joint_tongue_2d(grow);
}

module base_split_region(grow = 0) {
    // Everything at or before the split plane.
    big = 1000;
    translate([base_split_x + grow - big, -big / 2, -big / 2]) cube(big);
}

module anchor_pocket_cut() {
    translate([anchor_pocket_x_min, -anchor_pocket_half_w_y, anchor_z_min])
        cube([anchor_pocket_x_max - anchor_pocket_x_min, 2 * anchor_pocket_half_w_y,
              deck_z - anchor_z_min + 0.1]);
}

module grip_trench_cut() {
    // Ledges under the grip side walls, a deeper floor between them.
    translate([trench_x_min, -trench_half_w_y, grip_guide_z_max])
        cube([trench_x_max - trench_x_min, 2 * trench_half_w_y,
              deck_z - grip_guide_z_max + 0.1]);
    translate([trench_x_min, -grip_guide_inner_y, trench_floor_z])
        cube([trench_x_max - trench_x_min, 2 * grip_guide_inner_y,
              deck_z - trench_floor_z + 0.1]);
}

module rest_plate_2d(gap_y = 0, top_z = rest_heel_z) {
    // YZ profile of the heel plate, flaring toward its sole. A positive
    // gap_y widens it into the channel.
    half_w = rest_half_w_y + gap_y;
    top_w = half_w + rest_flare_y * (rest_heel_z - top_z) / rest_plate_t;
    polygon([
        [-half_w - rest_flare_y, rest_z_min],
        [half_w + rest_flare_y, rest_z_min],
        [top_w, top_z],
        [-top_w, top_z]
    ]);
}

module along_x(x_min, x_max) {
    // Extrudes a YZ profile along X.
    translate([x_min, 0, 0])
        rotate([90, 0, 90])
            linear_extrude(height = x_max - x_min)
                children();
}

module rest_channel_cut() {
    // The heel deck, lowered across the full width, and the dovetail channel
    // under it, open at the rear end.
    x_max = base_x_max + 1;
    translate([rest_channel_x_min, -base_half_w_y - 1, rest_heel_z])
        cube([x_max - rest_channel_x_min, 2 * base_half_w_y + 2,
              deck_z - rest_heel_z + 0.1]);
    along_x(rest_channel_x_min, x_max)
        rest_plate_2d(rest_side_gap_y, rest_heel_z + 0.1);
}

module base_key_grooves() {
    // Across the channel floor and through both side walls.
    for (i = [0 : rest_index_count - 1]) {
        key_groove(key_x(rest_offset(i)), base_half_w_y + 1, key_z_min);
        key_snap_recesses(key_x(rest_offset(i)));
    }
}

module key_snap_recesses(x_pos) {
    // For the barb of a seated key: in the tunnel floor of the -Y wall, and
    // in the roof of the +Y wall for a key turned over.
    half_y = key_snap_barb + key_snap_clearance;
    depth = key_snap_barb + key_snap_clearance;
    for (recess = [[key_snap_barb_y, key_z_min - depth, key_z_min + 0.01],
                   [-key_snap_barb_y, key_z_max + key_fit - 0.01, key_z_max + depth]])
        translate([x_pos - (key_t_x + key_fit) / 2, recess[0] - half_y, recess[1]])
            cube([key_t_x + key_fit, 2 * half_y, recess[2] - recess[1]]);
}

module engraved_text_2d(text, size) {
    text(text, size = size, font = brand_font, halign = "center", valign = "center");
}

module side_engraving(x_pos, z_pos, text, size) {
    // On both side faces, each reading from outside its face, cut from
    // inside the wall outward so the depth stays controlled.
    for (angle = [0, 180])
        translate([x_pos, 0, z_pos])
            rotate([0, 0, angle])
                translate([0, -base_half_w_y + brand_depth, 0])
                    rotate([90, 0, 0])
                        linear_extrude(height = brand_depth + 0.1)
                            engraved_text_2d(text, size);
}

module brand_engravings() {
    side_engraving(side_brand_x, side_brand_z, side_brand_text, side_brand_size);
}

module opening_labels() {
    for (i = [0 : rest_index_count - 1])
        side_engraving(key_x(rest_offset(i)), opening_label_z,
            str(rest_opening(i)), opening_label_size);
}

module base_front() {
    difference() {
        union() {
            intersection() {
                base_slab();
                base_split_region();
            }
            joint_tongues();
            phone_stand();
        }
        anchor_pocket_cut();
        grip_trench_cut();
        stopper_well_cut();
        stopper_leaf_cut();
        liner_well_cut();
        liner_clamp_cut();
        phone_slot_cut();
        brand_engravings();
    }
    stopper_snap_ridge();
    liner_clamp_pad();
}

module base_rear() {
    difference() {
        union() {
            difference() {
                base_slab();
                base_split_region();
            }
        }
        joint_tongues(joint_fit);
        grip_trench_cut();
        rest_channel_cut();
        base_key_grooves();
        opening_labels();
    }
}

module base() {
    base_front();
    base_rear();
}

// --- Palm rest and key ---------------------------------------------------

module palm_bolster(face_x) {
    // Bolster with a nearly flat top and rolled long edges, on the plate's top
    // and, past the plate, on wings that lie on the deck. Its -X face
    // continues the palm face.
    x_max = face_x + rest_bolster_depth_x;
    w = rest_bolster_half_w_y;
    shoulder_z = rest_bolster_z_max - max(rest_bolster_front_r, rest_bolster_rear_r);
    intersection() {
        hull() {
            dyno_rounded_prism_xy(face_x, x_max, -w, w, rest_heel_z, shoulder_z, rest_corner_r);
            for (edge = [[face_x + rest_bolster_front_r, rest_bolster_front_r],
                         [x_max - rest_bolster_rear_r, rest_bolster_rear_r]])
                for (y_pos = [-w + edge[1], w - edge[1]])
                    translate([edge[0], y_pos, rest_bolster_z_max - edge[1]])
                        sphere(r = edge[1], $fn = max(render_fn, 32));
        }
        // The rounds' lower halves would reach into the channel's walls.
        translate([face_x, -w, rest_heel_z])
            cube([rest_bolster_depth_x, 2 * w, rest_bolster_rise]);
    }
}

module key_groove(x_pos, half_w_y, z_min) {
    // Across the full width, with key_fit over the bar.
    translate([x_pos - (key_t_x + key_fit) / 2, -half_w_y, z_min])
        cube([key_t_x + key_fit, 2 * half_w_y, key_z_max + key_fit - z_min]);
}

module palm_rest(offset = 0) {
    face_x = rest_face_x(offset);
    difference() {
        union() {
            // Heel plate, captured in the base's dovetail channel.
            along_x(face_x, face_x + rest_depth_x) rest_plate_2d();
            palm_bolster(face_x);
        }
        // The key's groove across the sole, under the bolster.
        key_groove(key_x(offset), rest_half_w_y + rest_flare_y + 1, rest_z_min - 0.1);
    }
}

module index_key(offset = 0, pull = 0) {
    // Bar across the base with a chamfered tip at the -Y side, and a head
    // outside the +Y side that extends away from the fingers, and a snap
    // prong with a barb behind the tip. pull draws it out along +Y.
    x0 = key_x(offset) - key_t_x / 2;
    c = key_tip_chamfer;
    b = key_snap_barb;
    translate([x0, pull, 0]) {
        difference() {
            hull() {
                translate([0, key_y_min + c, key_z_min])
                    cube([key_t_x, key_bar_y_max - key_y_min - c + 0.01, key_h_z]);
                translate([c, key_y_min, key_z_min + c])
                    cube([key_t_x - 2 * c, c, key_h_z - 2 * c]);
            }
            translate([-1, key_y_min - 1, key_z_min + key_snap_prong_t])
                cube([key_t_x + 2, key_snap_len_y + 1, key_snap_gap_z]);
        }
        along_x(0, key_t_x)
            polygon([[key_snap_barb_y - b, key_z_min + 0.01],
                     [key_snap_barb_y, key_z_min - b],
                     [key_snap_barb_y + b, key_z_min + 0.01]]);
        translate([0, key_bar_y_max, key_head_z_min])
            rotate([-90, 0, 0])
                translate([0, -key_head_h, 0])
                    dyno_rounded_prism_xy(0, key_head_x, 0, key_head_h, 0, key_head_y, 2);
    }
}

// --- Print layouts -------------------------------------------------------

module on_side_layout(y_max) {
    // Lay the part on its +Y face so X and Z, the lug's bending plane, lie
    // in the layers.
    translate([0, 0, y_max])
        rotate([-90, 0, 0])
            children();
}

module print_layout(part) {
    if (part == "base_front")
        translate([-(base_x_min + base_split_x) / 2, 0, -base_z_min]) base_front();
    else if (part == "base_rear")
        translate([-(base_split_x + base_x_max) / 2, 0, -base_z_min]) base_rear();
    else if (part == "anchor")
        // Upright, like the grip: the pocket and lug build upward.
        translate([-(anchor_x_min + anchor_x_max) / 2, 0, -anchor_z_min]) anchor_block();
    else if (part == "grip")
        translate([-(grip_x_min + grip_x_max) / 2, 0, -grip_z_min]) finger_grip();
    else if (part == "clips")
        // Flat on their clamp faces, fins up, side by side.
        for (i = [0, 1])
            translate([-dyno_eye_x_right, (i - 0.5) * (2 * tongue_r + 8),
                       -loadcell_top_z])
                eye_clip_right();
    else if (part == "key")
        // On its -X face, lying along X, so the shear plane at the channel
        // floor lies across the layers.
        rotate([0, 0, -90])
            translate([0, -(key_y_min + key_bar_y_max + key_head_y) / 2, 0])
                rotate([0, -90, 0])
                    translate([-(key_x(0) - key_t_x / 2), 0, -(key_z_min + key_z_max) / 2])
                        index_key();
    else if (part == "rest")
        // Turned so its wide bolster runs along X.
        rotate([0, 0, 90])
            translate([-rest_face_x() - rest_depth_x / 2, 0, -rest_z_min]) palm_rest();
    else if (part == "liner")
        // On their back faces, steps up, side by side along X.
        for (i = [0 : liner_piece_count - 1])
            translate([liner_layout_x(i) - liner_layout_w / 2, 0, 0])
                rotate([0, 90, 0]) liner_piece(i);
    else if (part == "stoppers")
        // Flat, side by side, long sides along X.
        rotate([0, 0, 90])
        for (i = [0 : stopper_count - 1])
            translate([(i - (stopper_count - 1) / 2) * (stopper_x_max - stopper_x_min + 8)
                       - stopper_center_x, 0, -hangboard_pocket_back_z])
                pocket_stopper(i);
    else
        assert(false, str("Unknown part: ", part));
}

liner_layout_gap = 8;
function liner_layout_x(i) = i == 0 ? 0 : liner_layout_x(i - 1) + liner_piece_h(i - 1) + liner_layout_gap;
liner_layout_w = liner_layout_x(liner_piece_count - 1) + liner_piece_h(liner_piece_count - 1);

// Minimum X/Y corner of each print layout.
function print_layout_min(part) =
    part == "base_front" ? [(base_x_min - base_split_x) / 2, -base_half_w_y]
    : part == "base_rear" ? [-(base_x_max - base_split_x) / 2, -base_half_w_y]
    : part == "anchor" ? [-(anchor_x_max - anchor_x_min) / 2, -anchor_half_w_y]
    : part == "grip" ? [-(grip_x_max - grip_x_min) / 2, -grip_half_w_y]
    : part == "clips" ? [-clip_tip_x, -2 * tongue_r - 4]
    : part == "key" ? [-(key_bar_y_max + key_head_y - key_y_min) / 2, -key_head_h / 2]
    : part == "stoppers" ? [stopper_tab_y_min(0), -(stopper_x_max - stopper_x_min) - 4]
    : part == "rest" ? [-max(rest_bolster_half_w_y, rest_half_w_y + rest_flare_y), -rest_depth_x / 2]
    : part == "liner" ? [-liner_layout_w / 2, liner_y_min]
    : undef;

// Front-left corner of each part on its plate, origin at the front-left bed
// corner. Plate 1 holds the front base half, the grip, the anchor block and
// the clips; plate 2 the rear base half, the liner, the palm rest, the
// stoppers and the key. Shared by the book's plate images and the Bambu
// Studio project.
function print_plate_corner(part) =
    part == "base_front" ? [10, 10]
    : part == "grip" ? [10, 150]
    : part == "anchor" ? [115, 150]
    : part == "clips" ? [172, 150]
    : part == "base_rear" ? [10, 10]
    : part == "liner" ? [195, 10]
    : part == "rest" ? [10, 147]
    : part == "stoppers" ? [133, 147]
    : part == "key" ? [10, 227]
    : undef;

module print_plate_placement(part) {
    corner = print_plate_corner(part);
    assert(!is_undef(corner), str("Unknown part: ", part));
    translate(concat(corner - print_layout_min(part), [0]))
        children();
}
