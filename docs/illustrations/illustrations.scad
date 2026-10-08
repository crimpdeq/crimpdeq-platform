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

c_base = [0.40, 0.42, 0.46];
c_base_b = [0.58, 0.60, 0.64];
c_anchor = [0.85, 0.35, 0.20];
c_grip = [0.20, 0.45, 0.78];
c_rest = [0.95, 0.55, 0.15];
c_case = [0.12, 0.20, 0.32, 0.55];
c_loadcell = [0.75, 0.75, 0.78];
c_clip = [0.92, 0.76, 0.20];
c_key = [0.45, 0.80, 0.45];
c_stopper = [0.20, 0.62, 0.58];
c_phone = [0.10, 0.10, 0.12, 0.75];
c_arrow = [0.90, 0.10, 0.10];
c_plate = [0.66, 0.67, 0.70];
// Mid-grey text and translucent ghosts read on both light and dark pages.
c_text = [0.46, 0.47, 0.52];
c_ghost = [0.60, 0.62, 0.66, 0.30];

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
    if (!ghost) color(c_loadcell) loadcell_reference();
}

// OpenCSG previews differenced parts with the wrong colours; render them.
module base_halves(gap = 0) {
    color(c_base) render() base_front();
    color(c_base_b) translate([gap, 0, 0]) render() base_rear();
}

module anchor(dz = 0) { color(c_anchor) translate([0, 0, dz]) render() anchor_block(); }
module grip(dx = 0, dz = 0, c = c_grip) { color(c) translate([dx, 0, dz]) render() finger_grip(); }
module clips() { color(c_clip) render() eye_clips(); }
module rest(offset = 0, dx = 0) { color(c_rest) translate([dx, 0, 0]) render() palm_rest(offset); }
module keys(offset = 0, pull = 0) { color(c_key) index_keys(offset, pull); }
module stored_stoppers() { color(c_stopper) stored_pocket_stoppers(); }

module full_assembly(offset = 0) {
    base_halves();
    anchor();
    grip();
    clips();
    case_model();
    rest(offset);
    keys(offset);
    stored_stoppers();
}

module build_plate(label) {
    color(c_plate) translate([0, 0, -1.2]) cube([print_bed_size, print_bed_size, 1]);
    color(c_text)
        translate([6, -14, -1])
            linear_extrude(0.5) text(label, size = 9);
}

module plate_part(part, c) {
    color(c) print_plate_placement(part) render() print_layout(part);
}

if (view == "overview") {
    full_assembly(0);
} else if (view == "plate1") {
    build_plate("Plate 1: front base half, grip and small parts");
    plate_part("base_front", c_base);
    plate_part("grip", c_grip);
    plate_part("anchor", c_anchor);
    plate_part("clips", c_clip);
    plate_part("keys", c_key);
} else if (view == "plate2") {
    build_plate("Plate 2: rear base half, palm rest and stoppers");
    plate_part("stoppers", c_stopper);
    plate_part("base_rear", c_base_b);
    plate_part("rest", c_rest);
} else if (view == "join_base") {
    // The rear half is lowered onto the front half's dovetail tongues.
    color(c_base) render() base_front();
    color(c_base_b) translate([0, 0, 45]) render() base_rear();
    for (y_pos = [-joint_tongue_y, joint_tongue_y])
        arrow([base_split_x + 20, y_pos, 60], [base_split_x + 20, y_pos, 30], 3);
} else if (view == "anchor_in") {
    base_halves();
    anchor(40);
    arrow([anchor_x_min - 12, 0, 60], [anchor_x_min - 12, 0, 25], 3);
    color(c_ghost) render() anchor_block();
} else if (view == "case_in") {
    // The case is lowered so both load-cell eyes drop over their lugs.
    base_halves();
    anchor();
    grip();
    translate([0, 0, 45]) case_model();
    for (x_pos = [dyno_eye_x_left, dyno_eye_x_right])
        arrow([x_pos, -50, 60], [x_pos, -50, 30], 3);
    case_model(ghost = true);
} else if (view == "clips_in") {
    // Each clip drops into its U-slot beside the lug, then slides in until
    // it snaps round the neck.
    base_halves();
    anchor();
    grip();
    case_model();
    color(c_clip) {
        render() eye_clip("left");
        translate([0, 0, 30]) render() eye_clip("right", dx = clip_install_travel);
    }
    x_drop = dyno_eye_x_right + clip_install_travel + clip_tail_x / 2;
    arrow([x_drop, 0, 75], [x_drop, 0, 58], 3);
    arrow([x_drop + 6, 0, 45], [dyno_eye_x_right + clip_tail_x / 2 + 2, 0, 45], 3);
} else if (view == "rest_on") {
    // The palm rest slides into its channel from the rear end, then a key
    // slides in under it from each side.
    base_halves();
    anchor();
    grip();
    clips();
    case_model();
    rest(0, 70);
    keys(0, 40);
    arrow([rest_face_x() + rest_depth_x + 90, 0, 45],
          [rest_face_x() + rest_depth_x + 40, 0, 45], 4);
    key_z = (key_z_min + key_z_max) / 2;
    for (s = [-1, 1])
        arrow([key_x(0), s * (base_half_w_y + 85), key_z],
              [key_x(0), s * (base_half_w_y + 60), key_z], 3);
} else if (view == "stoppers") {
    // The 5 mm stopper in the pocket, the 10 mm one lowered onto it.
    base_halves();
    anchor();
    grip();
    clips();
    case_model();
    color(c_stopper) {
        pocket_stopper(0);
        translate([0, 0, 45]) pocket_stopper(1);
    }
    arrow([stopper_center_x + 32, 0, 80], [stopper_center_x + 32, 0, 50], 4);
} else if (view == "phone") {
    full_assembly(0);
    color(c_phone) phone_reference();
} else {
    assert(false, str("Unknown view: ", view));
}
