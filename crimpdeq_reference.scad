//
// Self-contained Crimpdeq v2 (crimpdeq-case v2.0.0) interface reference.
// This is a fit/collision model, not a replacement for crimpdeq-case.
//

include <dynamometer_dimensions.scad>

render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

case_inner_corner_r = case_corner_r - case_wall_t;

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

module case_eye_u_slots_reference() {
    // A vertical U-slot round each eye, open to the case end, through the
    // full height of the case and lid.
    for (side = [-1, 1])
        translate([0, 0, case_z_min - 0.2])
            linear_extrude(height = case_z_max - case_z_min + 0.4)
                union() {
                    translate([side * dyno_eye_x_right, dyno_eye_y])
                        circle(d = case_eye_u_d);
                    translate([side > 0 ? dyno_eye_x_right : -case_x_half - 0.2,
                               dyno_eye_y - case_eye_u_d / 2])
                        square([case_x_half + 0.2 - dyno_eye_x_right, case_eye_u_d]);
                }
}

module case_service_openings_reference() {
    translate([case_switch_x, case_y_max, case_switch_z])
        cube([case_switch_w + 0.8, 2 * case_wall_t + 0.4, case_switch_h + 0.8], center = true);
    translate([case_usb_x, case_y_max, case_usb_z])
        cube([case_usb_w, 2 * case_wall_t + 0.4, case_usb_h], center = true);
}

module crimpdeq_main_reference() {
    difference() {
        ref_rounded_prism(-case_x_half, case_x_half, case_y_min, case_y_max,
            case_z_min, case_lid_z, case_corner_r);
        ref_rounded_prism(-case_x_half + case_wall_t, case_x_half - case_wall_t,
            case_y_min + case_wall_t, case_y_max - case_wall_t,
            case_z_min + case_wall_t, case_lid_z + 0.2, case_inner_corner_r);
        case_eye_u_slots_reference();
        case_service_openings_reference();
    }
}

module lid_battery_walls_reference() {
    // Walls into the inboard edge of each U-slot, and the lid bridges that
    // join them to it at the top.
    for (side = [-1, 1]) {
        translate([side * case_battery_wall_x, 0,
                   (case_battery_wall_z_min + case_z_max) / 2])
            cube([case_battery_wall_t, case_battery_wall_l_y,
                  case_z_max - case_battery_wall_z_min], center = true);
        translate([side * (case_u_bridge_x_min + case_battery_wall_x) / 2, 0,
                   (case_lid_z + case_z_max) / 2])
            cube([case_battery_wall_x - case_u_bridge_x_min, case_battery_wall_l_y,
                  case_z_max - case_lid_z], center = true);
    }
}

module crimpdeq_lid_reference() {
    union() {
        difference() {
            ref_rounded_prism(-case_x_half, case_x_half, case_y_min, case_y_max,
                case_lid_z, case_z_max, case_corner_r);
            case_eye_u_slots_reference();
        }
        lid_battery_walls_reference();
    }
}

module crimpdeq_case_reference() {
    union() {
        crimpdeq_main_reference();
        crimpdeq_lid_reference();
    }
}

module crimpdeq_internals_reference() {
    loadcell_reference();

    // Battery, PCB and switch envelopes.
    color([0.1, 0.45, 0.8, 0.7])
        translate([0, -7.5, 11.5])
            cube([34, 50, 10], center = true);
    color([0.1, 0.55, 0.2, 0.8])
        translate([0, 1.8, 20])
            cube([23, 63.8, 5], center = true);
    color([0.7, 0.1, 0.1, 0.8])
        translate([case_switch_x, 27, case_switch_z])
            cube([15, 13, 10], center = true);
}
