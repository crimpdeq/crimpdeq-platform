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
            frame_left_post_outer_x, frame_palm_post_outer_x,
            frame_inner_y_max, frame_outer_y_max,
            frame_z_min, frame_z_max,
            frame_corner_r
        );
        dyno_rounded_prism_xy(
            frame_left_post_outer_x, frame_palm_post_outer_x,
            frame_outer_y_min, frame_inner_y_min,
            frame_z_min, frame_z_max,
            frame_corner_r
        );
        dyno_rounded_prism_xy(
            frame_left_post_outer_x, frame_left_post_inner_x,
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

module fixed_frame() {
    difference() {
        union() {
            fixed_frame_body();
            frame_support_feet();
            clevis_cheek_pair(fixed_clevis_x_min, fixed_clevis_x_max);
        }
        vertical_pin_bore(dyno_eye_x_left);
        wrist_index_bores();
        wrist_post_channel_cut();
        service_tunnel_cut();
    }
}

module frame_split_peg_holes() {
    // Horizontal X bores across the split face. Teardrop tips point to model
    // -Z, which is up in the flipped frame print, so the roofs self-support.
    r = frame_split_peg_hole_d / 2;
    for (y_pos = frame_split_peg_y)
        for (z_pos = frame_split_peg_z)
            hull() {
                translate([frame_split_x - frame_split_peg_depth - 0.5, y_pos, z_pos])
                    rotate([0, 90, 0])
                        cylinder(r = r, h = 2 * frame_split_peg_depth + 1);
                translate([frame_split_x - frame_split_peg_depth - 0.5,
                           y_pos - 0.01, z_pos - r * sqrt(2)])
                    cube([2 * frame_split_peg_depth + 1, 0.02, 0.02]);
            }
}

module fixed_frame_half(side = "left") {
    // Unloaded fit-prototype only: glue both rails with pegs at frame_split_x.
    big = 1000;
    difference() {
        intersection() {
            fixed_frame();
            translate([side == "left" ? frame_split_x - big : frame_split_x,
                       -big / 2, -big / 2])
                cube(big);
        }
        frame_split_peg_holes();
    }
}

module frame_split_brace(side = "bottom", contact_relief = 0) {
    // Glued across the seam of one rail ("bottom" = -Y, "top" = +Y). The
    // splint and post clamp both rail faces; the leg seats on the rail
    // underside and stands on the corner-foot plane, so both halves bear
    // through it. The post top is a pad just under the grip body edge.
    s = side == "top" ? 1 : -1;
    outer_y = s > 0 ? frame_outer_y_max : frame_outer_y_min;
    inner_y = s > 0 ? frame_inner_y_max : frame_inner_y_min;
    web_in_y = outer_y + s * frame_split_brace_glue_gap;
    web_out_y = web_in_y + s * frame_split_brace_web_t;
    post_out_y = inner_y - s * frame_split_brace_glue_gap;
    post_in_y = post_out_y - s * frame_split_brace_post_t;
    leg_y_min = min(post_in_y, web_out_y);
    leg_y_max = max(post_in_y, web_out_y);
    c = frame_split_brace_corner_relief;

    translate([0, 0, -contact_relief])
        difference() {
            union() {
                // Splint top stays flush with the frame's upper face.
                dyno_rounded_prism_xy(
                    frame_split_brace_x_min, frame_split_brace_x_max,
                    min(web_in_y, web_out_y), max(web_in_y, web_out_y),
                    frame_split_brace_slab_z_min, frame_z_max, 2
                );
                dyno_rounded_prism_xy(
                    frame_split_brace_x_min, frame_split_brace_x_max,
                    min(post_out_y, post_in_y), max(post_out_y, post_in_y),
                    frame_split_brace_slab_z_min, frame_split_brace_pad_z, 2
                );
                hull() {
                    dyno_rounded_prism_xy(
                        frame_split_brace_x_min, frame_split_brace_x_max,
                        leg_y_min, leg_y_max,
                        frame_split_brace_slab_z_min, frame_z_min, 2
                    );
                    dyno_rounded_prism_xy(
                        frame_split_x - frame_split_brace_sole_x / 2,
                        frame_split_x + frame_split_brace_sole_x / 2,
                        leg_y_min, leg_y_max,
                        frame_split_brace_z_min, frame_split_brace_z_min + 0.01, 2
                    );
                }
            }
            // Reliefs for the rail's lower edges.
            for (edge_y = [outer_y, inner_y])
                translate([frame_split_brace_x_min - 1, edge_y - c, frame_z_min - c])
                    cube([2 * frame_split_brace_half_len + 2, 2 * c, 2 * c]);
        }
}

module frame_split_braces(contact_relief = 0) {
    for (side = ["bottom", "top"])
        frame_split_brace(side, contact_relief);
}

module fit_thread_profile(clearance = 0) {
    // Eccentric circle; twisting it along Z makes a coarse single-start
    // thread that prints upright and mates with the same profile + clearance.
    translate([fit_bolt_thread_depth / 2, 0])
        circle(d = fit_bolt_d - fit_bolt_thread_depth + 2 * clearance);
}

module fit_thread(h, clearance = 0) {
    linear_extrude(
        height = h,
        twist = -360 * h / fit_bolt_thread_pitch,
        slices = ceil(h / 0.2)
    )
        fit_thread_profile(clearance);
}

module fit_bolt() {
    // Fit-only M8 stand-in, printed head down.
    c = 0.8;
    cylinder(d = fit_bolt_head_d, h = fit_bolt_head_h, $fn = 6);
    translate([0, 0, fit_bolt_head_h - 0.01])
        cylinder(d = fit_bolt_d, h = fit_bolt_l - fit_bolt_thread_l + 0.02);
    translate([0, 0, fit_bolt_head_h + fit_bolt_l - fit_bolt_thread_l])
        intersection() {
            fit_thread(fit_bolt_thread_l);
            union() {
                cylinder(d = fit_bolt_d + 1, h = fit_bolt_thread_l - c);
                translate([0, 0, fit_bolt_thread_l - c])
                    cylinder(d1 = fit_bolt_d + 1, d2 = fit_bolt_d - 2 * c, h = c);
            }
        }
}

module fit_nut() {
    difference() {
        cylinder(d = fit_nut_d, h = loadcell_nut_h, $fn = 6);
        translate([0, 0, -0.01])
            fit_thread(loadcell_nut_h + 0.02, fit_bolt_thread_clearance);
    }
}

module fit_washer() {
    difference() {
        cylinder(d = fit_washer_d, h = loadcell_washer_t);
        translate([0, 0, -0.1])
            cylinder(d = fit_washer_id, h = loadcell_washer_t + 0.2);
    }
}

module fit_quick_pin() {
    // Fit-only ball-lock pin stand-in, printed head down. It does not lock;
    // pass a paperclip or 2 mm split pin through the cross-hole below the
    // lower arm. The Ø18 head carries a lanyard hole.
    c = 0.6;
    difference() {
        union() {
            cylinder(d = wrist_quick_pin_head_d, h = wrist_quick_pin_head_h);
            translate([0, 0, wrist_quick_pin_head_h - 0.01])
                cylinder(d = fit_pin_d, h = fit_pin_l - c + 0.01);
            translate([0, 0, wrist_quick_pin_head_h + fit_pin_l - c])
                cylinder(d1 = fit_pin_d, d2 = fit_pin_d - 2 * c, h = c);
        }
        translate([fit_pin_lanyard_r, 0, -0.1])
            cylinder(d = fit_pin_lanyard_d, h = wrist_quick_pin_head_h + 0.2);
        translate([0, 0, wrist_quick_pin_head_h + fit_pin_retainer_z])
            rotate([90, 0, 0])
                cylinder(d = fit_pin_retainer_d, h = fit_pin_d + 2, center = true);
    }
}

module frame_split_peg() {
    // Lies along X on a 0.4 mm flat; 0.5 mm end chamfers ease insertion.
    r = frame_split_peg_d / 2;
    c = 0.5;
    translate([0, 0, r - 0.4])
        difference() {
            rotate([0, 90, 0])
                union() {
                    cylinder(r1 = r - c, r2 = r, h = c);
                    translate([0, 0, c])
                        cylinder(r = r, h = frame_split_peg_l - 2 * c);
                    translate([0, 0, frame_split_peg_l - c])
                        cylinder(r1 = r, r2 = r - c, h = c);
                }
            translate([-1, -r - 1, -r - 1])
                cube([frame_split_peg_l + 2, 2 * r + 2, 1 + 0.4]);
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
        // Exact 20 mm floor datum; draft leaves 18 x 64.6 mm at the floor.
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
        translate([x_pos + x_offset, dyno_eye_y, bushing_center_z + z_offset])
            cylinder(d = pin_nominal_d, h = frame_depth_z + 2 * washer_t, center = true);
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

module wrist_rest_hardware_model(x_offset = 0) {
    pin_top_z = wrist_rest_z_max;
    lock_ball_z =
        pin_top_z
        - wrist_quick_pin_grip_l
        - wrist_quick_pin_lock_ball_d / 2
        - 0.2;
    pin_bottom_z = lock_ball_z - wrist_quick_pin_tip_l;

    color("silver") {
        for (y_pos = [wrist_mount_y_bottom, wrist_mount_y_top]) {
            // Push-button ball-lock pin, inserted from +Z.
            translate([
                wrist_mount_x + x_offset,
                y_pos,
                (pin_top_z + pin_bottom_z) / 2
            ])
                cylinder(
                    d = wrist_quick_pin_d,
                    h = pin_top_z - pin_bottom_z,
                    center = true
                );

            translate([
                wrist_mount_x + x_offset,
                y_pos,
                pin_top_z + wrist_quick_pin_head_h / 2
            ])
                cylinder(
                    d = wrist_quick_pin_head_d,
                    h = wrist_quick_pin_head_h,
                    center = true
                );

            translate([
                wrist_mount_x + x_offset,
                y_pos,
                pin_top_z + wrist_quick_pin_head_h + wrist_quick_pin_button_h / 2
            ])
                cylinder(
                    d = wrist_quick_pin_button_d,
                    h = wrist_quick_pin_button_h,
                    center = true
                );

            for (angle = [0, 180])
                translate([wrist_mount_x + x_offset, y_pos, lock_ball_z])
                    rotate([0, 0, angle])
                        translate([wrist_quick_pin_d / 2, 0, 0])
                            sphere(d = wrist_quick_pin_lock_ball_d);
        }
    }
}

module fixed_frame_print_layout() {
    // The flat upper rail faces rest on the bed; the four feet build upward.
    translate([0, 0, frame_z_max])
        rotate([180, 0, 0])
            fixed_frame();
}

module fixed_frame_half_print_layout(side = "left") {
    // Same flipped orientation as the one-piece frame, centred on X = 0.
    x_mid = side == "left"
        ? (frame_left_post_outer_x + frame_split_x) / 2
        : (frame_split_x + frame_palm_post_outer_x) / 2;
    translate([-x_mid, 0, frame_z_max])
        rotate([180, 0, 0])
            fixed_frame_half(side);
}

module frame_split_peg_print_layout(count = frame_split_peg_count) {
    for (i = [0 : count - 1])
        translate([-frame_split_peg_l / 2, (i - (count - 1) / 2) * (frame_split_peg_d + 4), 0])
            frame_split_peg();
}

module frame_split_brace_print_layout(side = "bottom") {
    // Upright on its sole: the leg taper is self-supporting and the splint,
    // post and rail channel build straight up with no overhang.
    rail_center_y = side == "top"
        ? (frame_inner_y_max + frame_outer_y_max) / 2
        : (frame_outer_y_min + frame_inner_y_min) / 2;
    translate([-frame_split_x, -rail_center_y, -frame_split_brace_z_min])
        frame_split_brace(side);
}

module frame_split_braces_print_layout() {
    for (side = ["bottom", "top"])
        translate([(side == "top" ? 1 : -1) * (frame_split_brace_half_len + 4), 0, 0])
            frame_split_brace_print_layout(side);
}

module fit_bolt_set_print_layout() {
    // Two bolts head down, two nuts and four washers, all flat on the bed.
    pitch = fit_washer_d + 6;
    for (i = [0, 1]) {
        translate([i * pitch, 0, 0]) fit_bolt();
        translate([i * pitch, pitch, 0]) fit_nut();
        for (j = [0, 1])
            translate([(2 + j) * pitch, i * pitch, 0]) fit_washer();
    }
}

module fit_quick_pin_pair_print_layout() {
    for (x_pos = [-1, 1])
        translate([x_pos * (wrist_quick_pin_head_d / 2 + 5), 0, 0])
            fit_quick_pin();
}

module moving_finger_grip_print_layout() {
    translate([0, 0, -frame_z_min])
        moving_finger_grip();
}

module wrist_rest_print_layout() {
    // Print upright on the two flat mounting arms; support the overhanging
    // deck from below, away from the new palm-contact channel and rounded rim.
    translate([0, 0, -wrist_rest_z_min])
        adjustable_wrist_rest();
}

module pin_spacer_print_layout() {
    translate([0, 0, bushing_length / 2])
        pin_spacer();
}
