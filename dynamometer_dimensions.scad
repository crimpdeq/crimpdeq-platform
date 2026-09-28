//
// All-printed Crimpdeq finger dynamometer: shared dimensions and screens.
// Units: mm, N, MPa. Origin: load-cell centre in X/Y, load-cell bottom face
// at Z = 0, matching the crimpdeq-case assembly coordinates.
//

// Crimpdeq compact-pod interface snapshot (crimpdeq-case/case). Keep in step
// with crimpdeq_reference.scad.
lc_L = 80;
lc_W = 40;
lc_T = 4;
loadcell_bottom_z = 0;
loadcell_top_z = loadcell_bottom_z + lc_T;
loadcell_center_z = loadcell_bottom_z + lc_T / 2;
eye_d = 17;
eye_center_offset = 6 + eye_d / 2;
dyno_eye_x_right = lc_L / 2 - eye_center_offset;
dyno_eye_x_left = -dyno_eye_x_right;
dyno_eye_y = 0;
// Pod outer faces. The load-cell ends pass through its side walls and stick
// out beyond them; the eyes straddle the pod faces.
case_x_half = 25.2;
case_y_min = -32.6;
case_y_max = 36.2;
case_z_min = -4.4;
case_lid_z = 23;
case_z_max = 25.4;
case_corner_r = 6;
case_wall_t = 2.4;
case_eye_access_d = 13;
case_eye_tunnel_d = 16.4;
// +Y wall openings.
case_usb_x = -4.55;
case_usb_z = 17.6;
case_usb_w = 10.1;
case_usb_h = 4.4;
case_switch_x = 0;
case_switch_z = 3;
case_switch_w = 15;
case_switch_h = 10;
usb_cable_boot_w = 12;
case_center_y = (case_y_min + case_y_max) / 2;

// Verified sensor rating and the printed structure's design target.
loadcell_rated_kg = is_undef(loadcell_rated_kg) ? 50 : loadcell_rated_kg;
gravity = 9.80665;
loadcell_rated_force_n = loadcell_rated_kg * gravity;
structural_safety_factor = is_undef(structural_safety_factor) ? 2.0 : structural_safety_factor;
design_force_n = loadcell_rated_force_n * structural_safety_factor;

// Printed eye lugs. Each lug is a D-shaped stub that rises through the
// exposed outer half of a load-cell eye. Its flat face stays pod_clear_x
// outside the pod, so no printed part touches the enclosure. Pulling the
// grip (+X) presses the outer rim of each eye against a lug.
pod_clear_x = is_undef(pod_clear_x) ? 1.2 : pod_clear_x;
lug_fit = is_undef(lug_fit) ? 0.25 : lug_fit;
lug_face_x = case_x_half + pod_clear_x;
lug_r = eye_d / 2 - lug_fit;
lug_flat_d = lug_face_x - dyno_eye_x_right;
lug_top_z = loadcell_top_z + 1.5;
lug_chamfer = 1;
lug_chord_y = 2 * sqrt(lug_r * lug_r - lug_flat_d * lug_flat_d);
// The tab outboard of each eye rests on a flat seat at Z = 0.
tab_end_x = lc_L / 2;
end_wall_x = tab_end_x + 0.5;
seat_half_w_y = is_undef(seat_half_w_y) ? 26 : seat_half_w_y;

// Slide-in keepers clamp each tab onto its seat. A half-dovetail tongue runs
// in a groove across the part's end wall; it resists lift and pull-out, and
// its flat underside is the clamp face. Keepers carry no measured load.
keeper_fit = is_undef(keeper_fit) ? 0.15 : keeper_fit;
keeper_x_min = dyno_eye_x_right + eye_d / 2 + 0.5;
keeper_x_max = end_wall_x - 0.3;
keeper_z_min = loadcell_top_z;
keeper_z_max = keeper_z_min + 5.5;
keeper_tongue_depth = 3.5;
keeper_tongue_face_top_z = keeper_z_min + 3;
keeper_tongue_root_top_z = keeper_z_min + 5;
keeper_len_y = 2 * seat_half_w_y;
// Travel before a keeper's flank catches, pulled away from its wall.
keeper_flank_angle = atan((keeper_tongue_root_top_z - keeper_tongue_face_top_z)
    / keeper_tongue_depth);
keeper_catch_travel = keeper_fit / sin(keeper_flank_angle);
end_wall_top_z = is_undef(end_wall_top_z) ? 11 : end_wall_top_z;

// Four-finger hangboard pocket, loaded on its +X lip. Its mid-depth sits
// near the load-cell plane so the finger pull adds little tilt.
grip_x_min = lug_face_x;
grip_spine_t = is_undef(grip_spine_t) ? 8 : grip_spine_t;
hangboard_opening_w_x = is_undef(hangboard_opening_w_x) ? 20 : hangboard_opening_w_x;
hangboard_opening_w_y = is_undef(hangboard_opening_w_y) ? 80 : hangboard_opening_w_y;
hangboard_side_wall_t = 4;
hangboard_right_lip_t = 10;
hangboard_opening_x_min = end_wall_x + grip_spine_t;
hangboard_opening_x_max = hangboard_opening_x_min + hangboard_opening_w_x;
grip_x_max = hangboard_opening_x_max + hangboard_right_lip_t;
grip_half_w_y = hangboard_opening_w_y / 2 + hangboard_side_wall_t;
hangboard_opening_y_min = -hangboard_opening_w_y / 2;
hangboard_opening_y_max = hangboard_opening_w_y / 2;
hangboard_front_z = is_undef(hangboard_front_z) ? 11 : hangboard_front_z;
hangboard_pocket_depth_z = is_undef(hangboard_pocket_depth_z) ? 25 : hangboard_pocket_depth_z;
hangboard_pocket_back_z = hangboard_front_z - hangboard_pocket_depth_z;
hangboard_back_wall_t = is_undef(hangboard_back_wall_t) ? 6 : hangboard_back_wall_t;
grip_z_min = hangboard_pocket_back_z - hangboard_back_wall_t;
hangboard_opening_r = 4;
hangboard_draft = 1;
hangboard_lip_radius = is_undef(hangboard_lip_radius) ? 2 : hangboard_lip_radius;
hangboard_lip_min_t = hangboard_right_lip_t - hangboard_lip_radius;

// Base. The case floats case_float_gap above the deck; only the lugs carry
// it. The grip hangs in a trench, and ledges under its side walls catch
// tilt with a small Z gap while leaving X free.
case_float_gap = is_undef(case_float_gap) ? 1.0 : case_float_gap;
deck_z = case_z_min - case_float_gap;
base_z_min = is_undef(base_z_min) ? -28 : base_z_min;
base_half_w_y = is_undef(base_half_w_y) ? 61 : base_half_w_y;
base_corner_r = 6;
grip_guide_gap_z = is_undef(grip_guide_gap_z) ? 0.3 : grip_guide_gap_z;
grip_guide_bearing_y = is_undef(grip_guide_bearing_y) ? 4 : grip_guide_bearing_y;
grip_side_gap_y = 3;
trench_x_min = grip_x_min - 1;
trench_x_max = grip_x_max + 4;
trench_half_w_y = grip_half_w_y + grip_side_gap_y;
trench_floor_z = grip_z_min - 1.5;
grip_guide_z_max = grip_z_min - grip_guide_gap_z;
grip_guide_inner_y = grip_half_w_y - grip_guide_bearing_y;
rated_preview_deflection = 0.4;

// Anchor block, dropped into a pocket in the base. Under load it bears on
// the pocket's +X wall, below the floating case.
anchor_play_x = is_undef(anchor_play_x) ? 0.2 : anchor_play_x;
anchor_fit = 0.3;
anchor_wall_t = is_undef(anchor_wall_t) ? 14 : anchor_wall_t;
anchor_x_min = -(end_wall_x + anchor_wall_t);
anchor_x_max = -lug_face_x;
anchor_z_min = is_undef(anchor_z_min) ? -22 : anchor_z_min;
anchor_pocket_x_min = anchor_x_min - anchor_fit;
anchor_pocket_x_max = anchor_x_max + anchor_play_x;
anchor_pocket_half_w_y = seat_half_w_y + anchor_fit;

// Two drop-in pocket stoppers raise the floor for shallower edges: each on
// its own, or both stacked. The pocket walls locate them; a pull tab on one
// end face of each runs in a slot in the pocket end wall and stands proud of
// the grip top.
stopper_t_list = is_undef(stopper_t_list) ? [5, 10] : stopper_t_list;
stopper_clearance = is_undef(stopper_clearance) ? 0.25 : stopper_clearance;
stopper_count = len(stopper_t_list);
stopper_x_min = hangboard_opening_x_min + hangboard_draft + stopper_clearance;
stopper_x_max = hangboard_opening_x_max - hangboard_draft - stopper_clearance;
stopper_center_x = (stopper_x_min + stopper_x_max) / 2;
stopper_y_min = hangboard_opening_y_min + hangboard_draft + stopper_clearance;
stopper_y_max = hangboard_opening_y_max - hangboard_draft - stopper_clearance;
stopper_r = hangboard_opening_r - hangboard_draft;
stopper_tab_t_y = 3;
stopper_tab_w_x = 8;
stopper_tab_rise = is_undef(stopper_tab_rise) ? 6 : stopper_tab_rise;
stopper_tab_h = hangboard_pocket_depth_z + stopper_tab_rise;
stopper_tab_clearance = 0.25;
stopper_tab_gap_y = 0.02;
function stopper_tab_y_min(i) = i == 0
    ? stopper_y_min - stopper_tab_gap_y - stopper_tab_t_y
    : stopper_y_max + stopper_tab_gap_y;
stopper_tab_slot_w_x = stopper_tab_w_x + 2 * stopper_tab_clearance;
stopper_tab_slot_y_min =
    stopper_y_min - stopper_tab_gap_y - stopper_tab_t_y - stopper_tab_clearance;
stopper_tab_slot_y_max =
    stopper_y_max + stopper_tab_gap_y + stopper_tab_t_y + stopper_tab_clearance;
stopper_tab_slot_skin_y = min(stopper_tab_slot_y_min + grip_half_w_y,
    grip_half_w_y - stopper_tab_slot_y_max);
function sum_list(v, i = 0) = i >= len(v) ? 0 : v[i] + sum_list(v, i + 1);
stopper_stack_h = sum_list(stopper_t_list);
stopper_min_t = min(stopper_t_list);
stopper_edge_depths = concat(
    [for (t = stopper_t_list) hangboard_pocket_depth_z - t],
    [hangboard_pocket_depth_z - stopper_stack_h]);
all_edge_depths = concat([hangboard_pocket_depth_z], stopper_edge_depths);
// Height of each edge's mid-depth above the load-cell plane.
edge_pull_offsets = [for (e = all_edge_depths) hangboard_front_z - e / 2 - loadcell_center_z];
edge_pull_offset_max = is_undef(edge_pull_offset_max) ? 5 : edge_pull_offset_max;

// Storage well for the stacked stoppers in the -Y side of the deck, turned
// so their long side runs along X.
stopper_well_clearance = 0.5;
stopper_well_len_x = stopper_tab_slot_y_max - stopper_tab_slot_y_min
    + 2 * stopper_well_clearance;
stopper_well_w_y = stopper_x_max - stopper_x_min + 2 * stopper_well_clearance;
stopper_well_x_max = trench_x_min - 3;
stopper_well_x_min = stopper_well_x_max - stopper_well_len_x;
stopper_well_center_x = (stopper_well_x_min + stopper_well_x_max) / 2;
stopper_well_y_min = -base_half_w_y + 3;
stopper_well_y_max = stopper_well_y_min + stopper_well_w_y;
stopper_well_center_y = (stopper_well_y_min + stopper_well_y_max) / 2;
stopper_well_depth_z = stopper_stack_h + 1;
stopper_well_z_min = deck_z - stopper_well_depth_z;

// Palm rest. Its upright palm face sits hand_opening from the outside of the
// finger lip; nine positions give 25-105 mm in 10 mm steps. The rest slides
// on a dovetail rail and two printed keys lock it through its side wings.
hand_opening = is_undef(hand_opening) ? 65 : hand_opening;
rest_adjust_range = is_undef(rest_adjust_range) ? 40 : rest_adjust_range;
rest_index_pitch = is_undef(rest_index_pitch) ? 10 : rest_index_pitch;
rest_index_count = round(2 * rest_adjust_range / rest_index_pitch) + 1;
hand_opening_min = hand_opening - rest_adjust_range;
hand_opening_max = hand_opening + rest_adjust_range;
function rest_face_x(offset = 0) = grip_x_max + hand_opening + offset;
function rest_offset(i) = -rest_adjust_range + i * rest_index_pitch;
rest_depth_x = is_undef(rest_depth_x) ? 60 : rest_depth_x;
rest_half_w_y = is_undef(rest_half_w_y) ? 39 : rest_half_w_y;
rest_z_min = deck_z;
rest_deck_z = hangboard_front_z;
rest_corner_r = 5;
rest_bolster_depth_x = is_undef(rest_bolster_depth_x) ? 22 : rest_bolster_depth_x;
rest_bolster_rise = is_undef(rest_bolster_rise) ? 20 : rest_bolster_rise;
rest_bolster_front_r = 6;
rest_bolster_rear_r = 5;
rest_bolster_embed = 6;
rest_bolster_z_max = rest_deck_z + rest_bolster_rise;
rest_wing_len_x = 24;
rest_wing_top_z = is_undef(rest_wing_top_z) ? 5 : rest_wing_top_z;
rest_wing_y_max = base_half_w_y;

// Dovetail rail on the rear half of the base; the rest's groove captures it.
rail_root_w = 20;
rail_top_w = 28;
rail_h = 6;
rail_fit = 0.3;
rail_top_z = deck_z + rail_h;
// Lift before the rest's groove catches the rail flanks.
rail_catch_travel = rail_fit / sin(atan((rail_top_w - rail_root_w) / 2 / rail_h));

// Printed index keys: a rectangular shank with a head, printed on its side
// so the shear plane lies across the layers' long direction.
key_t_x = is_undef(key_t_x) ? 6 : key_t_x;
key_w_y = is_undef(key_w_y) ? 16 : key_w_y;
key_fit = 0.3;
key_y = is_undef(key_y) ? 49 : key_y;
key_offset_x = rest_wing_len_x / 2;
function key_x(offset = 0) = rest_face_x(offset) + key_offset_x;
key_slot_depth = is_undef(key_slot_depth) ? 14 : key_slot_depth;
key_slot_z_min = deck_z - key_slot_depth;
key_bottom_z = key_slot_z_min + 0.5;
key_head_x = 14;
key_head_h = 8;
key_head_z_max = rest_wing_top_z + key_head_h;
key_shank_l = rest_wing_top_z - key_bottom_z;

// Two-piece base for a 256 mm bed (Bambu Lab A1). Two vertical dovetail
// tongues on the front half drop into sockets in the rear half. Under load
// the butt faces are in compression.
base_split_x = is_undef(base_split_x) ? 90 : base_split_x;
base_split_bed_max = is_undef(base_split_bed_max) ? 240 : base_split_bed_max;
print_bed_size = is_undef(print_bed_size) ? 256 : print_bed_size;
base_x_min = min(anchor_pocket_x_min, stopper_well_x_min) - 3;
base_x_max = key_x(rest_adjust_range) + key_t_x / 2 + 7;
joint_tongue_y = 30;
joint_tongue_len_x = 12;
joint_tongue_neck_w = 12;
joint_tongue_head_w = 18;
joint_fit = 0.2;
joint_roof_t = 3;
joint_tongue_z_max = deck_z - joint_roof_t - joint_fit;
// Separation before the sockets catch the tongue flanks.
joint_catch_travel = joint_fit
    / sin(atan((joint_tongue_head_w - joint_tongue_neck_w) / 2 / joint_tongue_len_x));
base_front_len = base_split_x + joint_tongue_len_x - base_x_min;
base_rear_len = base_x_max - base_split_x;

// Service access to the switch and USB through the open +Y side.
service_w = 30;
service_y_max = base_half_w_y + 20;

// --- Structural screens at the design target -------------------------------
// Nominal screens, not a strength qualification. Printed-material limits are
// assumptions that need coupon tests in the actual print orientation.
allowable_printed_bending_mpa = is_undef(allowable_printed_bending_mpa) ? 30 : allowable_printed_bending_mpa;
allowable_printed_tension_mpa = is_undef(allowable_printed_tension_mpa) ? 12 : allowable_printed_tension_mpa;
allowable_printed_bearing_mpa = is_undef(allowable_printed_bearing_mpa) ? 12 : allowable_printed_bearing_mpa;
// Conformal contact of the metal eye on a solid printed lug, about 40 % of
// PETG's compressive yield. The governing assumption of the all-printed
// load path.
allowable_lug_bearing_mpa = is_undef(allowable_lug_bearing_mpa) ? 20 : allowable_lug_bearing_mpa;

// D-section of each lug (the part of a lug_r circle beyond the flat),
// integrated in strips along the load direction.
lug_strips = 200;
lug_dx = (lug_r - lug_flat_d) / lug_strips;
function lug_strip_x(i) = lug_flat_d + (i + 0.5) * lug_dx;
function lug_strip_w(i) = 2 * sqrt(lug_r * lug_r - pow(lug_strip_x(i), 2));
lug_area_mm2 = sum_list([for (i = [0 : lug_strips - 1]) lug_strip_w(i) * lug_dx]);
lug_centroid = sum_list([for (i = [0 : lug_strips - 1])
    lug_strip_w(i) * lug_strip_x(i) * lug_dx]) / lug_area_mm2;
lug_inertia_mm4 = sum_list([for (i = [0 : lug_strips - 1])
    lug_strip_w(i) * pow(lug_strip_x(i) - lug_centroid, 2) * lug_dx]);
lug_section_modulus_mm3 = lug_inertia_mm4
    / max(lug_centroid - lug_flat_d, lug_r - lug_centroid);
// The eye bears across the full tab thickness; its resultant acts at the
// tab mid-plane above the lug root.
lug_bearing_mpa = design_force_n / (lug_chord_y * lc_T);
lug_bending_mpa = design_force_n * (loadcell_center_z - loadcell_bottom_z)
    / lug_section_modulus_mm3;
lug_shear_mpa = design_force_n / lug_area_mm2;

// Anchor block bearing on the pocket's +X wall below the case.
anchor_bearing_mpa = design_force_n / (2 * seat_half_w_y * (deck_z - anchor_z_min));

// Full force at the pocket rim, over its usable width.
lip_section_modulus_mm3 = hangboard_opening_w_y * pow(hangboard_lip_min_t, 2) / 6;
lip_design_bending_mpa = design_force_n * hangboard_pocket_depth_z / lip_section_modulus_mm3;
// Pocket side walls and back wall carry the lip force back to the lug.
grip_net_area_mm2 = 2 * hangboard_side_wall_t * (hangboard_front_z - grip_z_min)
    + 2 * grip_half_w_y * hangboard_back_wall_t;
grip_net_tension_mpa = design_force_n / grip_net_area_mm2;

// Either key alone takes the whole palm force.
key_shear_mpa = design_force_n / (key_t_x * key_w_y);
key_wing_bearing_mpa = design_force_n / (key_w_y * (rest_wing_top_z - rest_z_min));
key_slot_bearing_mpa = design_force_n / (key_w_y * key_slot_depth);
key_ligament_x = rest_index_pitch - key_t_x - key_fit;
key_ligament_shear_mpa = design_force_n / (2 * key_ligament_x * key_slot_depth);
// Palm bolster root, with the force at mid-rise; stress across the layers.
rest_bolster_bending_mpa = design_force_n * rest_bolster_rise / 2
    / (2 * rest_half_w_y * pow(rest_bolster_depth_x, 2) / 6);
// Tipping the rest about its front edge lifts its tail; the rail's two
// overhanging flanks hold it over the shortest engaged length.
rest_min_engaged_x = base_x_max - rest_face_x(rest_adjust_range);
rest_uplift_n = design_force_n * (rest_bolster_z_max - deck_z) / rest_depth_x;
rail_flank_shear_mpa = rest_uplift_n / (2 * rest_min_engaged_x * rail_h / 2);

assert(loadcell_rated_kg == 50, "This interface is restricted to the 50 kg sensor.");
assert(structural_safety_factor >= 2, "Use a structural design factor of at least 2.0.");
assert(pod_clear_x - anchor_play_x >= 0.8,
    "Lug parts must stay at least 0.8 mm clear of the pod, even at full anchor play.");
assert(lug_flat_d >= 0 && lug_flat_d < lug_r / 3 && lug_chord_y >= 15,
    "The lug flat must sit just outboard of the eye centre and keep a wide bearing chord.");
assert(lug_fit >= 0.15 && lug_fit <= 0.4, "Lugs need a 0.15-0.4 mm radial fit in the eye.");
assert(lug_bearing_mpa <= allowable_lug_bearing_mpa,
    "Eye bearing on the printed lug exceeds the configured limit.");
assert(lug_bending_mpa <= allowable_printed_bending_mpa &&
    lug_shear_mpa <= allowable_printed_tension_mpa,
    "Printed lug root exceeds configured bending or shear stress.");
assert(keeper_x_min > dyno_eye_x_right + eye_d / 2 &&
    keeper_x_max < end_wall_x && keeper_x_max - keeper_x_min >= 5,
    "Keepers must clamp the tab between the eye and its end.");
assert(keeper_tongue_root_top_z + keeper_fit < end_wall_top_z - 1.5 &&
    keeper_z_max < hangboard_front_z,
    "Keeper grooves need wall above them and keepers must stay below the grip top.");
assert(keeper_catch_travel <= 0.4 && rail_catch_travel <= 0.6 && joint_catch_travel <= 1,
    "Dovetail flanks are too shallow to hold their parts closely.");
assert(case_float_gap >= 1, "The case must float at least 1 mm above the deck.");
assert(hangboard_pocket_depth_z == 25, "The hangboard pocket must remain 25 mm deep.");
assert(hangboard_back_wall_t >= 6, "Hangboard pocket back wall must be at least 6 mm thick.");
assert(hangboard_opening_w_y >= 80, "Four-finger opening must be at least 80 mm wide.");
assert(hangboard_lip_radius > 0 && hangboard_lip_radius <= 2,
    "Loading-edge radius must be in (0, 2] mm.");
assert(hangboard_lip_min_t >= 8,
    "Rounded hangboard loading lip must retain at least 8 mm thickness.");
assert(hangboard_opening_w_x - 2 * hangboard_draft >= 18,
    "Finger pocket must retain at least 18 mm clearance at its floor.");
assert(max([for (o = edge_pull_offsets) abs(o)]) <= edge_pull_offset_max,
    "Every edge's mid-depth must stay near the load-cell plane.");
assert(stopper_count == 2 &&
    (stopper_edge_depths == [20, 15, 10] || stopper_edge_depths == [15, 20, 10]),
    "Use two stoppers that give 20 and 15 mm edges alone and 10 mm stacked.");
assert(stopper_clearance >= 0.15 && stopper_clearance <= 0.4 &&
    stopper_r >= 2 && stopper_min_t >= 5,
    "Stoppers need a sliding fit and at least 5 mm thickness.");
assert(stopper_tab_rise >= 4 && stopper_tab_rise <= 10 &&
    stopper_tab_slot_w_x <= stopper_x_max - stopper_x_min - 2 * stopper_r &&
    stopper_tab_slot_skin_y >= 1.8,
    "Stopper pull tabs must stand proud, fit the straight ends, and leave 1.8 mm of pocket end wall behind their slots.");
assert(grip_guide_gap_z > 0 && grip_guide_gap_z <= 0.5 && grip_guide_bearing_y >= 3 &&
    trench_floor_z > base_z_min + 5,
    "Grip guides need a small Z gap, a real bearing width and a solid trench floor.");
assert(anchor_z_min > base_z_min + 5 && anchor_bearing_mpa <= allowable_printed_bearing_mpa,
    "Anchor pocket needs a solid floor and bearing area.");
assert(lip_design_bending_mpa <= allowable_printed_bending_mpa &&
    grip_net_tension_mpa <= allowable_printed_tension_mpa,
    "Finger lip or grip body exceeds configured nominal stress.");
assert(hand_opening_min == 25 && hand_opening_max == 105 && rest_index_count == 9,
    "Preserve nine 25-105 mm hand openings.");
assert(abs(2 * rest_adjust_range
    - rest_index_pitch * round(2 * rest_adjust_range / rest_index_pitch)) < 0.001,
    "The rest travel must divide evenly into indexed positions.");
assert(rest_face_x(-rest_adjust_range) >= trench_x_max + 15,
    "The palm rest gets too close to the grip trench at its smallest opening.");
assert(rest_bolster_rise >= 18 && rest_bolster_rise <= 24 &&
    rest_bolster_depth_x >= 20 && rest_bolster_depth_x < rest_depth_x - 30,
    "The palm bolster must rise 18-24 mm and leave a 30 mm heel deck behind it.");
assert(rest_bolster_z_max >= key_head_z_max + 2,
    "The palm bolster must rise at least 2 mm above the key heads.");
assert(key_y - key_w_y / 2 - key_fit > rest_half_w_y + 1 &&
    key_y + key_w_y / 2 + key_fit < base_half_w_y - 3,
    "Keys must sit outside the palm area with at least 3 mm of outer wall.");
assert(key_ligament_x >= 3 &&
    key_shear_mpa <= allowable_printed_tension_mpa &&
    key_wing_bearing_mpa <= allowable_printed_bearing_mpa &&
    key_slot_bearing_mpa <= allowable_printed_bearing_mpa &&
    key_ligament_shear_mpa <= allowable_printed_tension_mpa,
    "Index keys, wings, slots or slot ligaments exceed configured stress.");
assert(key_slot_z_min > base_z_min + 5, "Key slots need a solid floor.");
assert(rest_bolster_bending_mpa <= allowable_printed_tension_mpa,
    "Palm bolster exceeds configured cross-layer stress.");
assert(rest_min_engaged_x >= 20 && rail_flank_shear_mpa <= allowable_printed_tension_mpa / 2,
    "The rest must keep 20 mm of rail engagement and the rail flanks their strength.");
assert(rail_top_z < rest_deck_z - 6, "The rail groove must leave 6 mm of rest above it.");
assert(base_front_len <= base_split_bed_max && base_rear_len <= base_split_bed_max,
    "Each base half must fit the printable length.");
assert(base_split_x >= trench_x_max + 6,
    "The grip trench must end at least 6 mm before the base joint.");
assert(base_split_x + joint_tongue_len_x + 3 < key_x(-rest_adjust_range) - key_t_x / 2,
    "Base joint sockets must clear the first key slot.");
assert(stopper_well_y_max < case_y_min - 3 && stopper_well_x_min > base_x_min + 2 &&
    stopper_well_z_min > base_z_min + 5,
    "The stopper well must stay clear of the case and keep solid walls and floor.");
