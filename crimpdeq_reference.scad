//
// Self-contained Crimpdeq v2 interface reference.
// This is a fit/collision model, not a replacement for crimpdeq-case.
//

include <dynamometer_dimensions.scad>

render_fn = is_undef(render_fn) ? 96 : render_fn;
$fn = render_fn;

case_corner_r = 6;
case_inner_corner_r = case_corner_r - case_wall_t;
eye_access_d = eye_d + 1;
eye_u_d = eye_access_d + 4;

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
    }
}

module loadcell_reference() {
    color("silver")
        translate([0, 0, loadcell_bottom_z])
            linear_extrude(height = lc_T)
                loadcell_2d_reference();
}

module eye_u_cutout_reference(x_pos, opens_left) {
    cut_x_min = case_outer_x_min - 0.2;
    cut_x_max = case_outer_x_max + 0.2;

    translate([0, 0, case_outer_z_min - 0.2])
        linear_extrude(height = case_depth_z + 0.4)
            union() {
                translate([x_pos, 0])
                    circle(d = eye_u_d);
                if (opens_left)
                    translate([cut_x_min, -eye_u_d / 2])
                        square([x_pos - cut_x_min, eye_u_d]);
                else
                    translate([x_pos, -eye_u_d / 2])
                        square([cut_x_max - x_pos, eye_u_d]);
            }
}

module case_service_openings_reference() {
    // Combined switch and USB-C openings on the +Y wall.
    translate([0, case_outer_y_max, 3])
        cube([15.8, 2 * case_wall_t + 0.4, 10.8], center = true);
    translate([0, case_outer_y_max, 22.9])
        cube([12, 2 * case_wall_t + 0.4, 11], center = true);
}

module crimpdeq_main_reference() {
    difference() {
        difference() {
            ref_rounded_prism(
                case_outer_x_min, case_outer_x_max,
                case_outer_y_min, case_outer_y_max,
                case_outer_z_min, case_inner_z_max,
                case_corner_r
            );
            ref_rounded_prism(
                case_inner_x_min, case_inner_x_max,
                case_inner_y_min, case_inner_y_max,
                case_inner_z_min, case_inner_z_max + 0.2,
                case_inner_corner_r
            );
        }

        for (x_pos = [dyno_eye_x_left, dyno_eye_x_right])
            translate([x_pos, 0, case_outer_z_min - 0.1])
                cylinder(d = eye_access_d, h = case_floor_t + loadcell_lift + 0.3);

        eye_u_cutout_reference(dyno_eye_x_left, true);
        eye_u_cutout_reference(dyno_eye_x_right, false);
        case_service_openings_reference();
    }
}

module lid_battery_retention_reference() {
    wall_x = 18.3;
    wall_t = 1.2;
    wall_l = 24;
    wall_z_min = 5.1;

    for (x_sign = [-1, 1])
        translate([
            x_sign * wall_x,
            0,
            (wall_z_min + case_outer_z_max) / 2
        ])
            cube([
                wall_t,
                wall_l,
                case_outer_z_max - wall_z_min
            ], center = true);
}

module crimpdeq_lid_reference() {
    union() {
        difference() {
            ref_rounded_prism(
                case_outer_x_min, case_outer_x_max,
                case_outer_y_min, case_outer_y_max,
                case_inner_z_max, case_outer_z_max,
                case_corner_r
            );
            eye_u_cutout_reference(dyno_eye_x_left, true);
            eye_u_cutout_reference(dyno_eye_x_right, false);
        }
        lid_battery_retention_reference();
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

    color([0.1, 0.45, 0.8, 0.7])
        translate([0, -7.5, 11.5])
            cube([34, 50, 10], center = true);

    color([0.1, 0.55, 0.2, 0.8])
        translate([0, 1.8, 20])
            cube([23, 63.8, 5], center = true);

    color([0.7, 0.1, 0.1, 0.8])
        translate([0, 27, 3])
            cube([15, 13, 10], center = true);
}
