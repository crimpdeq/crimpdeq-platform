//
// Native parametric parts for the standalone Crimpdeq hand dynamometer.
// No top-level geometry: use dynamometer_assembly.scad for preview/export.
//

include <dynamometer_dimensions.scad>

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

module clevis_cheek_pair(x_min, x_max) {
    dyno_rounded_prism_xy(
        x_min, x_max,
        -clevis_width_y / 2, clevis_width_y / 2,
        frame_z_min, frame_z_min + clevis_plate_t,
        min(4, clevis_end_r)
    );
    dyno_rounded_prism_xy(
        x_min, x_max,
        -clevis_width_y / 2, clevis_width_y / 2,
        frame_z_max - clevis_plate_t, frame_z_max,
        min(4, clevis_end_r)
    );
}

module vertical_pin_bore(x_pos) {
    translate([x_pos, dyno_eye_y, frame_z_min - 0.1])
        cylinder(d = pin_hole_d, h = frame_depth_z + 0.2, center = false);
}

module wrist_index_bores() {
    for (y_pos = [wrist_mount_y_bottom, wrist_mount_y_top])
        for (index = [0 : wrist_index_count - 1])
            translate([
                wrist_mount_x - wrist_adjust_range + index * wrist_index_pitch,
                y_pos,
                frame_z_min - 0.1
            ])
                cylinder(
                    d = wrist_index_hole_d,
                    h = frame_depth_z + 0.2,
                    center = false
                );
}

module fixed_frame_body() {
    union() {
        dyno_rounded_prism_xy(
            frame_x_min, frame_palm_post_outer_x,
            frame_inner_y_max, frame_outer_y_max,
            frame_z_min, frame_z_max,
            frame_corner_r
        );
        dyno_rounded_prism_xy(
            frame_x_min, frame_palm_post_outer_x,
            frame_outer_y_min, frame_inner_y_min,
            frame_z_min, frame_z_max,
            frame_corner_r
        );
        // Left anchor post plus the unloaded accessory block outboard of it.
        dyno_rounded_prism_xy(
            frame_x_min, frame_left_post_inner_x,
            frame_outer_y_min, frame_outer_y_max,
            frame_z_min, frame_z_max,
            frame_corner_r
        );
        dyno_rounded_prism_xy(
            frame_palm_post_inner_x, frame_palm_post_outer_x,
            frame_outer_y_min, frame_outer_y_max,
            frame_z_min, frame_z_max,
            frame_corner_r
        );
    }
}

module frame_support_feet() {
    for (x_pos = [support_foot_x_left, support_foot_x_right])
        for (y_pos = [support_foot_y_bottom, support_foot_y_top])
            dyno_rounded_prism_xy(
                x_pos - support_foot_w_x / 2, x_pos + support_foot_w_x / 2,
                y_pos - support_foot_w_y / 2, y_pos + support_foot_w_y / 2,
                support_foot_bottom_z, support_foot_top_z, 2
            );
}

module service_tunnel_cut() {
    translate([
        0,
        (service_tunnel_y_min + service_tunnel_y_max) / 2,
        (service_tunnel_z_min + service_tunnel_z_max) / 2
    ])
        cube([
            service_tunnel_w,
            service_tunnel_y_max - service_tunnel_y_min,
            service_tunnel_z_max - service_tunnel_z_min
        ], center = true);
}

module wrist_post_channel_cut() {
    // Only the middle of the right-hand closing post is relieved. The fixed
    // side rails and the lower post stay continuous across all nine settings.
    dyno_rounded_box_xyz(
        [(frame_palm_post_inner_x + frame_palm_post_outer_x) / 2,
         (wrist_post_channel_y_min + wrist_post_channel_y_max) / 2,
         (wrist_post_channel_z_min + frame_z_max + 2) / 2],
        [frame_palm_post_t + 8,
         wrist_post_channel_y_max - wrist_post_channel_y_min,
         frame_z_max + 2 - wrist_post_channel_z_min], 2
    );
}

module grip_guides() {
    // Ledges on both rail inner faces under the grip's side walls.
    for (side = [[frame_inner_y_min - 1, frame_inner_y_min + grip_guide_w_y],
                 [frame_inner_y_max - grip_guide_w_y, frame_inner_y_max + 1]])
        dyno_rounded_prism_xy(
            grip_guide_x_min, grip_guide_x_max,
            side[0], side[1],
            grip_guide_z_min, grip_guide_z_max, 1
        );
}

module stopper_well_cut() {
    dyno_rounded_prism_xy(
        stopper_well_x_min, stopper_well_x_max,
        stopper_well_y_min, stopper_well_y_max,
        stopper_well_z_min, frame_z_max + 0.1,
        stopper_r + stopper_well_clearance
    );
    // Room for the pull tabs at both ends.
    stopper_tab_slots((stopper_well_x_min + stopper_well_x_max) / 2, stopper_well_z_min);
}

module phone_slot_cut() {
    // Leans toward -X so the screen faces the user; the flat floor holds the
    // phone's lower edge. Open at both rail ends for long phones.
    intersection() {
        translate([phone_slot_x_top, frame_outer_y_min - 1, frame_z_max])
            rotate([0, -phone_slot_tilt, 0])
                translate([-phone_slot_w, 0, -2 * phone_slot_depth_z])
                    cube([phone_slot_w,
                          frame_outer_y_max - frame_outer_y_min + 2,
                          4 * phone_slot_depth_z]);
        translate([frame_x_min - 1, frame_outer_y_min - 2, phone_slot_z_min])
            cube([frame_accessory_len_x + 2,
                  frame_outer_y_max - frame_outer_y_min + 4,
                  phone_slot_depth_z + 1]);
    }
}

module fixed_frame() {
    difference() {
        union() {
            fixed_frame_body();
            frame_support_feet();
            clevis_cheek_pair(fixed_clevis_x_min, fixed_clevis_x_max);
            grip_guides();
        }
        vertical_pin_bore(dyno_eye_x_left);
        wrist_index_bores();
        wrist_post_channel_cut();
        service_tunnel_cut();
        frame_split_bolt_cuts();
        stopper_well_cut();
        phone_slot_cut();
    }
}

module frame_split_bolt_cuts() {
    // Through holes with top-face head counterbores and lower-face hex nut
    // pockets. The pocket corners point along the rail (X).
    for (x_pos = frame_split_bolt_x)
        for (y_pos = frame_split_bolt_y)
            translate([x_pos, y_pos, 0]) {
                translate([0, 0, frame_z_min - 0.1])
                    cylinder(d = frame_split_bolt_hole_d, h = frame_depth_z + 0.2);
                translate([0, 0, frame_split_bolt_head_z])
                    cylinder(d = frame_split_bolt_cbore_d,
                        h = frame_z_max - frame_split_bolt_head_z + 0.1);
                translate([0, 0, frame_z_min - 0.1])
                    cylinder(d = frame_split_nut_pocket_af / cos(30),
                        h = frame_split_nut_pocket_depth + 0.1, $fn = 6);
            }
}

module frame_split_left_region(grow = 0) {
    // Everything left of the lap, plus the upper tongue across it. A positive
    // grow enlarges the region, a negative one shrinks it (probes only).
    big = 1000;
    translate([frame_split_x_min + grow - big, -big / 2, -big / 2])
        cube(big);
    translate([frame_split_x_max + grow - big, -big / 2, frame_split_lap_z - grow])
        cube(big);
}

module fixed_frame_half(side = "left") {
    // The halves meet on the half-lap faces of both rails.
    if (side == "left")
        intersection() {
            fixed_frame();
            frame_split_left_region();
        }
    else
        difference() {
            fixed_frame();
            frame_split_left_region();
        }
}

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
        // Exact floor datum; the draft narrows the floor by hangboard_draft
        // on every side.
        dyno_rounded_prism_xy(
            hangboard_opening_x_min + hangboard_draft,
            hangboard_opening_x_max - hangboard_draft,
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

module moving_finger_grip() {
    difference() {
        union() {
            // Four-finger body surrounding a recessed hangboard-style pocket.
            dyno_rounded_prism_xy(
                hangboard_body_x_min,
                hangboard_body_x_max,
                hangboard_body_y_min,
                hangboard_body_y_max,
                hangboard_back_z,
                hangboard_front_z,
                8
            );

            // Full-depth left wall joins the pocket body to both clevis cheeks
            // while leaving the +Z finger opening unobstructed.
            dyno_rounded_prism_xy(
                hangboard_body_x_min,
                hangboard_opening_x_min,
                -finger_yoke_spine_y / 2, finger_yoke_spine_y / 2,
                frame_z_min, frame_z_max,
                2
            );

            clevis_cheek_pair(moving_clevis_x_min, moving_clevis_x_max);
        }

        vertical_pin_bore(dyno_eye_x_right);
        hangboard_pocket_cut();
        stopper_tab_slots();
    }
}

module wrist_side_arms(z_min, z_max, x_max = wrist_arm_x_max) {
    top_y_min = wrist_pad_y_max - wrist_arm_pad_overlap_y;
    top_y_max = wrist_mount_y_top + wrist_arm_h_y / 2;
    bottom_y_min = wrist_mount_y_bottom - wrist_arm_h_y / 2;
    bottom_y_max = wrist_pad_y_min + wrist_arm_pad_overlap_y;

    difference() {
        union() {
            dyno_rounded_prism_xy(
                wrist_arm_x_min, x_max,
                top_y_min, top_y_max,
                z_min, z_max,
                4
            );
            dyno_rounded_prism_xy(
                wrist_arm_x_min, x_max,
                bottom_y_min, bottom_y_max,
                z_min, z_max,
                4
            );
        }

        for (y_pos = [wrist_mount_y_bottom, wrist_mount_y_top])
            translate([wrist_mount_x, y_pos, z_min - 0.1])
                cylinder(d = wrist_mount_hole_d, h = z_max - z_min + 0.2);

        // Tie each pin lanyard through the pad so neither pin can be lost.
        for (y_pos = [wrist_lanyard_y_bottom, wrist_lanyard_y_top])
            translate([wrist_lanyard_x, y_pos, z_min - 0.1])
                cylinder(d = wrist_lanyard_hole_d, h = z_max - z_min + 0.2);
    }
}

module wrist_palm_face_clear_cut() {
    // Across the pad width, the upper arms may not project ahead of the palm
    // face or through the bolster's rear radius; the bolster is their root.
    for (x_span = [[wrist_arm_x_min - 1, wrist_saddle_x_min],
                   [wrist_palm_bolster_x_max - wrist_palm_bolster_rear_r - 1,
                    wrist_upper_arm_x_max + 1]])
        translate([x_span[0], wrist_pad_y_min - 0.01, wrist_saddle_z_min])
            cube([x_span[1] - x_span[0],
                  wrist_pad_y_max - wrist_pad_y_min + 0.02,
                  wrist_plate_z_max_2 + 1 - wrist_saddle_z_min]);
}

module palm_bolster() {
    // Straight full-width bolster with a nearly flat top and large rolled
    // long edges. The flat -X face is coplanar with the palm face below it.
    shoulder_z = wrist_palm_bolster_z_max
        - max(wrist_palm_bolster_front_r, wrist_palm_bolster_rear_r);
    hull() {
        dyno_rounded_prism_xy(
            wrist_palm_bolster_x_min, wrist_palm_bolster_x_max,
            wrist_pad_y_min, wrist_pad_y_max,
            wrist_palm_bolster_z_min, shoulder_z, wrist_pad_corner_r
        );
        for (edge = [[wrist_palm_bolster_x_min + wrist_palm_bolster_front_r,
                      wrist_palm_bolster_front_r],
                     [wrist_palm_bolster_x_max - wrist_palm_bolster_rear_r,
                      wrist_palm_bolster_rear_r]])
            for (y_pos = [wrist_pad_y_min + edge[1], wrist_pad_y_max - edge[1]])
                translate([edge[0], y_pos, wrist_palm_bolster_z_max - edge[1]])
                    sphere(r = edge[1], $fn = max(render_fn, 32));
    }
}

module palm_bolster_fillet() {
    // Concave fillet from the bolster's rear face and rear corners into the
    // deck, approximated by tapered offsets of the bolster plan outline.
    r = wrist_palm_bolster_fillet_r;
    steps = max(4, ceil(render_fn / 6));
    function run(h) = r - sqrt(r * r - (r - h) * (r - h));
    intersection() {
        for (i = [0 : steps - 1])
            hull()
                for (h = [r * i / steps, r * (i + 1) / steps])
                    translate([0, 0, wrist_saddle_z_max - 0.01 + h])
                        linear_extrude(height = 0.01)
                            offset(delta = run(h))
                                dyno_rounded_rect_2d(
                                    wrist_palm_bolster_x_min, wrist_palm_bolster_x_max,
                                    wrist_pad_y_min, wrist_pad_y_max, wrist_pad_corner_r
                                );
        translate([wrist_palm_bolster_x_min,
                   wrist_pad_y_min + wrist_cradle_edge_radius,
                   wrist_saddle_z_max - 1])
            cube([wrist_saddle_depth_x,
                  wrist_pad_y_max - wrist_pad_y_min - 2 * wrist_cradle_edge_radius,
                  r + 2]);
    }
}

module rounded_palm_cradle() {
    // Low side lips and one straight palm bolster on the finger-facing (-X)
    // edge. The open palm/heel contact surface is not hollowed or pierced.
    for (y_pos = [wrist_pad_y_min + wrist_cradle_edge_w / 2,
                  wrist_pad_y_max - wrist_cradle_edge_w / 2])
        dyno_rounded_box_xyz(
            [(wrist_saddle_x_min + wrist_saddle_x_max) / 2,
             y_pos, (wrist_cradle_z_min + wrist_cradle_z_max) / 2],
            [wrist_saddle_depth_x, wrist_cradle_edge_w,
             wrist_cradle_z_max - wrist_cradle_z_min], wrist_cradle_edge_radius
        );
    palm_bolster();
    palm_bolster_fillet();
}

module adjustable_wrist_rest(x_offset = 0) {
    translate([x_offset, 0, 0])
        union() {
            wrist_side_arms(wrist_plate_z_min_1, wrist_plate_z_max_1);
            difference() {
                wrist_side_arms(wrist_plate_z_min_2, wrist_plate_z_max_2,
                    wrist_upper_arm_x_max);
                wrist_palm_face_clear_cut();
            }

            // Continuous upright palm face. Its upper end shares the deck's
            // top datum and edge radius, avoiding a groove at the transition.
            dyno_rounded_box_xyz(
                [
                    wrist_pad_center_x,
                    (wrist_pad_y_min + wrist_pad_y_max) / 2,
                    (wrist_rest_z_min + wrist_saddle_z_max) / 2
                ],
                [
                    wrist_pad_t_x,
                    wrist_pad_y_max - wrist_pad_y_min,
                    wrist_saddle_z_max - wrist_rest_z_min
                ],
                wrist_pad_corner_r
            );

            // Broad, unperforated heel deck extending away from the fingers.
            // It travels WITH the palm face; no rail holes, seams or pin heads
            // interrupt the skin-contact area. The underside clears the frame.
            dyno_rounded_box_xyz(
                [
                    (wrist_saddle_x_min + wrist_saddle_x_max) / 2,
                    (wrist_pad_y_min + wrist_pad_y_max) / 2,
                    (wrist_saddle_z_min + wrist_saddle_z_max) / 2
                ],
                [wrist_saddle_depth_x, wrist_pad_y_max - wrist_pad_y_min, wrist_saddle_t],
                wrist_pad_corner_r
            );

            rounded_palm_cradle();
        }
}

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
    // Stopper i on the pocket floor; its top face becomes the new edge. The
    // tab sits outside the plate, on its end face.
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

module stopper_tab_slots(x_center = stopper_center_x, z_min = hangboard_pocket_back_z) {
    for (y_span = [[stopper_tab_slot_y_min, stopper_y_min + 1],
                   [stopper_y_max - 1, stopper_tab_slot_y_max]])
        translate([x_center - stopper_tab_slot_w_x / 2, y_span[0], z_min])
            cube([stopper_tab_slot_w_x, y_span[1] - y_span[0],
                  frame_z_max + 0.1 - z_min]);
}

module stacked_pocket_stoppers(bottom = 0, dz_top = 0) {
    // Both stoppers in the pocket, stopper `bottom` on the floor.
    pocket_stopper(bottom);
    translate([0, 0, stopper_t_list[bottom] + dz_top])
        pocket_stopper(1 - bottom);
}

module stored_pocket_stoppers() {
    // Both stoppers stacked in the frame's storage well.
    translate([
        (stopper_well_x_min + stopper_well_x_max) / 2 - stopper_center_x,
        0,
        stopper_well_z_min - hangboard_pocket_back_z
    ])
        stacked_pocket_stoppers();
}

module phone_reference(portrait = false, drop = 0) {
    // Largest supported phone in its case, resting on the slot floor and
    // leaning against the slot's outer (-X) face.
    height = portrait ? phone_probe_l : phone_probe_w;
    width = portrait ? phone_probe_w : phone_probe_l;
    gap = (phone_slot_w - phone_probe_t) / 2;
    // Lowest (-X) bottom corner sits on the slot floor.
    corner_x = -phone_slot_w + gap;
    z0 = (phone_slot_z_min - frame_z_max - corner_x * sin(phone_slot_tilt))
        / cos(phone_slot_tilt);
    translate([phone_slot_x_top, frame_center_y - width / 2, frame_z_max - drop])
        rotate([0, -phone_slot_tilt, 0])
            translate([corner_x, 0, z0])
                cube([phone_probe_t, width, height]);
}

module pin_spacer() {
    difference() {
        cylinder(d = bushing_core_od, h = bushing_length, center = true);
        cylinder(d = bushing_id, h = bushing_length + 0.2, center = true);
    }
}

module eye_collar_half() {
    difference() {
        union() {
            translate([0, 0, -bushing_eye_collar_body_h / 2])
                cylinder(d = bushing_od, h = bushing_eye_collar_body_h, center = true);
            translate([0, 0, bushing_eye_collar_flange_t / 2])
                cylinder(
                    d = bushing_eye_collar_flange_od,
                    h = bushing_eye_collar_flange_t,
                    center = true
                );
        }
        translate([0, 0, -bushing_eye_collar_body_h / 2])
            cylinder(
                d = bushing_collar_id,
                h = bushing_eye_collar_body_h + 2 * bushing_eye_collar_flange_t + 0.2,
                center = true
            );
    }
}

module eye_interface_at(x_pos, x_offset = 0, z_offset = 0, contact_relief = 0) {
    translate([x_pos + x_offset, dyno_eye_y, bushing_center_z + z_offset])
        pin_spacer();
    translate([x_pos + x_offset, dyno_eye_y, loadcell_top_z + z_offset + contact_relief])
        eye_collar_half();
    translate([x_pos + x_offset, dyno_eye_y, loadcell_bottom_z + z_offset - contact_relief])
        rotate([180, 0, 0])
            eye_collar_half();
}

module dynamometer_bushings(right_x_offset = 0, exploded_z = 0, contact_relief = 0) {
    eye_interface_at(
        dyno_eye_x_left,
        z_offset = -exploded_z,
        contact_relief = contact_relief
    );
    eye_interface_at(
        dyno_eye_x_right,
        x_offset = right_x_offset,
        z_offset = exploded_z,
        contact_relief = contact_relief
    );
}

module pin_hardware_model(x_pos, x_offset = 0, z_offset = 0) {
    bolt_head_h = 5.3;
    bolt_head_d = 13;
    washer_t = loadcell_washer_t;
    washer_d = 16;
    nut_h = loadcell_nut_h;
    nut_d = 14.4;

    color("silver") {
        // Full-length shank, from the head through the nut to its tip.
        translate([x_pos + x_offset, dyno_eye_y, loadcell_bolt_tip_z + z_offset])
            cylinder(d = pin_nominal_d, h = loadcell_bolt_l);
        translate([
            x_pos + x_offset,
            dyno_eye_y,
            frame_z_max + washer_t + bolt_head_h / 2 + z_offset
        ])
            cylinder(d = bolt_head_d, h = bolt_head_h, center = true);
        translate([x_pos + x_offset, dyno_eye_y, frame_z_max + washer_t / 2 + z_offset])
            cylinder(d = washer_d, h = washer_t, center = true);
        translate([x_pos + x_offset, dyno_eye_y, frame_z_min - washer_t / 2 + z_offset])
            cylinder(d = washer_d, h = washer_t, center = true);
        translate([
            x_pos + x_offset,
            dyno_eye_y,
            frame_z_min - washer_t - nut_h / 2 + z_offset
        ])
            cylinder(d = nut_d, h = nut_h, center = true, $fn = 6);
    }
}

module dynamometer_hardware(right_x_offset = 0, exploded_z = 0) {
    pin_hardware_model(dyno_eye_x_left, z_offset = -exploded_z);
    pin_hardware_model(dyno_eye_x_right, x_offset = right_x_offset, z_offset = exploded_z);
}

module ball_lock_pin_model() {
    // Push-button ball-lock pin with the head's underside at the origin.
    lock_ball_z = -wrist_quick_pin_grip_l - wrist_quick_pin_lock_ball_d / 2 - 0.2;
    pin_bottom_z = lock_ball_z - wrist_quick_pin_tip_l;

    translate([0, 0, pin_bottom_z])
        cylinder(d = wrist_quick_pin_d, h = -pin_bottom_z);
    cylinder(d = wrist_quick_pin_head_d, h = wrist_quick_pin_head_h);
    translate([0, 0, wrist_quick_pin_head_h])
        cylinder(d = wrist_quick_pin_button_d, h = wrist_quick_pin_button_h);
    for (angle = [0, 180])
        translate([0, 0, lock_ball_z])
            rotate([0, 0, angle])
                translate([wrist_quick_pin_d / 2, 0, 0])
                    sphere(d = wrist_quick_pin_lock_ball_d);
}

module wrist_rest_hardware_model(x_offset = 0) {
    // Both pins inserted from +Z.
    color("silver")
        for (y_pos = [wrist_mount_y_bottom, wrist_mount_y_top])
            translate([wrist_mount_x + x_offset, y_pos, wrist_rest_z_max])
                ball_lock_pin_model();
}

module frame_split_bolt_model() {
    // M5 socket-head screw with the head's underside at the origin.
    cylinder(d = frame_split_bolt_head_d, h = frame_split_bolt_head_h);
    translate([0, 0, -frame_split_bolt_l])
        cylinder(d = frame_split_bolt_d, h = frame_split_bolt_l + 0.01);
}

module frame_split_nut_model() {
    // M5 nyloc nut with its bearing face at the origin, corners along X.
    translate([0, 0, -frame_split_nut_h])
        difference() {
            cylinder(d = frame_split_nut_af / cos(30), h = frame_split_nut_h, $fn = 6);
            translate([0, 0, -0.1])
                cylinder(d = frame_split_bolt_d, h = frame_split_nut_h + 0.2);
        }
}

module frame_split_hardware_model(bolt_dz = 0, nut_dz = 0) {
    color("silver")
        for (x_pos = frame_split_bolt_x)
            for (y_pos = frame_split_bolt_y)
                translate([x_pos, y_pos, 0]) {
                    translate([0, 0, frame_split_bolt_head_z + bolt_dz])
                        frame_split_bolt_model();
                    translate([0, 0, frame_split_nut_top_z - nut_dz])
                        frame_split_nut_model();
                }
}

module fixed_frame_half_print_layout(side = "left") {
    // The flat upper rail faces rest on the bed and the two feet build upward.
    // The right half's lower lap tongues need support under their lap faces.
    x_mid = side == "left"
        ? (frame_x_min + frame_split_x_max) / 2
        : (frame_split_x_min + frame_palm_post_outer_x) / 2;
    translate([-x_mid, 0, frame_z_max])
        rotate([180, 0, 0])
            fixed_frame_half(side);
}

module moving_finger_grip_print_layout() {
    translate([0, 0, -frame_z_min])
        moving_finger_grip();
}

module pocket_stoppers_print_layout() {
    // Side by side, flat on the bed.
    pitch = stopper_x_max - stopper_x_min + 8;
    for (i = [0 : stopper_count - 1])
        translate([
            (i - (stopper_count - 1) / 2) * pitch - stopper_center_x,
            -frame_center_y,
            -hangboard_pocket_back_z
        ])
            pocket_stopper(i);
}

module wrist_rest_print_layout() {
    // Print upright on the two flat lower arms; support the overhanging deck
    // and outer upper arms from below; the deck and bolster tops print last.
    translate([0, 0, -wrist_rest_z_min])
        adjustable_wrist_rest();
}

module print_layout(part) {
    if (part == "frame_left" || part == "frame_right")
        fixed_frame_half_print_layout(part == "frame_left" ? "left" : "right");
    else if (part == "grip")
        moving_finger_grip_print_layout();
    else if (part == "wrist_rest")
        wrist_rest_print_layout();
    else if (part == "stoppers")
        pocket_stoppers_print_layout();
    else
        assert(false, str("Unknown part: ", part));
}

// Moves a part's print layout to its place on the print plate, origin at
// the front-left bed corner. Plates 1 and 2 hold one frame half each,
// centred with the long sides along Y; plate 3 holds the rest. Shared by
// the book's plate images and the Bambu Studio project.
module print_plate_placement(part) {
    if (part == "frame_left" || part == "frame_right")
        translate([print_bed_size / 2, print_bed_size / 2, 0])
            rotate([0, 0, 90])
                children();
    else if (part == "wrist_rest")
        translate([15 - wrist_arm_x_min, print_bed_size / 2 - frame_center_y, 0])
            children();
    else if (part == "grip")
        translate([115 - moving_clevis_x_min, 190 - frame_center_y, 0])
            children();
    else if (part == "stoppers")
        translate([150, 70, 0])
            children();
    else
        assert(false, str("Unknown part: ", part));
}
