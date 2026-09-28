//
// Self-contained Crimpdeq compact-pod interface reference.
// This is a fit/collision model, not a replacement for crimpdeq-case.
//

include <dynamometer_dimensions.scad>

render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

case_inner_corner_r = case_corner_r - case_wall_t;
loadcell_notch_d = 6;
loadcell_notch_x = 20;

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
    difference() {
        square([lc_L, lc_W], center = true);
        for (x_pos = [dyno_eye_x_left, dyno_eye_x_right])
            translate([x_pos, 0])
                circle(d = eye_d);
        for (x_pos = [-loadcell_notch_x, loadcell_notch_x])
            for (y_pos = [-lc_W / 2, lc_W / 2])
                translate([x_pos, y_pos])
                    circle(d = loadcell_notch_d);
    }
}

module loadcell_reference() {
    color("silver")
        translate([0, 0, loadcell_bottom_z])
            linear_extrude(height = lc_T)
                loadcell_2d_reference();
}

module case_eye_access_reference() {
    // Vertical carabiner tunnels through both eyes; they break out through
    // the pod's end faces.
    for (x_pos = [dyno_eye_x_left, dyno_eye_x_right])
        translate([x_pos, dyno_eye_y, case_z_min - 0.2])
            cylinder(d = case_eye_access_d, h = case_z_max - case_z_min + 0.4);
}

module case_loadcell_channels_reference() {
    // The load-cell ends pass through both side walls.
    for (x_sign = [-1, 1])
        translate([x_sign * (case_x_half - case_wall_t / 2), 0, loadcell_center_z])
            cube([case_wall_t + 0.4, lc_W + 0.6, lc_T + 0.6], center = true);
}

module case_service_openings_reference() {
    translate([case_switch_x, case_y_max, case_switch_z])
        cube([case_switch_w, 2 * case_wall_t + 0.4, case_switch_h], center = true);
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
        case_eye_access_reference();
        case_loadcell_channels_reference();
        case_service_openings_reference();
    }
}

module crimpdeq_lid_reference() {
    difference() {
        ref_rounded_prism(-case_x_half, case_x_half, case_y_min, case_y_max,
            case_lid_z, case_z_max, case_corner_r);
        case_eye_access_reference();
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
        translate([0, -5, 10.5])
            cube([34, 50, 10], center = true);
    color([0.1, 0.55, 0.2, 0.8])
        translate([0, 18.6, 18.5])
            cube([30, 30, 5], center = true);
    color([0.7, 0.1, 0.1, 0.8])
        translate([case_switch_x, 26.9, case_switch_z])
            cube([15, 13, 10], center = true);
}
