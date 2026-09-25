//
// Illustration scenes for the build guide.
// Rendered by render-illustrations.sh; select a scene with -D 'view="..."'.
// Every part comes from the project modules, so the pictures follow the design.
//

include <../../dynamometer_dimensions.scad>
use <../../dynamometer_parts.scad>
use <../../crimpdeq_reference.scad>

render_fn = is_undef(render_fn) ? 48 : render_fn;
$fn = render_fn;
view = is_undef(view) ? "overview" : view;

c_frame = [0.40, 0.42, 0.46];
c_frame_b = [0.58, 0.60, 0.64];
c_grip = [0.20, 0.45, 0.78];
c_rest = [0.95, 0.55, 0.15];
c_case = [0.12, 0.20, 0.32, 0.55];
c_insert = [0.92, 0.76, 0.20];
c_bolt = [0.82, 0.82, 0.86];
c_pin = [0.45, 0.80, 0.45];
c_arrow = [0.90, 0.10, 0.10];
c_plate = [0.66, 0.67, 0.70];
// Mid-grey text and translucent ghosts read on both light and dark pages.
c_text = [0.46, 0.47, 0.52];
c_ghost = [0.60, 0.62, 0.66, 0.30];

// Wrist-rest offset that keeps it at the far (palm-post) end of its travel.
rest_far = wrist_adjust_range;

// Load-cell joint hardware, matching the modelled envelopes: M8 x 60 bolt,
// DIN 125 washers and the nut below the lower washer.
m8_bolt_l = 60;
m8_head_d = 13;
m8_head_h = 5.3;
m8_washer_d = 16;
m8_nut_d = 14.4;
bolt_top_z = frame_z_max + loadcell_washer_t + m8_head_h;
nut_z = frame_z_min - loadcell_washer_t - loadcell_nut_h;

module m8_bolt() {
    // Head down, like a bolt standing on its head.
    cylinder(d = m8_head_d, h = m8_head_h, $fn = 6);
    translate([0, 0, m8_head_h - 0.01]) cylinder(d = pin_nominal_d, h = m8_bolt_l + 0.01);
}

module m8_washer() {
    difference() {
        cylinder(d = m8_washer_d, h = loadcell_washer_t);
        translate([0, 0, -0.1]) cylinder(d = pin_nominal_d + 0.4, h = loadcell_washer_t + 0.2);
    }
}

module m8_nut() {
    difference() {
        cylinder(d = m8_nut_d, h = loadcell_nut_h, $fn = 6);
        translate([0, 0, -0.1]) cylinder(d = pin_nominal_d, h = loadcell_nut_h + 0.2);
    }
}

module arrow(from, to, d = 3) {
    v = to - from;
    l = norm(v);
    head = min(4 * d, l / 2);
    b = acos(v[2] / l);
    c = atan2(v[1], v[0]);
    color(c_arrow)
        translate(from)
            rotate([0, b, c]) {
                cylinder(d = d, h = l - head, $fn = 24);
                translate([0, 0, l - head])
                    cylinder(d1 = 2.4 * d, d2 = 0, h = head, $fn = 24);
            }
}

module case_model(ghost = false) {
    color(ghost ? c_ghost : c_case) crimpdeq_case_reference();
    if (!ghost) color([0.75, 0.75, 0.78]) loadcell_reference();
}

module inserts_at(x_pos, sleeve_dz = 0) {
    // Steel sleeve and the two aluminium eye-collar halves.
    color(c_insert) {
        translate([x_pos, dyno_eye_y, bushing_center_z + sleeve_dz]) pin_spacer();
        translate([x_pos, dyno_eye_y, loadcell_top_z]) eye_collar_half();
        translate([x_pos, dyno_eye_y, loadcell_bottom_z]) rotate([180, 0, 0]) eye_collar_half();
    }
}

module bolt_stack_at(x_pos, top_dz = 0, bottom_dz = 0) {
    color(c_bolt) {
        translate([x_pos, dyno_eye_y, bolt_top_z + top_dz])
            mirror([0, 0, 1]) m8_bolt();
        translate([x_pos, dyno_eye_y, frame_z_max + top_dz / 3]) m8_washer();
        translate([x_pos, dyno_eye_y, frame_z_min - loadcell_washer_t - bottom_dz / 3])
            m8_washer();
        translate([x_pos, dyno_eye_y, nut_z - bottom_dz]) m8_nut();
    }
}

module wrist_pins(x_offset, lift = 0, ys = [wrist_mount_y_bottom, wrist_mount_y_top]) {
    color(c_pin)
        for (y_pos = ys)
            translate([wrist_mount_x + x_offset, y_pos, wrist_rest_z_max + lift])
                ball_lock_pin_model();
}

module split_hardware(bolt_dz = 0, nut_dz = 0) {
    color(c_bolt) frame_split_hardware_model(bolt_dz, nut_dz);
}

module frame_half(side) {
    // OpenCSG previews this CSG with the wrong colours; render it.
    render() fixed_frame_half(side);
}

module frame_half_print_layout(side) {
    render() fixed_frame_half_print_layout(side);
}

module frame_halves(gap = 0) {
    color(c_frame) translate([-gap / 2, 0, 0]) frame_half("left");
    color(c_frame_b) translate([gap / 2, 0, 0]) frame_half("right");
}

module frame_bolted() {
    frame_halves();
    split_hardware();
}

module rest(x_offset = 0) {
    color(c_rest) adjustable_wrist_rest(x_offset);
}

module grip(dx = 0, dz = 0, c = c_grip) {
    color(c) translate([dx, 0, dz]) moving_finger_grip();
}

module full_assembly(x_offset = 0) {
    frame_bolted();
    rest(x_offset);
    grip();
    case_model();
    inserts_at(dyno_eye_x_left);
    inserts_at(dyno_eye_x_right);
    bolt_stack_at(dyno_eye_x_left);
    bolt_stack_at(dyno_eye_x_right);
    wrist_pins(x_offset);
}

module build_plate(label) {
    color(c_plate) translate([0, 0, -1.2]) cube([256, 256, 1]);
    color(c_text)
        translate([6, -14, -1])
            linear_extrude(0.5) text(label, size = 9);
}

module plate_1() {
    build_plate("Plate 1: frame halves");
    for (i = [0, 1])
        translate([128 + (i == 0 ? -1 : 1) * (110.6 / 2 + 7.5), 128, 0])
            rotate([0, 0, 90])
                color(i == 0 ? c_frame : c_frame_b)
                    frame_half_print_layout(i == 0 ? "left" : "right");
}

module plate_2() {
    build_plate("Plate 2: wrist rest and grip");
    translate([60 - 177.8, 150 - 0.6, 0]) color(c_rest) wrist_rest_print_layout();
    translate([180 - 48.15, 150, 0]) color(c_grip) moving_finger_grip_print_layout();
}

// ---- Flat labelled cross-sections (x right, z up) ----

module xz_section(y0) {
    // Slice at Y = y0 and lay the XZ plane flat so the drawing reads x/z.
    projection(cut = true)
        rotate([-90, 0, 0])
            translate([0, -y0, 0])
                children();
}

module sec(c, y0, x0, x1, dz = 0, layer = 0) {
    color(c)
        translate([0, dz, layer])
            linear_extrude(1)
                intersection() {
                    xz_section(y0) children();
                    translate([x0, -200]) square([x1 - x0, 400]);
                }
}

module label(p, t, anchor, size = 4.2) {
    // Text at p with a thin leader line to anchor.
    color(c_text) translate([0, 0, 3]) {
        translate(p) linear_extrude(0.5)
            text(t, size = size, valign = "center", font = "Liberation Sans");
        v = anchor - (p - [1.5, 0]);
        translate(p - [1.5, 0]) rotate([0, 0, atan2(v[1], v[0])])
            translate([0, -0.25, 0]) cube([norm(v), 0.5, 0.5]);
        translate(anchor) cylinder(d = 1.6, h = 0.5, $fn = 12);
    }
}

module flat_arrow(from, to, w = 2.2) {
    v = to - from;
    l = norm(v);
    color(c_arrow) translate([from[0], from[1], 4])
        rotate([0, 0, atan2(v[1], v[0])])
            linear_extrude(0.5) {
                translate([0, -w / 2]) square([l - 3 * w, w]);
                translate([l - 3 * w, 0])
                    polygon([[0, -1.5 * w], [3 * w, 0], [0, 1.5 * w]]);
            }
}

module joint_hardware_sections(x_pos, top_dz = 0, sleeve_dz = 0, washer_dz = 0, nut_dz = 0) {
    x0 = x_pos - 20;
    x1 = x_pos + 20;
    sec(c_insert, dyno_eye_y, x0, x1, sleeve_dz, 1)
        translate([x_pos, dyno_eye_y, bushing_center_z]) pin_spacer();
    sec(c_insert, dyno_eye_y, x0, x1, 0, 1) {
        translate([x_pos, dyno_eye_y, loadcell_top_z]) eye_collar_half();
        translate([x_pos, dyno_eye_y, loadcell_bottom_z]) rotate([180, 0, 0]) eye_collar_half();
    }
    sec(c_bolt, dyno_eye_y, x0, x1, top_dz, 1.5) {
        translate([x_pos, dyno_eye_y, bolt_top_z]) mirror([0, 0, 1]) m8_bolt();
        translate([x_pos, dyno_eye_y, frame_z_max]) m8_washer();
    }
    sec(c_bolt, dyno_eye_y, x0, x1, washer_dz, 1.5)
        translate([x_pos, dyno_eye_y, frame_z_min - loadcell_washer_t]) m8_washer();
    sec(c_bolt, dyno_eye_y, x0, x1, nut_dz, 1.5)
        translate([x_pos, dyno_eye_y, nut_z]) m8_nut();
}

module joint_body_sections(x0, x1) {
    sec(c_frame, dyno_eye_y, x0, x1) fixed_frame();
    sec(c_grip, dyno_eye_y, x0, x1) moving_finger_grip();
    sec([0.55, 0.62, 0.72], dyno_eye_y, x0, x1) crimpdeq_case_reference();
    sec([0.72, 0.72, 0.76], dyno_eye_y, x0, x1, 0, 0.5) loadcell_reference();
}

sec_x0 = frame_left_post_inner_x - 4;
sec_x1 = hangboard_body_x_max + 2;

module joint_labels(x_pos, lx, stack = false) {
    // Label column to the right of the drawing.
    ly = 50;
    pitch = 9;
    items = stack ? [] : [
        ["Bolt head", [x_pos + 5, bolt_top_z - 2]],
        ["Washer", [x_pos + 7, frame_z_max + 0.8]],
        ["Upper cheek (grip)", [x_pos + 11, frame_z_max - clevis_plate_t / 2]],
        ["Load-cell eye", [x_pos + 10, loadcell_center_z]],
        ["Eye collar", [x_pos + 8.4, loadcell_top_z + 1]],
        ["Steel sleeve", [x_pos + 5.6, bushing_center_z - 8]],
        ["Lower cheek (grip)", [x_pos + 11, frame_z_min + clevis_plate_t / 2]],
        ["Washer", [x_pos + 7, frame_z_min - 0.8]],
        ["Nut", [x_pos + 6.5, nut_z + loadcell_nut_h / 2]],
    ];
    for (i = [0 : len(items) - 1])
        label([lx, ly - i * pitch], items[i][0], items[i][1]);
}

if (view == "overview") {
    full_assembly(0);
} else if (view == "plate1") {
    plate_1();
} else if (view == "plate2") {
    plate_2();
} else if (view == "slide_rest") {
    color(c_frame_b) frame_half("right");
    rest(frame_split_x_min - wrist_arm_x_min - 30);
    arrow([frame_split_x_min - 10, 0, wrist_rest_z_max + 18],
          [frame_split_x_min + 55, 0, wrist_rest_z_max + 18], 4);
    color(c_ghost) translate([-90, 0, 0]) frame_half("left");
} else if (view == "join_frame") {
    frame_halves(40);
    rest(rest_far + 20);
    translate([-20, 0, 0]) split_hardware(bolt_dz = 45);
    translate([20, 0, 0]) split_hardware(nut_dz = 35);
    for (s = [-1, 1])
        arrow([frame_split_x + s * 90, 0, frame_z_max + 20],
              [frame_split_x + s * 45, 0, frame_z_max + 20], 4);
} else if (view == "frame_joint") {
    // Section along the -Y rail's centre line through the bolted lap.
    y0 = frame_split_bolt_y[0];
    x0 = frame_split_x_min - 16;
    x1 = frame_split_x_max + 16;
    sec(c_frame, y0, x0, x1) fixed_frame_half("left");
    sec(c_frame_b, y0, x0, x1) fixed_frame_half("right");
    sec(c_bolt, y0, x0, x1, 0, 1.5) frame_split_hardware_model();
    bx = frame_split_bolt_x[1];
    lx = x1 + 10;
    label([lx, frame_z_max + 14], "M5 screw in counterbore", [bx + 3, frame_split_bolt_head_z + 2.5]);
    label([lx, frame_split_lap_z + 16], "Left half (upper tongue)", [x1 - 22, frame_split_lap_z + 6]);
    label([lx, frame_split_lap_z], "Lap face", [bx + 8, frame_split_lap_z]);
    label([lx, frame_split_lap_z - 16], "Right half (lower tongue)", [x1 - 4, frame_z_min + 6]);
    label([lx, frame_z_min - 14], "Nyloc nut in hex pocket", [bx + 3, frame_split_nut_top_z - 2.5]);
    color(c_text) translate([0, 0, 3]) linear_extrude(0.5) {
        translate([x0, frame_z_min - 12]) text("Rail seen from the side", size = 4.5, font = "Liberation Sans");
    }
} else if (view == "case_in") {
    frame_bolted();
    rest(rest_far);
    translate([60, 0, 70]) {
        case_model();
    }
    arrow([60, 0, 140], [60, 0, 110], 4);
    arrow([60, 0, 50], [60, 0, 42], 4);
    arrow([40, -70, 12], [0, -70, 12], 4);
    translate([60, 0, 0]) case_model(ghost = true);
} else if (view == "grip_in") {
    frame_bolted();
    rest(rest_far);
    case_model();
    grip(40, 60);
    arrow([106, 0, 150], [106, 0, 115], 4);
    arrow([120, -70, 12], [85, -70, 12], 4);
    grip(40, 0, c_ghost);
} else if (view == "bolt_stack") {
    joint_body_sections(sec_x0, sec_x1);
    for (x_pos = [dyno_eye_x_left, dyno_eye_x_right])
        joint_hardware_sections(x_pos, 120, 55, -30, -48);
    for (x_pos = [dyno_eye_x_left, dyno_eye_x_right]) {
        flat_arrow([x_pos + 24, 150], [x_pos + 24, 50]);
        flat_arrow([x_pos + 24, -75], [x_pos + 24, -25]);
    }
    color(c_text) translate([0, 0, 3]) linear_extrude(0.5) {
        translate([dyno_eye_x_right + 30, 160]) text("Bolt + washer", size = 8, font = "Liberation Sans");
        translate([dyno_eye_x_right + 30, 70]) text("Steel sleeve", size = 8, font = "Liberation Sans");
        translate([dyno_eye_x_right + 30, -40]) text("Washer", size = 8, font = "Liberation Sans");
        translate([dyno_eye_x_right + 30, -62]) text("Nut", size = 8, font = "Liberation Sans");
        translate([dyno_eye_x_left - 22, -95]) text("Frame", size = 8, font = "Liberation Sans");
        translate([dyno_eye_x_right - 10, -95]) text("Grip", size = 8, font = "Liberation Sans");
    }
} else if (view == "bolt_done") {
    joint_body_sections(sec_x0, sec_x1);
    for (x_pos = [dyno_eye_x_left, dyno_eye_x_right])
        joint_hardware_sections(x_pos);
    joint_labels(dyno_eye_x_right, sec_x1 + 12);
    color(c_text) translate([0, 0, 3]) linear_extrude(0.5) {
        translate([sec_x0, -35]) text("Fixed clevis (frame)", size = 4.5, font = "Liberation Sans");
        translate([dyno_eye_x_left + 12, 52]) text("Crimpdeq case", size = 4.5, font = "Liberation Sans");
    }
} else if (view == "wrist_pin") {
    px = wrist_mount_x;
    py = wrist_mount_y_top;
    sec(c_frame, py, px - 32, px + 32) fixed_frame();
    sec(c_rest, py, px - 32, px + 32) adjustable_wrist_rest(0);
    sec(c_pin, py, px - 32, px + 32, 0, 1)
        translate([px, py, wrist_rest_z_max]) ball_lock_pin_model();
    lx = px + 40;
    label([lx, 52], "Pin head", [px + 7, wrist_rest_z_max + 4]);
    label([lx, 40], "Upper wrist arm", [px + 11, (wrist_plate_z_min_2 + wrist_plate_z_max_2) / 2]);
    label([lx, 12], "Frame rail (index holes)", [px + 12, (frame_z_min + frame_z_max) / 2]);
    label([lx, -15], "Lower wrist arm", [px + 11, (wrist_plate_z_min_1 + wrist_plate_z_max_1) / 2]);
    label([lx, -28], "Locking balls", [px + wrist_quick_pin_d / 2,
        wrist_rest_z_max - wrist_quick_pin_grip_l - wrist_quick_pin_lock_ball_d / 2 - 0.2]);
    flat_arrow([px - 40, 75], [px - 40, 45]);
    color(c_text) translate([px - 75, 80, 3]) linear_extrude(0.5)
        text("Insert from the top", size = 4.2, font = "Liberation Sans");
} else if (view == "position_min") {
    full_assembly(-wrist_adjust_range);
} else if (view == "position_max") {
    full_assembly(wrist_adjust_range);
} else {
    assert(false, str("Unknown view: ", view));
}
