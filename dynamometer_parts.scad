//
// Printable parts of the all-printed Crimpdeq finger dynamometer.
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

// Extrudes an XZ profile along Y, centred on y = 0.
module xz_profile_along_y(length) {
    rotate([90, 0, 0])
        linear_extrude(height = length, center = true)
            children();
}

// --- Eye lugs and keepers (modelled on the +X side, mirrored for the anchor)

module eye_lug() {
    // D-shaped stub through the outer half of the right eye, rooted 1 mm
    // into its seat, with a chamfered lead-in at the top.
    root_z = loadcell_bottom_z - 1;
    intersection() {
        translate([dyno_eye_x_right, dyno_eye_y, 0])
            union() {
                translate([0, 0, root_z])
                    cylinder(r = lug_r, h = lug_top_z - lug_chamfer - root_z);
                translate([0, 0, lug_top_z - lug_chamfer])
                    cylinder(r1 = lug_r, r2 = lug_r - lug_chamfer, h = lug_chamfer);
            }
        translate([lug_face_x, -lug_r - 1, root_z - 1])
            cube([2 * lug_r, 2 * lug_r + 2, lug_top_z - root_z + 2]);
    }
}

module keeper_tongue_2d(grow = 0) {
    // XZ profile: flat clamp face at the bottom, top flank rising into the
    // end wall so the tongue cannot pull out toward -X.
    x_tip = end_wall_x + keeper_tongue_depth;
    x_start = grow > 0 ? end_wall_x - 1 : keeper_x_max - 0.01;
    offset(delta = grow)
        polygon([
            [x_start, keeper_z_min],
            [x_tip, keeper_z_min],
            [x_tip, keeper_tongue_root_top_z],
            [end_wall_x, keeper_tongue_face_top_z],
            [x_start, keeper_tongue_face_top_z]
        ]);
}

module keeper_groove(length) {
    xz_profile_along_y(length + 2)
        keeper_tongue_2d(keeper_fit);
}

module tab_keeper_right() {
    // Clamps the right tab onto its seat, outboard of the eye.
    union() {
        translate([keeper_x_min, -keeper_len_y / 2, keeper_z_min])
            cube([keeper_x_max - keeper_x_min, keeper_len_y,
                  keeper_z_max - keeper_z_min]);
        xz_profile_along_y(keeper_len_y)
            keeper_tongue_2d();
    }
}

module tab_keeper(side = "right") {
    if (side == "right")
        tab_keeper_right();
    else
        mirror([1, 0, 0]) tab_keeper_right();
}

module tab_keepers() {
    tab_keeper("left");
    tab_keeper("right");
}

// --- Anchor block --------------------------------------------------------

module anchor_block_right() {
    difference() {
        union() {
            // Seat under the tab, down into the base pocket.
            translate([lug_face_x, -seat_half_w_y, anchor_z_min])
                cube([end_wall_x - lug_face_x + 0.01, 2 * seat_half_w_y,
                      loadcell_bottom_z - anchor_z_min]);
            dyno_rounded_prism_xy(end_wall_x, end_wall_x + anchor_wall_t,
                -seat_half_w_y, seat_half_w_y, anchor_z_min, end_wall_top_z, 3);
            eye_lug();
        }
        keeper_groove(2 * seat_half_w_y);
    }
}

module anchor_block() {
    mirror([1, 0, 0]) anchor_block_right();
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
        // Exact floor datum; the draft narrows the floor on every side.
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
            dyno_rounded_prism_xy(grip_x_min, grip_x_max,
                -grip_half_w_y, grip_half_w_y, grip_z_min, hangboard_front_z, 4);
        }
        // Tab seat: the jaw ends at the load-cell underside.
        translate([grip_x_min - 1, -grip_half_w_y - 1, loadcell_bottom_z])
            cube([end_wall_x - grip_x_min + 1, 2 * grip_half_w_y + 2,
                  hangboard_front_z]);
        keeper_groove(2 * grip_half_w_y);
        hangboard_pocket_cut();
        stopper_tab_slots();
    }
    eye_lug();
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
    // From the pocket frame into the storage well, long side along X.
    translate([stopper_well_center_x, stopper_well_center_y,
               stopper_well_z_min - hangboard_pocket_back_z])
        rotate([0, 0, 90])
            translate([-stopper_center_x, 0, 0])
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

// --- Base ----------------------------------------------------------------

module base_slab() {
    dyno_rounded_prism_xy(base_x_min, base_x_max, -base_half_w_y, base_half_w_y,
        base_z_min, deck_z, base_corner_r);
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

module rest_rail_2d(grow = 0) {
    // YZ profile of the dovetail rail, flaring upward.
    offset(delta = grow)
        polygon([
            [-rail_root_w / 2, deck_z - 1],
            [rail_root_w / 2, deck_z - 1],
            [rail_root_w / 2, deck_z],
            [rail_top_w / 2, rail_top_z],
            [-rail_top_w / 2, rail_top_z],
            [-rail_root_w / 2, deck_z]
        ]);
}

module rest_rail(x_min, x_max, grow = 0) {
    translate([x_min, 0, 0])
        rotate([90, 0, 90])
            linear_extrude(height = x_max - x_min)
                rest_rail_2d(grow);
}

module key_slot(x_pos, y_pos, z_min, z_max) {
    translate([x_pos - (key_t_x + key_fit) / 2, y_pos - (key_w_y + key_fit) / 2, z_min])
        cube([key_t_x + key_fit, key_w_y + key_fit, z_max - z_min]);
}

module base_key_slots() {
    for (i = [0 : rest_index_count - 1])
        for (y_pos = [-key_y, key_y])
            key_slot(key_x(rest_offset(i)), y_pos, key_slot_z_min, deck_z + 0.1);
}

module base_front() {
    difference() {
        union() {
            intersection() {
                base_slab();
                base_split_region();
            }
            joint_tongues();
        }
        anchor_pocket_cut();
        grip_trench_cut();
        stopper_well_cut();
    }
}

module base_rear() {
    difference() {
        union() {
            difference() {
                base_slab();
                base_split_region();
            }
            rest_rail(base_split_x, base_x_max - 1);
        }
        joint_tongues(joint_fit);
        base_key_slots();
    }
}

module base() {
    base_front();
    base_rear();
}

// --- Palm rest and keys --------------------------------------------------

module palm_bolster(face_x) {
    // Full-width bolster with a nearly flat top and rolled long edges. Its
    // -X face continues the palm face.
    x_max = face_x + rest_bolster_depth_x;
    shoulder_z = rest_bolster_z_max - max(rest_bolster_front_r, rest_bolster_rear_r);
    hull() {
        dyno_rounded_prism_xy(face_x, x_max, -rest_half_w_y, rest_half_w_y,
            rest_deck_z - rest_bolster_embed, shoulder_z, rest_corner_r);
        for (edge = [[face_x + rest_bolster_front_r, rest_bolster_front_r],
                     [x_max - rest_bolster_rear_r, rest_bolster_rear_r]])
            for (y_pos = [-rest_half_w_y + edge[1], rest_half_w_y - edge[1]])
                translate([edge[0], y_pos, rest_bolster_z_max - edge[1]])
                    sphere(r = edge[1], $fn = max(render_fn, 32));
    }
}

module palm_rest(offset = 0) {
    face_x = rest_face_x(offset);
    difference() {
        union() {
            // Solid heel deck with rounded top edges and a flat sole.
            intersection() {
                dyno_rounded_box_xyz(
                    [face_x + rest_depth_x / 2, 0,
                     (rest_z_min - rest_corner_r + rest_deck_z) / 2],
                    [rest_depth_x, 2 * rest_half_w_y,
                     rest_deck_z - rest_z_min + rest_corner_r],
                    rest_corner_r);
                translate([face_x - 1, -rest_half_w_y - 1, rest_z_min])
                    cube([rest_depth_x + 2, 2 * rest_half_w_y + 2,
                          rest_deck_z - rest_z_min + 1]);
            }
            palm_bolster(face_x);
            // Key wings outside the palm area.
            for (s = [-1, 1])
                dyno_rounded_prism_xy(face_x, face_x + rest_wing_len_x,
                    s > 0 ? rest_half_w_y - 4 : -rest_wing_y_max,
                    s > 0 ? rest_wing_y_max : -rest_half_w_y + 4,
                    rest_z_min, rest_wing_top_z, 3);
        }
        rest_rail(face_x - 1, face_x + rest_depth_x + 1, rail_fit);
        for (y_pos = [-key_y, key_y])
            key_slot(key_x(offset), y_pos, rest_z_min - 0.1, rest_wing_top_z + 0.1);
    }
}

module index_key(offset = 0, y_pos = key_y) {
    // Shank through the rest wing into a base slot; the head sits on the
    // wing and extends away from the fingers.
    x0 = key_x(offset) - key_t_x / 2;
    translate([x0, y_pos - key_w_y / 2, key_bottom_z])
        cube([key_t_x, key_w_y, rest_wing_top_z - key_bottom_z + 0.01]);
    translate([x0, y_pos - key_w_y / 2, rest_wing_top_z])
        dyno_rounded_prism_xy(0, key_head_x, 0, key_w_y, 0, key_head_h, 2);
}

module index_keys(offset = 0, lift = 0) {
    for (y_pos = [-key_y, key_y])
        translate([0, 0, lift]) index_key(offset, y_pos);
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
        on_side_layout(seat_half_w_y)
            translate([(anchor_x_min + anchor_x_max) / 2 * -1, 0, 0]) anchor_block();
    else if (part == "grip")
        on_side_layout(grip_half_w_y)
            translate([-(grip_x_min + grip_x_max) / 2, 0, 0]) finger_grip();
    else if (part == "keepers")
        // Flat on their clamp faces, side by side.
        for (i = [0, 1])
            translate([-(keeper_x_min + end_wall_x) / 2 + (i - 0.5) * 14, 0,
                       -keeper_z_min])
                tab_keeper_right();
    else if (part == "keys")
        // On their sides, heads toward +X.
        for (i = [0, 1])
            translate([(i - 0.5) * 24, 0, 0])
                on_side_layout(key_w_y / 2)
                    translate([-key_x(0), -key_y, -key_bottom_z])
                        index_key();
    else if (part == "rest")
        translate([-rest_face_x() - rest_depth_x / 2, 0, -rest_z_min]) palm_rest();
    else if (part == "stoppers")
        for (i = [0 : stopper_count - 1])
            translate([(i - (stopper_count - 1) / 2) * (stopper_x_max - stopper_x_min + 8)
                       - stopper_center_x, 0, -hangboard_pocket_back_z])
                pocket_stopper(i);
    else
        assert(false, str("Unknown part: ", part));
}

// Minimum X/Y corner of each print layout.
function print_layout_min(part) =
    part == "base_front" ? [(base_x_min - base_split_x) / 2, -base_half_w_y]
    : part == "base_rear" ? [-(base_x_max - base_split_x) / 2, -base_half_w_y]
    : part == "anchor" ? [-(anchor_x_max - anchor_x_min) / 2, anchor_z_min]
    : part == "grip" ? [-(grip_x_max - grip_x_min) / 2, grip_z_min]
    : part == "keepers" ? [(keeper_x_min - end_wall_x) / 2 - 7, -keeper_len_y / 2]
    : part == "keys" ? [-12 - key_t_x / 2, 0]
    : part == "stoppers" ? [-(stopper_x_max - stopper_x_min) - 4, stopper_tab_y_min(0)]
    : part == "rest" ? [-rest_depth_x / 2, -rest_wing_y_max]
    : undef;

// Front-left corner of each part on its plate, origin at the front-left bed
// corner. Plate 1 holds the front base half and the small parts, plate 2 the
// rear base half and the palm rest. Shared by the book's plate images and
// the Bambu Studio project.
function print_plate_corner(part) =
    part == "base_front" ? [10, 10]
    : part == "stoppers" ? [197, 10]
    : part == "grip" ? [10, 150]
    : part == "anchor" ? [80, 150]
    : part == "keepers" ? [125, 150]
    : part == "keys" ? [165, 150]
    : part == "base_rear" ? [10, 67]
    : part == "rest" ? [145, 67]
    : undef;

module print_plate_placement(part) {
    corner = print_plate_corner(part);
    assert(!is_undef(corner), str("Unknown part: ", part));
    translate(concat(corner - print_layout_min(part), [0]))
        children();
}
