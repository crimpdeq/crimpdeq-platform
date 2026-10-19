//
// Self-contained interface references of the supported Crimpdeq cases:
// crimpdeq-case v2.0.0 and v3.1.0. These are fit/collision models, not
// replacements for crimpdeq-case.
//

include <dimensions.scad>

render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

case2_inner_corner_r = case2_corner_r - case2_wall_t;

module ref_rounded_rect_2d(x_min, x_max, y_min, y_max, r) {
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

module ref_rounded_prism(x_min, x_max, y_min, y_max, z_min, z_max, r) {
    translate([0, 0, z_min])
        linear_extrude(height = z_max - z_min)
            ref_rounded_rect_2d(x_min, x_max, y_min, y_max, r);
}

module loadcell_2d_reference() {
    // Each eye with its pressed-in ring, which crimpdeq-case does not model.
    difference() {
        square([lc_L, lc_W], center = true);
        for (x_pos = [dyno_eye_x_left, dyno_eye_x_right])
            translate([x_pos, 0])
                circle(d = eye_bore_d);
    }
}

module loadcell_reference() {
    color("silver")
        translate([0, 0, loadcell_bottom_z])
            linear_extrude(height = lc_T)
                loadcell_2d_reference();
}

// Wall openings on the +Y face: [x, z, width, height] for each.
module case_service_openings_reference(y_wall, wall_t, openings) {
    for (o = openings)
        translate([o[0], y_wall, o[1]])
            cube([o[2], 2 * wall_t + 0.4, o[3]], center = true);
}

// --- crimpdeq-case v2.0.0 ------------------------------------------------

module case2_eye_u_slots_reference() {
    // A vertical U-slot round each eye, open to the case end, through the
    // full height of the case and lid.
    for (side = [-1, 1])
        translate([0, 0, case2_z_min - 0.2])
            linear_extrude(height = case2_z_max - case2_z_min + 0.4)
                union() {
                    translate([side * dyno_eye_x_right, dyno_eye_y])
                        circle(d = case2_eye_u_d);
                    translate([side > 0 ? dyno_eye_x_right : -case2_x_half - 0.2,
                               dyno_eye_y - case2_eye_u_d / 2])
                        square([case2_x_half + 0.2 - dyno_eye_x_right, case2_eye_u_d]);
                }
}

module case2_main_reference() {
    difference() {
        ref_rounded_prism(-case2_x_half, case2_x_half, case2_y_min, case2_y_max,
            case2_z_min, case2_lid_z, case2_corner_r);
        ref_rounded_prism(-case2_x_half + case2_wall_t, case2_x_half - case2_wall_t,
            case2_y_min + case2_wall_t, case2_y_max - case2_wall_t,
            case2_z_min + case2_wall_t, case2_lid_z + 0.2, case2_inner_corner_r);
        case2_eye_u_slots_reference();
        case_service_openings_reference(case2_y_max, case2_wall_t, [
            [case2_switch_x, case2_switch_z, case2_switch_w + 0.8, case2_switch_h + 0.8],
            [case2_usb_x, case2_usb_z, case2_usb_w, case2_usb_h]]);
    }
}

module case2_lid_battery_walls_reference() {
    // Walls into the inboard edge of each U-slot, and the lid bridges that
    // join them to it at the top.
    for (side = [-1, 1]) {
        translate([side * case2_battery_wall_x, 0,
                   (case2_battery_wall_z_min + case2_z_max) / 2])
            cube([case2_battery_wall_t, case2_battery_wall_l_y,
                  case2_z_max - case2_battery_wall_z_min], center = true);
        translate([side * (case2_u_bridge_x_min + case2_battery_wall_x) / 2, 0,
                   (case2_lid_z + case2_z_max) / 2])
            cube([case2_battery_wall_x - case2_u_bridge_x_min, case2_battery_wall_l_y,
                  case2_z_max - case2_lid_z], center = true);
    }
}

module case2_lid_reference() {
    union() {
        difference() {
            ref_rounded_prism(-case2_x_half, case2_x_half, case2_y_min, case2_y_max,
                case2_lid_z, case2_z_max, case2_corner_r);
            case2_eye_u_slots_reference();
        }
        case2_lid_battery_walls_reference();
    }
}

// --- crimpdeq-case v3.1.0 ------------------------------------------------
// Modelled solid: nothing of the platform enters the case but through its
// slots, whose walls run the full height except where the load cell lies.

module case3_slots_2d() {
    // Round each eye and out through the point, inboard only to the flat.
    for (side = [-1, 1])
        intersection() {
            hull() {
                translate([side * dyno_eye_x_right, dyno_eye_y])
                    circle(d = case3_slot_d);
                translate([side * (case3_tip_x + 1), dyno_eye_y])
                    square([0.01, case3_slot_d], center = true);
            }
            translate([side * (case3_slot_inner_x + case3_tip_x + 2) / 2, dyno_eye_y])
                square([case3_tip_x + 2 - case3_slot_inner_x, case3_slot_d + 1], center = true);
        }
}

module case3_shell_reference(z_min, z_max) {
    translate([0, 0, z_min])
        linear_extrude(height = z_max - z_min)
            difference() {
                polygon([
                    [case3_tip_x, 0], [case3_corner_x, case3_y_half],
                    [-case3_corner_x, case3_y_half], [-case3_tip_x, 0],
                    [-case3_corner_x, -case3_y_half], [case3_corner_x, -case3_y_half]
                ]);
                case3_slots_2d();
            }
}

module case3_main_reference() {
    difference() {
        case3_shell_reference(case3_z_min, case3_lid_z);
        case_service_openings_reference(case3_y_half, 2.4, [
            [case3_switch_x, case3_switch_z, case3_switch_w, case3_switch_h],
            [case3_usb_x, case3_usb_z, case3_usb_w, case3_usb_h]]);
    }
}

module case3_lid_reference() {
    case3_shell_reference(case3_lid_z, case3_z_max);
}

// --- Selection -----------------------------------------------------------

module crimpdeq_main_reference(version) {
    assert(version == 2 || version == 3, str("Unknown case version: ", version));
    if (version == 2) case2_main_reference(); else case3_main_reference();
}

module crimpdeq_lid_reference(version) {
    assert(version == 2 || version == 3, str("Unknown case version: ", version));
    if (version == 2) case2_lid_reference(); else case3_lid_reference();
}

module crimpdeq_case_reference(version) {
    crimpdeq_main_reference(version);
    crimpdeq_lid_reference(version);
}

// Every supported case at once: a part clear of this is clear of each.
module crimpdeq_cases_reference() {
    crimpdeq_case_reference(2);
    crimpdeq_case_reference(3);
}

module crimpdeq_internals_reference() {
    // Battery, PCB and switch envelopes of the v3.1.0 case.
    loadcell_reference();
    color([0.1, 0.45, 0.8, 0.7])
        translate([0, -5, case3_dz + 12])
            cube([34, 50, 10], center = true);
    color([0.1, 0.55, 0.2, 0.8])
        translate([0, 21.1, case3_dz + 19.65])
            cube([30, 30, 7.3], center = true);
    color([0.7, 0.1, 0.1, 0.8])
        translate([case3_switch_x, 29.9, case3_switch_z])
            cube([15, 12.8, 10], center = true);
}
