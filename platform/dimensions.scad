//
// All-printed Crimpdeq finger dynamometer: shared dimensions and screens.
// Units: mm, N, MPa. Origin: load-cell centre in X/Y, load-cell bottom face
// at Z = 0, matching the crimpdeq-case assembly coordinates.
//

// Crimpdeq v2 interface snapshot (crimpdeq-case v2.0.0). Keep in step with
// crimpdeq_reference.scad.
lc_L = 80;
lc_W = 40;
lc_T = 4;
loadcell_bottom_z = 0.5;
loadcell_top_z = loadcell_bottom_z + lc_T;
loadcell_center_z = loadcell_bottom_z + lc_T / 2;
eye_d = 17;
eye_center_offset = 6 + eye_d / 2;
// A ring pressed into each eye narrows its bore; the case is sized round
// eye_d, the lugs round the bore.
eye_bore_d = 15;
dyno_eye_x_right = lc_L / 2 - eye_center_offset;
dyno_eye_x_left = -dyno_eye_x_right;
dyno_eye_y = 0;
// The case encloses the whole load cell. Each eye is reached through a
// vertical U-slot: a circle round the eye, open to the case end, through
// the full height of the case and lid.
case_x_half = 43.8;
case_y_min = -35.7;
case_y_max = 36.9;
case_z_min = -5;
case_lid_z = 25;
case_z_max = 28;
case_corner_r = 6;
case_wall_t = 3;
case_eye_access_d = eye_d + 1;
case_eye_u_d = case_eye_access_d + 4;
// Lid battery walls hang into the inboard edge of each U-slot above the
// load cell, and a lid bridge joins each to the U-slot at the top.
case_battery_wall_x = 18.3;
case_battery_wall_t = 1.2;
case_battery_wall_l_y = 24;
case_battery_wall_z_min = 5.1;
case_u_bridge_x_min = 13.9;
// +Y wall openings; the USB opening runs up to the lid seam.
case_usb_x = 0;
case_usb_z = 22.9;
case_usb_w = 12;
case_usb_h = 11;
case_switch_x = 0;
case_switch_z = 3;
case_switch_w = 15;
case_switch_h = 10;

// Platform rating and the printed structure's design target. The Crimpdeq is
// rated to 1500 N; the printed lugs in its eyes limit the platform to 49 kg.
loadcell_rated_force_n = 1500;
platform_rated_kg = is_undef(platform_rated_kg) ? 49 : platform_rated_kg;
gravity = 9.80665;
platform_rated_force_n = platform_rated_kg * gravity;
structural_safety_factor = is_undef(structural_safety_factor) ? 2.0 : structural_safety_factor;
design_force_n = platform_rated_force_n * structural_safety_factor;

// The case floats case_float_gap above the deck and clear of every part.
case_float_gap = is_undef(case_float_gap) ? 1.0 : case_float_gap;
deck_z = case_z_min - case_float_gap;

// Printed eye lugs. A narrow tongue rises from the anchor block and from the
// grip through each eye's U-slot, keeping u_slot_clear from the case; the
// load cell rests on its top. A round lug on the tongue fills the eye's
// bore; pulling the grip (+X) presses the outer rim of each eye against a
// lug.
// Above the load cell the lug necks down under a head that holds a clip.
u_slot_clear = is_undef(u_slot_clear) ? 1.0 : u_slot_clear;
tongue_r = case_eye_u_d / 2 - u_slot_clear;
lug_fit = is_undef(lug_fit) ? 0.35 : lug_fit;
lug_r = eye_bore_d / 2 - lug_fit;
lug_neck_r = is_undef(lug_neck_r) ? 5.25 : lug_neck_r;
// Flat ring under the head that the clip bears on, out to the head's rim.
lug_head_flat_w = is_undef(lug_head_flat_w) ? lug_r - lug_neck_r : lug_head_flat_w;
lug_head_chamfer = lug_r - lug_neck_r - lug_head_flat_w;
lug_top_chamfer = 1;
// Above the load cell, the neck and head are cut flat on their inboard side
// to clear the lid battery walls; the eye only bears on the outboard side.
lug_upper_flat_x = case_battery_wall_x + case_battery_wall_t / 2 + u_slot_clear;
clip_t = is_undef(clip_t) ? 3 : clip_t;
clip_head_gap = 0.2;
lug_head_z_min = loadcell_top_z + clip_t + clip_head_gap;
lug_head_h = 3.5;
lug_top_z = lug_head_z_min + lug_head_h;

// Snap-on eye clips hold each load-cell end down on its tongue, under the
// lug head, so the grip hangs from the load cell. A clip drops into the
// U-slot beside its lug and slides inboard until its fork snaps round the
// neck. The clips carry the grip's tilt moment, not the measured pull.
clip_seat_r = lug_neck_r + 0.15;
clip_snap = is_undef(clip_snap) ? 0.3 : clip_snap;
clip_mouth_w = 2 * (lug_neck_r - clip_snap);
clip_tip_x = 4;
clip_tail_x = is_undef(clip_tail_x) ? 12 : clip_tail_x;
clip_fin_t = 3;
clip_fin_w_y = 16;
clip_fin_top_z = is_undef(clip_fin_top_z) ? 20 : clip_fin_top_z;
// Slide from the fitting position, fork tip clear of the lug head, to the
// seat.
clip_install_travel = lug_r + 0.5 + clip_tip_x;
// Finger room beside a grip-side clip's fin while it is fitted.
clip_access_x = is_undef(clip_access_x) ? 6 : clip_access_x;

// Four-finger hangboard pocket, loaded on its +X lip. Its mid-depth sits
// near the load-cell plane so the finger pull adds little tilt. The pocket
// is widened by an edge liner's band, so the fingers keep
// hangboard_finger_room_x beside it.
grip_x_min = dyno_eye_x_right - tongue_r;
// The grip's upper body starts beyond the case, leaving room to fit a clip.
grip_body_x_min = dyno_eye_x_right + clip_tail_x + clip_install_travel + clip_access_x;
// Under the case, a keel narrower than the body carries the tongue to it.
grip_keel_half_w_y = is_undef(grip_keel_half_w_y) ? 15 : grip_keel_half_w_y;
grip_spine_t = is_undef(grip_spine_t) ? 8 : grip_spine_t;
hangboard_finger_room_x = is_undef(hangboard_finger_room_x) ? 18.5 : hangboard_finger_room_x;
hangboard_opening_w_y = is_undef(hangboard_opening_w_y) ? 80 : hangboard_opening_w_y;

// Edge liner: a band against the +X lip with its face stepped under each
// finger, an unlevel edge for the right hand, index at -Y; turned end over
// end, for the left. Stored, it leaves the lip level. It is cut into pieces
// that stack on the fitted stoppers up to the grip top (see liner_piece_h).
// Steps toward the palm (+X) from the middle finger's edge, for the index,
// middle, ring and little fingers.
liner_finger_steps = is_undef(liner_finger_steps) ? [3, 0, 2, 7] : liner_finger_steps;
liner_t_min = is_undef(liner_t_min) ? 3 : liner_t_min;
liner_clearance = 0.25;
liner_t_max = liner_t_min + max(liner_finger_steps);
function liner_t(i) = liner_t_max - liner_finger_steps[i];
liner_band_x = liner_t_max + liner_clearance;
liner_finger_w_y = hangboard_opening_w_y / len(liner_finger_steps);
function liner_finger_y(i) = (i - (len(liner_finger_steps) - 1) / 2) * liner_finger_w_y;
liner_step_r = 2.5;
hangboard_opening_w_x = hangboard_finger_room_x + liner_band_x;
hangboard_side_wall_t = 4;
hangboard_right_lip_t = is_undef(hangboard_right_lip_t) ? 14.5 : hangboard_right_lip_t;
hangboard_opening_x_min = grip_body_x_min + grip_spine_t;
hangboard_opening_x_max = hangboard_opening_x_min + hangboard_opening_w_x;
grip_x_max = hangboard_opening_x_max + hangboard_right_lip_t;
grip_half_w_y = hangboard_opening_w_y / 2 + hangboard_side_wall_t;
hangboard_opening_y_min = -hangboard_opening_w_y / 2;
hangboard_opening_y_max = hangboard_opening_w_y / 2;
hangboard_front_z = is_undef(hangboard_front_z) ? loadcell_center_z + 9 : hangboard_front_z;
hangboard_pocket_depth_z = is_undef(hangboard_pocket_depth_z) ? 25 : hangboard_pocket_depth_z;
hangboard_pocket_back_z = hangboard_front_z - hangboard_pocket_depth_z;
hangboard_back_wall_t = is_undef(hangboard_back_wall_t) ? 6 : hangboard_back_wall_t;
grip_z_min = hangboard_pocket_back_z - hangboard_back_wall_t;
hangboard_opening_r = 4;
// End walls only; the long walls stay upright for the liner.
hangboard_draft = 1;
liner_y_min = hangboard_opening_y_min + hangboard_draft + liner_clearance;
liner_y_max = hangboard_opening_y_max - hangboard_draft - liner_clearance;
hangboard_lip_radius = is_undef(hangboard_lip_radius) ? 2 : hangboard_lip_radius;
hangboard_lip_min_t = hangboard_right_lip_t - hangboard_lip_radius;

// Base. The grip hangs in a trench, and ledges under its side walls catch
// tilt with a small Z gap while leaving X free.
base_z_min = is_undef(base_z_min) ? deck_z - 22.6 : base_z_min;
base_half_w_y = is_undef(base_half_w_y) ? 61 : base_half_w_y;
base_corner_r = 6;
grip_guide_gap_z = is_undef(grip_guide_gap_z) ? 1.0 : grip_guide_gap_z;
grip_guide_bearing_y = is_undef(grip_guide_bearing_y) ? 4 : grip_guide_bearing_y;
grip_side_gap_y = 3;
trench_x_min = grip_x_min - 1;
// Free travel for the grip in the pull direction (+X).
grip_pull_gap_x = is_undef(grip_pull_gap_x) ? 8 : grip_pull_gap_x;
trench_x_max = grip_x_max + grip_pull_gap_x;
trench_half_w_y = grip_half_w_y + grip_side_gap_y;
trench_floor_z = grip_z_min - 1.5;
grip_guide_z_max = grip_z_min - grip_guide_gap_z;
grip_guide_inner_y = grip_half_w_y - grip_guide_bearing_y;
rated_preview_deflection = 0.4;

// Anchor block, dropped into a pocket in the base. Under load it bears on
// the pocket's +X wall, below the floating case.
anchor_play_x = is_undef(anchor_play_x) ? 0.2 : anchor_play_x;
anchor_fit = 0.3;
// The block and its tongue end just past the case.
anchor_outboard_x = is_undef(anchor_outboard_x) ? 3 : anchor_outboard_x;
anchor_x_min = -(case_x_half + 1 + anchor_outboard_x);
anchor_x_max = -grip_x_min;
anchor_half_w_y = is_undef(anchor_half_w_y) ? 15 : anchor_half_w_y;
anchor_z_min = is_undef(anchor_z_min) ? deck_z - 16.5 : anchor_z_min;
anchor_pocket_x_min = anchor_x_min - anchor_fit;
anchor_pocket_x_max = anchor_x_max + anchor_play_x;
anchor_pocket_half_w_y = anchor_half_w_y + anchor_fit;

// Two drop-in pocket stoppers raise the floor for shallower edges: each on
// its own, or both stacked. They span the pocket, so the unlevel liner
// stacks on them. The pocket walls locate them; a pull tab on one end face
// of each runs in a slot in the pocket end wall and stands proud of the grip
// top.
stopper_t_list = is_undef(stopper_t_list) ? [5, 10] : stopper_t_list;
stopper_clearance = is_undef(stopper_clearance) ? 0.25 : stopper_clearance;
stopper_count = len(stopper_t_list);
stopper_x_min = hangboard_opening_x_min + stopper_clearance;
stopper_x_max = hangboard_opening_x_max - stopper_clearance;
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

// Liner pieces: a spacer as thick as each stopper, and a cap with rounded
// long edges that always goes on top. Each fitted stopper replaces its
// spacer, so the stack always reaches the grip top.
liner_cap_h = hangboard_pocket_depth_z - stopper_stack_h;
liner_piece_count = stopper_count + 1;
function liner_piece_h(i) = i < stopper_count ? stopper_t_list[i] : liner_cap_h;
// Pieces in the pocket over the listed stoppers, bottom first, and their
// bottom heights above the pocket floor.
function liner_pieces_over(stoppers) = concat(
    [for (i = [0 : stopper_count - 1]) if (len(search(i, stoppers)) == 0) i],
    [stopper_count]);
function liner_piece_z(pieces, k) = k == 0 ? 0
    : liner_piece_h(pieces[k - 1]) + liner_piece_z(pieces, k - 1);
function stoppers_h(stoppers) = sum_list([for (i = stoppers) stopper_t_list[i]]);

// Printed springs flex within their layers; this caps their peak strain,
// well below PETG's yield strain.
allowable_flex_strain = is_undef(allowable_flex_strain) ? 0.015 : allowable_flex_strain;

// Storage well for the stacked stoppers in the deck beyond the anchor pocket,
// long side along Y as in the pocket. Their pull tabs stand proud of the
// deck at its middle. A leaf in the well's +X wall spans along Y and bridges
// a gap below, so it flexes in X; a ridge on it clicks over the top stopper
// of the stack. The ridge reaches across both side clearances to overlap the
// stack by stopper_snap_engage wherever it sits. A stopper stored on its own
// sits below the ridge and is not held.
stopper_well_clearance = 0.25;
stopper_snap_engage = is_undef(stopper_snap_engage) ? 0.5 : stopper_snap_engage;
stopper_snap_ridge = 2 * stopper_well_clearance + stopper_snap_engage;
stopper_snap_gap_z = 0.2;
stopper_snap_len_y = 10;
stopper_leaf_len_y = is_undef(stopper_leaf_len_y) ? 50 : stopper_leaf_len_y;
stopper_leaf_t_x = 1.6;
stopper_leaf_h_z = 4;
stopper_leaf_gap_z = 1;
// The wall behind the relief stops the leaf just past the ridge's travel.
stopper_leaf_relief_x = stopper_snap_ridge + 0.2;
stopper_leaf_strain = 12 * stopper_leaf_relief_x * stopper_leaf_t_x
    / pow(stopper_leaf_len_y, 2);
// The leaf and its relief, then a 3 mm wall to the anchor pocket.
stopper_well_x_max = anchor_pocket_x_min - 3 - stopper_leaf_relief_x - stopper_leaf_t_x;
stopper_well_x_min = stopper_well_x_max
    - (stopper_x_max - stopper_x_min + 2 * stopper_well_clearance);
stopper_well_center_x = (stopper_well_x_min + stopper_well_x_max) / 2;
// The 45-degree ridge sits just above the stack and below the deck.
stopper_well_depth_z = stopper_stack_h + stopper_snap_gap_z + 2 * stopper_snap_ridge + 0.3;
stopper_well_z_min = deck_z - stopper_well_depth_z;
stopper_snap_z = stopper_well_z_min + stopper_stack_h + stopper_snap_gap_z;

// Storage well for the stacked liner pieces in the -Y side of the deck,
// turned so their length runs along X. The full stack stands
// liner_well_proud_z above the deck. A finger notch at each end, down to the
// well floor and open through the base's side face, lets the fingers pinch
// any piece or partial stack by its end faces. A snap ridge cannot hold
// every partial stack, so the well's +Y wall is a leaf spanning along X over
// a bridged gap; a pad on it, over the full well depth, clamps every stored
// piece's flat back against the outer wall, which takes its thickest step.
liner_well_clearance = 0.5;
liner_well_notch_x = 14;
liner_well_notch_y_max = -45.5;
liner_well_x_max = trench_x_min - 3 - liner_well_notch_x;
liner_well_x_min = liner_well_x_max - (liner_y_max - liner_y_min + 2 * liner_well_clearance);
liner_well_center_x = (liner_well_x_min + liner_well_x_max) / 2;
liner_well_y_min = -base_half_w_y + 3;
liner_well_y_max = liner_well_y_min + liner_t_max + 2 * liner_well_clearance;
liner_well_proud_z = 6;
liner_well_z_min = deck_z - (hangboard_pocket_depth_z - liner_well_proud_z);
liner_clamp_interference = is_undef(liner_clamp_interference) ? 0.3 : liner_clamp_interference;
liner_clamp_pad_y = 2 * liner_well_clearance + liner_clamp_interference;
liner_clamp_pad_len_x = 40;
liner_clamp_len_x = is_undef(liner_clamp_len_x) ? 50 : liner_clamp_len_x;
liner_clamp_t_y = 1.6;
liner_clamp_gap_z = 1;
// The wall behind the relief stops the leaf just past the clamp's travel.
liner_clamp_relief_y = liner_clamp_interference + 0.3;
liner_clamp_strain = 12 * liner_clamp_relief_y * liner_clamp_t_y / pow(liner_clamp_len_x, 2);
// The thickest step, which bears on the outer wall.
liner_thick_finger = search(0, liner_finger_steps)[0];

// Tilted phone slot in a stand across the -X end of the base, outside the
// load path. The raised slot floor keeps the case from hiding the screen
// except from low viewpoints; the slot leans toward -X so the screen faces
// the user.
phone_slot_w = is_undef(phone_slot_w) ? 14 : phone_slot_w;
phone_slot_depth_z = is_undef(phone_slot_depth_z) ? 16 : phone_slot_depth_z;
phone_slot_tilt = is_undef(phone_slot_tilt) ? 15 : phone_slot_tilt;
phone_slot_inner_wall_x = 4;
phone_slot_outer_wall_x = 5;
phone_slot_z_min = is_undef(phone_slot_z_min) ? 12 : phone_slot_z_min;
phone_stand_top_z = phone_slot_z_min + phone_slot_depth_z;
phone_stand_half_w_y = is_undef(phone_stand_half_w_y) ? 42 : phone_stand_half_w_y;
// The stand is two slotted cheeks; the phone spans the gap between them,
// which leaves room for a charging cable in portrait.
phone_stand_gap_half_y = is_undef(phone_stand_gap_half_y) ? 22 : phone_stand_gap_half_y;
phone_stand_cheek_w_y = phone_stand_half_w_y - phone_stand_gap_half_y;
// Narrowest phone, in its case, that must still rest on both cheeks.
phone_min_w = 64;
phone_min_rest_y = 8;
// Wall between the stopper well and the stand.
phone_stand_clear_x = is_undef(phone_stand_clear_x) ? 2 : phone_stand_clear_x;
phone_stand_x_max = stopper_well_x_min - phone_stand_clear_x;
// The slot's +X face meets the stand top here and leans toward -X.
phone_slot_x_top = phone_stand_x_max
    - phone_slot_inner_wall_x - phone_slot_depth_z * tan(phone_slot_tilt);
phone_slot_top_w_x = phone_slot_w / cos(phone_slot_tilt);
// Lowest viewing elevation, over the case's -X top edge, from which the
// front edge of the slot floor is still visible.
phone_view_max_elevation = is_undef(phone_view_max_elevation) ? 20 : phone_view_max_elevation;
phone_view_elevation = atan(max(0, case_z_max - phone_slot_z_min)
    / (-case_x_half - (phone_stand_x_max - phone_slot_inner_wall_x)));
// Largest phone, in its case, checked in the slot in either orientation.
phone_probe_t = 13;
phone_probe_l = 165;
phone_probe_w = 80;

// Palm rest. Its upright palm face sits hand_opening from the outside of the
// finger lip; seven positions give 25-85 mm in 10 mm steps. The heel rests
// behind the bolster on a plate level with the fingertips on the 20 and 25 mm
// edges, so the heel and the fingers pull in line. The plate slides in a
// dovetail channel sunk into the rear base half, and a printed key pushed in
// from the base's side locks it under the deck, clear of the hand.
hand_opening = is_undef(hand_opening) ? 55 : hand_opening;
rest_adjust_range = is_undef(rest_adjust_range) ? 30 : rest_adjust_range;
rest_index_pitch = is_undef(rest_index_pitch) ? 10 : rest_index_pitch;
rest_index_count = round(2 * rest_adjust_range / rest_index_pitch) + 1;
hand_opening_min = hand_opening - rest_adjust_range;
hand_opening_max = hand_opening + rest_adjust_range;
function rest_face_x(offset = 0) = grip_x_max + hand_opening + offset;
function rest_offset(i) = -rest_adjust_range + i * rest_index_pitch;
rest_depth_x = is_undef(rest_depth_x) ? 60 : rest_depth_x;
rest_half_w_y = is_undef(rest_half_w_y) ? 44 : rest_half_w_y;
// Heel deck: the plate top, and the rear base half's deck beside it.
rest_heel_z = is_undef(rest_heel_z) ? -10 : rest_heel_z;
rest_plate_t = is_undef(rest_plate_t) ? 6 : rest_plate_t;
rest_z_min = rest_heel_z - rest_plate_t;
// The plate's sides flare toward its sole under the channel's lips.
rest_flare_y = 4;
rest_fit = 0.3;
rest_flare_angle = atan(rest_flare_y / rest_plate_t);
// Horizontal side gap that leaves rest_fit normal to the flanks.
rest_side_gap_y = rest_fit / cos(rest_flare_angle);
rest_channel_half_w_y = rest_half_w_y + rest_side_gap_y + rest_flare_y;
// The channel and the lowered deck start just before the rest's front at its
// smallest opening.
rest_channel_x_min = rest_face_x(-rest_adjust_range) - 1;
// Lift before the plate's flanks catch the channel's lips.
rest_catch_travel = rest_fit / sin(rest_flare_angle);
// Large rounds on the bolster's long edges and ends, where the palm pushes
// and drapes onto the heel deck.
rest_bolster_depth_x = is_undef(rest_bolster_depth_x) ? 26 : rest_bolster_depth_x;
rest_bolster_rise = is_undef(rest_bolster_rise) ? 12 : rest_bolster_rise;
rest_corner_r = 10;
rest_bolster_front_r = 9;
rest_bolster_rear_r = 8;
rest_bolster_z_max = rest_heel_z + rest_bolster_rise;
// As wide as an adult palm: wings past the heel plate lie on the deck beside
// the channel. Their undersides print on support.
rest_bolster_half_w_y = is_undef(rest_bolster_half_w_y) ? 54 : rest_bolster_half_w_y;

// Printed index key: a square bar pushed in from the +Y side across the full
// width of the base, half in a groove across the channel floor and half in a
// groove across the plate's sole, under the bolster. The bar prints on its
// side so the shear plane lies across the layers. Its chamfered tip finds the
// far wall's groove, and a head outside the base pulls it out.
key_t_x = is_undef(key_t_x) ? 6 : key_t_x;
key_floor_depth = is_undef(key_floor_depth) ? 3.5 : key_floor_depth;
key_plate_engage_z = is_undef(key_plate_engage_z) ? 2.5 : key_plate_engage_z;
key_h_z = key_floor_depth + key_plate_engage_z;
key_fit = 0.3;
key_offset_x = rest_bolster_depth_x / 2;
function key_x(offset = 0) = rest_face_x(offset) + key_offset_x;
key_z_min = rest_z_min - key_floor_depth;
key_z_max = key_z_min + key_h_z;
// The tip ends flush with the far (-Y) side of the base.
key_y_min = -base_half_w_y;
key_tip_chamfer = 1;
key_head_gap_y = 0.2;
key_bar_y_max = base_half_w_y + key_head_gap_y;
key_head_x = 16;
key_head_y = 8;
key_head_h = 12;
key_head_z_min = (key_z_min + key_z_max - key_head_h) / 2;
// Length of the bar in the plate, across the plate's sole.
key_engage_y = 2 * (rest_half_w_y + rest_flare_y);
// A slot behind the tip leaves a spring prong along the bar's underside,
// below the channel floor, so the bar's shear section there stays whole. The
// barb under it clicks into a recess in the far side wall's tunnel floor;
// pulling the head rides it out on its 45-degree ramp. The prong flexes in
// Z, within the key's layers. Turned over to fit from the -Y side, the barb
// points up, so the +Y wall's recesses are in the tunnel roof and the barb
// never clicks in the near wall.
key_snap_len_y = 18;
key_snap_prong_t = 2.2;
key_snap_gap_z = 1.2;
key_snap_barb = is_undef(key_snap_barb) ? 0.8 : key_snap_barb;
key_snap_barb_y = key_y_min + 4;
key_snap_clearance = 0.2;
key_snap_strain = 1.5 * key_snap_prong_t * key_snap_barb
    / pow(key_y_min + key_snap_len_y - key_snap_barb_y, 2);
// Length of the prong under the plate's sole, where the slot leaves the
// bar's lower half to the prong alone.
key_snap_under_plate_y = max(0, key_y_min + key_snap_len_y + rest_half_w_y + rest_flare_y);
// Each position's hand opening, engraved on both side faces under its key
// hole and below the key head, so the fitted key shows its setting.
function rest_opening(i) = hand_opening + rest_offset(i);
opening_label_size = 4;
opening_label_z = (base_z_min + key_head_z_min) / 2;

// Two-piece base for a 256 mm bed (Bambu Lab A1), split beside the grip.
// Two vertical dovetail tongues on the front half drop into sockets under
// the rear half's trench floor. The pull crosses the joint as compression
// along the finger line, above the deck, so the trench side walls rise into
// cheeks across the joint; with the line inside their butt faces, the joint
// stays shut without tension and the halves cannot rock up off the table.
// The cheeks stand beside the grip's upper body, no higher than its top,
// clear of the hand.
base_split_x = is_undef(base_split_x) ? (grip_body_x_min + grip_x_max) / 2 : base_split_x;
joint_cheek_x_min = grip_body_x_min;
joint_cheek_x_max = grip_x_max;
joint_cheek_top_z = is_undef(joint_cheek_top_z) ? hangboard_front_z : joint_cheek_top_z;
joint_cheek_r = 3;
joint_cheek_w_y = base_half_w_y - trench_half_w_y;
// Finger-pull line, at the mid-depth of the shallowest edge.
joint_pull_z = loadcell_center_z + max(edge_pull_offsets);
base_split_bed_max = is_undef(base_split_bed_max) ? 240 : base_split_bed_max;
print_bed_size = is_undef(print_bed_size) ? 256 : print_bed_size;
base_x_min = phone_slot_x_top - phone_slot_top_w_x - phone_slot_outer_wall_x;
// The base carries the whole heel plate at the largest opening.
base_x_max = rest_face_x(rest_adjust_range) + rest_depth_x;
joint_tongue_y = 30;
joint_tongue_len_x = 12;
joint_tongue_neck_w = 12;
joint_tongue_head_w = 18;
joint_fit = 0.2;
joint_roof_t = 3;
// The sockets lie under the rear half's trench floor.
joint_tongue_z_max = trench_floor_z - joint_roof_t - joint_fit;
// Separation before the sockets catch the tongue flanks.
joint_catch_travel = joint_fit
    / sin(atan((joint_tongue_head_w - joint_tongue_neck_w) / 2 / joint_tongue_len_x));
base_front_len = base_split_x + joint_tongue_len_x - base_x_min;
base_rear_len = base_x_max - base_split_x;

// Service access to the switch and USB through the open +Y side.
service_w = 30;
service_y_max = base_half_w_y + 20;

// Brand engraved into both side faces of the front base half, beside the
// grip trench, in the crimpdeq-case font.
brand_font = "Inter:style=Bold";
brand_depth = 0.8;
side_brand_text = "crimpdeq.com";
side_brand_size = 5.5;
side_brand_x = (liner_well_x_max + liner_well_notch_x + base_split_x) / 2;
side_brand_z = (base_z_min + deck_z) / 2;
// The name on the finger lip's outer face, above the deck, facing the palm
// rest.
grip_brand_text = "Crimpdeq";
grip_brand_size = 8;
grip_brand_z = (deck_z + hangboard_front_z) / 2;
// Conservative Inter Bold extents per unit of text size: advance per
// character, and ascender to descender.
brand_char_w = 0.85;
brand_line_h = 1.4;
function brand_len(text, size) = len(text) * size * brand_char_w;

// --- Structural screens at the design target -------------------------------
// Nominal screens, not a strength qualification. Printed-material limits are
// assumptions that need coupon tests in the actual print orientation:
// bending within the layers, and tension across them.
allowable_printed_bending_mpa = is_undef(allowable_printed_bending_mpa) ? 30 : allowable_printed_bending_mpa;
allowable_printed_tension_mpa = is_undef(allowable_printed_tension_mpa) ? 12 : allowable_printed_tension_mpa;
allowable_printed_bearing_mpa = is_undef(allowable_printed_bearing_mpa) ? 12 : allowable_printed_bearing_mpa;
// Conformal contact of the metal eye on a solid printed lug, about 40 % of
// PETG's compressive yield. The governing assumption of the all-printed
// load path.
allowable_lug_bearing_mpa = is_undef(allowable_lug_bearing_mpa) ? 20 : allowable_lug_bearing_mpa;

// Anchor block and grip print upright, so the lug root and the tongue root
// are loaded across the layers. The eye bears across the full lug diameter
// and tab thickness; its resultant acts at the load-cell mid-plane.
lug_bearing_mpa = design_force_n / (2 * lug_r * lc_T);
lug_bending_mpa = design_force_n * (loadcell_center_z - loadcell_bottom_z)
    / (PI * pow(2 * lug_r, 3) / 32);
lug_shear_mpa = design_force_n / (PI * lug_r * lug_r);
// Tongue root at the deck, taken as the tongue's width by its length
// inside the case.
tongue_root_len_x = case_x_half - (dyno_eye_x_right - tongue_r);
tongue_bending_mpa = design_force_n * (loadcell_center_z - deck_z)
    / (2 * tongue_r * pow(tongue_root_len_x, 2) / 6);

// The largest finger-pull offset tilts the grip. The clip reacts it against
// the tongue seat, taken conservatively at tongue_r from the eye, bearing on
// the outboard half of the flat ring under the lug head; the head then pulls
// on the neck across the layers.
clip_tilt_moment_nmm = design_force_n * max([for (o = edge_pull_offsets) abs(o)]);
clip_tilt_force_n = clip_tilt_moment_nmm / tongue_r;
clip_ring_area_mm2 = PI * (pow(lug_neck_r + lug_head_flat_w, 2) - pow(clip_seat_r, 2)) / 2;
clip_ring_bearing_mpa = clip_tilt_force_n / clip_ring_area_mm2;
lug_neck_tension_mpa = clip_tilt_force_n / (PI * lug_neck_r * lug_neck_r);

// Anchor block bearing on the pocket's +X wall below the case.
anchor_bearing_mpa = design_force_n / (2 * anchor_half_w_y * (deck_z - anchor_z_min));

// Full force at the pocket rim, over its usable width. The grip prints
// upright, so the lip's root bends across the layers.
lip_section_modulus_mm3 = hangboard_opening_w_y * pow(hangboard_lip_min_t, 2) / 6;
lip_design_bending_mpa = design_force_n * hangboard_pocket_depth_z / lip_section_modulus_mm3;
// The lip through the grip brand, under the moment at the text's foot.
lip_brand_bending_mpa = design_force_n
    * (hangboard_front_z - (grip_brand_z - grip_brand_size * brand_line_h / 2))
    / (hangboard_opening_w_y * pow(hangboard_right_lip_t - brand_depth, 2) / 6);
// Pocket side walls and back wall carry the lip force back to the lug.
grip_net_area_mm2 = 2 * hangboard_side_wall_t * (hangboard_front_z - grip_z_min)
    + 2 * grip_half_w_y * hangboard_back_wall_t;
grip_net_tension_mpa = design_force_n / grip_net_area_mm2;
// The keel and the tongue on it carry the pull below the finger line, in
// tension and bending along X, within the layers.
grip_keel_h = deck_z - grip_z_min;
grip_keel_area_mm2 = 2 * grip_keel_half_w_y * grip_keel_h;
grip_keel_tongue_h = loadcell_bottom_z - deck_z;
grip_keel_tongue_area_mm2 = 2 * tongue_r * grip_keel_tongue_h;
grip_keel_section_area_mm2 = grip_keel_area_mm2 + grip_keel_tongue_area_mm2;
grip_keel_section_z = (grip_keel_area_mm2 * (grip_z_min + grip_keel_h / 2)
    + grip_keel_tongue_area_mm2 * (deck_z + grip_keel_tongue_h / 2)) / grip_keel_section_area_mm2;
grip_keel_section_i_mm4 =
    grip_keel_area_mm2 * (pow(grip_keel_h, 2) / 12
        + pow(grip_z_min + grip_keel_h / 2 - grip_keel_section_z, 2))
    + grip_keel_tongue_area_mm2 * (pow(grip_keel_tongue_h, 2) / 12
        + pow(deck_z + grip_keel_tongue_h / 2 - grip_keel_section_z, 2));
grip_keel_mpa = design_force_n / grip_keel_section_area_mm2
    + design_force_n * (joint_pull_z - grip_keel_section_z)
        * max(loadcell_bottom_z - grip_keel_section_z, grip_keel_section_z - grip_z_min)
        / grip_keel_section_i_mm4;

// The key takes the whole palm force over its length in the plate:
// shear at the channel floor, bearing on the plate's and the floor's grooves,
// and shear through the rib between neighbouring floor grooves.
key_shear_mpa = design_force_n / (key_t_x * key_engage_y);
key_plate_bearing_mpa = design_force_n / (key_plate_engage_z * key_engage_y);
key_slot_bearing_mpa = design_force_n
    / (key_floor_depth * (key_engage_y - key_snap_under_plate_y));
key_ligament_x = rest_index_pitch - key_t_x - key_fit;
key_ligament_shear_mpa = design_force_n / (key_ligament_x * key_engage_y);
// Palm bolster root, with the force at mid-rise; stress across the layers.
rest_bolster_bending_mpa = design_force_n * rest_bolster_rise / 2
    / (2 * rest_half_w_y * pow(rest_bolster_depth_x, 2) / 6);
// Tipping the rest about its front edge lifts its tail; the channel's two
// overhanging lips hold it over the shortest engaged length.
rest_min_engaged_x = base_x_max - rest_face_x(rest_adjust_range);
rest_uplift_n = design_force_n * (rest_bolster_z_max - rest_z_min) / rest_depth_x;
rest_flank_shear_mpa = rest_uplift_n / (2 * rest_min_engaged_x * rest_plate_t / 2);
// Each joint cheek takes half the pull at the finger line and passes it to
// the base through its root at the deck, across the layers; the shorter
// half's root governs.
joint_cheek_root_len_x = min(base_split_x - joint_cheek_x_min, joint_cheek_x_max - base_split_x);
joint_cheek_bending_mpa = design_force_n / 2 * (joint_pull_z - deck_z)
    / (joint_cheek_w_y * pow(joint_cheek_root_len_x, 2) / 6);

assert(platform_rated_kg >= 45 && platform_rated_force_n <= loadcell_rated_force_n,
    "The platform must be rated for at least 45 kg and no more than the 1500 N load cell.");
assert(structural_safety_factor >= 2, "Use a structural design factor of at least 2.0.");
assert(u_slot_clear >= 1 && tongue_r > lug_r + 1,
    "Tongues must keep 1 mm from the case's U-slots and a seat ring round each lug.");
assert(eye_bore_d < eye_d, "The eye ring's bore must be smaller than the eye.");
assert(lug_fit >= 0.15 && lug_fit <= 0.4, "Lugs need a 0.15-0.4 mm radial fit in the eye.");
assert(lug_bearing_mpa <= allowable_lug_bearing_mpa,
    "Eye bearing on the printed lug exceeds the configured limit.");
assert(lug_bending_mpa <= allowable_printed_tension_mpa &&
    lug_shear_mpa <= allowable_printed_tension_mpa / 2 &&
    tongue_bending_mpa <= allowable_printed_tension_mpa,
    "Printed lug or tongue root exceeds configured cross-layer stress.");
assert(lug_upper_flat_x < dyno_eye_x_right - lug_neck_r + 1 &&
    lug_upper_flat_x <= dyno_eye_x_right - clip_tip_x &&
    case_battery_wall_z_min > loadcell_top_z,
    "The lid battery walls leave too little room for the lug neck or the clip.");
assert(lug_neck_r >= 5 && lug_neck_r <= lug_r - 1.5 && lug_head_chamfer >= 0 &&
    clip_seat_r > lug_neck_r && clip_seat_r + 2.5 <= tongue_r,
    "The lug neck must leave a head over the clip and a clip ring round the neck.");
assert(clip_snap >= 0.2 && clip_snap <= 0.5 && clip_t >= 2.5 &&
    lug_neck_r - clip_tip_x > 0 &&
    sqrt(pow(lug_neck_r, 2) - pow(clip_tip_x, 2)) < clip_mouth_w / 2,
    "Clips need a light snap and fork tips clear of the seated neck.");
assert(clip_ring_bearing_mpa <= allowable_printed_bearing_mpa &&
    lug_neck_tension_mpa <= allowable_printed_tension_mpa,
    "The clip ring or lug neck exceeds configured stress under the grip's tilt.");
assert(clip_access_x >= 5 && clip_tail_x >= clip_tip_x + 6 &&
    dyno_eye_x_right + clip_tail_x <= lc_L / 2,
    "Clips need finger room beside the fin, a tail over the load cell, and must end on it.");
assert(lug_upper_flat_x <= dyno_eye_x_right - lug_neck_r,
    "The flat that clears the lid walls must not cut the lug neck.");
assert(clip_fin_top_z < case_z_max - 4 && clip_fin_top_z > lug_top_z + 4,
    "Clip fins must stand clear of the lug and stay below the case top.");
assert(grip_body_x_min >= case_x_half + 1 + clip_t,
    "The grip body must stay clear of the case end.");
assert(rest_catch_travel <= 0.6 && joint_catch_travel <= 1,
    "Dovetail flanks are too shallow to hold their parts closely.");
assert(case_float_gap >= 1, "The case must float at least 1 mm above the deck.");
assert(hangboard_pocket_depth_z == 25, "The hangboard pocket must remain 25 mm deep.");
assert(hangboard_back_wall_t >= 6, "Hangboard pocket back wall must be at least 6 mm thick.");
assert(hangboard_opening_w_y >= 80, "Four-finger opening must be at least 80 mm wide.");
assert(hangboard_lip_radius > 0 && hangboard_lip_radius <= 2,
    "Loading-edge radius must be in (0, 2] mm.");
assert(hangboard_lip_min_t >= 8,
    "Rounded hangboard loading lip must retain at least 8 mm thickness.");
assert(hangboard_finger_room_x >= 18,
    "Finger pocket must retain at least 18 mm clearance beside the liner.");
assert(liner_t_min >= 2 && min(liner_finger_steps) == 0 && liner_t_max <= 12 &&
    len(liner_finger_steps) == 4,
    "The liner needs four finger steps from the middle finger, a 2 mm floor and at most 12 mm thickness.");
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
assert(liner_cap_h >= 10 && liner_cap_h > 2 * hangboard_lip_radius,
    "The liner cap must carry the shallowest edge and its rounded edges.");
assert(grip_pull_gap_x >= 5 * (lug_fit + anchor_play_x + rated_preview_deflection),
    "The grip needs free travel in the pull direction of at least five times its play and rated deflection.");
assert(grip_guide_gap_z >= 0.8 && grip_guide_gap_z <= 1.2 && grip_guide_bearing_y >= 3 &&
    trench_floor_z > base_z_min + 5,
    "Grip guides need a small Z gap, a real bearing width and a solid trench floor.");
assert(anchor_z_min > base_z_min + 5 && anchor_half_w_y >= tongue_r + 3 &&
    anchor_outboard_x >= 0 && anchor_bearing_mpa <= allowable_printed_bearing_mpa,
    "The anchor block must carry its tongue out of the case, and its pocket needs a solid floor and bearing area.");
assert(lip_design_bending_mpa <= allowable_printed_tension_mpa &&
    grip_net_tension_mpa <= allowable_printed_tension_mpa,
    "Finger lip or grip body exceeds configured nominal stress.");
assert(grip_keel_half_w_y >= tongue_r && grip_keel_half_w_y <= grip_half_w_y &&
    grip_keel_mpa <= allowable_printed_bending_mpa,
    "The grip keel must carry the tongue and stay within its bending stress.");
assert(hand_opening_min == 25 && hand_opening_max == 85 && rest_index_count == 7,
    "Preserve seven 25-85 mm hand openings.");
assert(abs(2 * rest_adjust_range
    - rest_index_pitch * round(2 * rest_adjust_range / rest_index_pitch)) < 0.001,
    "The rest travel must divide evenly into indexed positions.");
assert(rest_face_x(-rest_adjust_range) >= trench_x_max + 15,
    "The palm rest gets too close to the grip trench at its smallest opening.");
assert(rest_heel_z <= hangboard_front_z - 20 && rest_heel_z >= hangboard_front_z - 25 &&
    rest_heel_z < deck_z,
    "The heel deck must lie between the fingertips on the 20 and 25 mm edges.");
assert(rest_plate_t >= 5 && rest_z_min > base_z_min + 8,
    "The heel plate needs 5 mm and the channel a solid floor.");
assert(joint_tongue_z_max - base_z_min >= 4,
    "The joint tongues need 4 mm of height under the trench floor.");
assert(joint_cheek_top_z >= joint_pull_z + 4 && joint_cheek_top_z <= hangboard_front_z,
    "The joint cheeks must rise 4 mm above the finger pull and no higher than the grip.");
assert(base_split_x - joint_tongue_len_x >= joint_cheek_x_min &&
    base_split_x + joint_tongue_len_x <= joint_cheek_x_max,
    "The base joint and its tongues must lie between the cheeks.");
assert(joint_cheek_bending_mpa <= allowable_printed_tension_mpa,
    "Joint cheek roots exceed configured cross-layer stress.");
assert(base_half_w_y - rest_channel_half_w_y >= 6,
    "The rest channel needs a 6 mm side wall in the base.");
assert(key_t_x > 0 && key_floor_depth > 0 && key_plate_engage_z > 0 && key_engage_y > 0,
    "The index key needs a positive size and must engage both the channel floor and the plate.");
assert(key_t_x > 2 * key_tip_chamfer && key_h_z > 2 * key_tip_chamfer,
    "The index key must be wider and taller than its tip chamfers.");
assert(key_offset_x - (key_t_x + key_fit) / 2 >= 3 &&
    key_offset_x + (key_t_x + key_fit) / 2 <= rest_bolster_depth_x - 3,
    "The plate's key groove must lie under the bolster.");
assert(rest_heel_z - (key_z_max + key_fit) >= 2.5 && key_z_min - base_z_min >= 8,
    "The key tunnels need a 2.5 mm roof under the deck and the grooves a solid floor.");
assert(key_head_z_min >= base_z_min + 2 && key_head_z_min + key_head_h <= rest_heel_z,
    "The key heads must stay below the deck and clear of the table.");
assert(base_x_max >= key_x(rest_adjust_range) + key_t_x / 2 + 7,
    "The last key groove needs a solid end wall.");
assert(rest_bolster_rise >= 10 && rest_bolster_rise <= 14 &&
    rest_bolster_depth_x >= 20 && rest_bolster_depth_x < rest_depth_x - 30,
    "The palm bolster must rise 10-14 mm and leave a 30 mm heel deck behind it.");
assert(2 * rest_half_w_y >= hangboard_opening_w_y &&
    rest_bolster_front_r + rest_bolster_rear_r <= rest_bolster_depth_x &&
    rest_bolster_z_max - max(rest_bolster_front_r, rest_bolster_rear_r) >= rest_heel_z &&
    rest_corner_r <= rest_bolster_depth_x / 2,
    "The palm bolster must span the finger pocket and keep its rounds above the deck.");
assert(rest_bolster_half_w_y >= rest_half_w_y + rest_side_gap_y + 3 &&
    rest_bolster_half_w_y <= base_half_w_y,
    "The bolster wings must lie at least 3 mm onto the deck and stay within the base.");
assert(key_ligament_x >= 3 &&
    key_shear_mpa <= allowable_printed_tension_mpa &&
    key_plate_bearing_mpa <= allowable_printed_bearing_mpa &&
    key_slot_bearing_mpa <= allowable_printed_bearing_mpa &&
    key_ligament_shear_mpa <= allowable_printed_tension_mpa,
    "The index key, its grooves or the ribs between them exceed configured stress.");
assert(rest_bolster_bending_mpa <= allowable_printed_tension_mpa,
    "Palm bolster exceeds configured cross-layer stress.");
assert(rest_min_engaged_x >= rest_depth_x &&
    rest_flank_shear_mpa <= allowable_printed_tension_mpa / 2,
    "The base must carry the whole heel plate and the channel lips their strength.");
assert(base_front_len <= base_split_bed_max && base_rear_len <= base_split_bed_max,
    "Each base half must fit the printable length.");
assert(phone_slot_w >= 13 && phone_slot_w <= 16 &&
    phone_slot_depth_z >= 12 && phone_slot_tilt >= 5 && phone_slot_tilt <= 25,
    "Phone slot must fit a phone in its case and lean it back.");
assert(phone_slot_z_min > deck_z + phone_slot_depth_z &&
    phone_view_elevation <= phone_view_max_elevation &&
    phone_stand_clear_x >= 2 && phone_stand_half_w_y >= phone_probe_w / 2 + 2,
    "The phone stand must lift the slot so the case hides the phone only from low viewpoints, keep a wall by the stopper well, and span a phone in portrait.");
assert(phone_stand_cheek_w_y >= 15 && phone_stand_gap_half_y >= 10 &&
    phone_min_w / 2 - phone_stand_gap_half_y >= phone_min_rest_y,
    "Phone stand cheeks must be at least 15 mm wide, leave a cable gap, and carry a narrow phone on both.");
assert(side_brand_x - (liner_well_x_max + liner_well_notch_x)
        >= brand_len(side_brand_text, side_brand_size) / 2 + 3 &&
    base_split_x - side_brand_x >= brand_len(side_brand_text, side_brand_size) / 2 + 3 &&
    side_brand_size * brand_line_h + 6 <= deck_z - base_z_min &&
    base_half_w_y - trench_half_w_y - brand_depth >= 6,
    "The side brand must fit the base side face beside the trench and keep its wall solid.");
assert(brand_len(grip_brand_text, grip_brand_size) + 6 <= hangboard_opening_w_y &&
    grip_brand_z - grip_brand_size * brand_line_h / 2 >= deck_z + 1 &&
    grip_brand_z + grip_brand_size * brand_line_h / 2 <= hangboard_front_z - hangboard_lip_radius &&
    lip_brand_bending_mpa <= allowable_printed_tension_mpa,
    "The grip brand must fit the lip's outer face between the deck and the rim's round, and keep the lip within its stress.");
assert(opening_label_size * brand_line_h <= min(key_head_z_min, key_z_min) - base_z_min &&
    brand_len(str(rest_opening(rest_index_count - 1)), opening_label_size)
        <= rest_index_pitch - 2,
    "The opening labels must fit below the key heads and between their neighbours.");
assert(stopper_well_x_max < -case_x_half - 3 && stopper_well_z_min > base_z_min + 5,
    "The stopper well must stay clear of the case and keep a solid floor.");
assert(stopper_snap_engage >= 0.3 && stopper_leaf_strain <= allowable_flex_strain &&
    stopper_leaf_len_y <= stopper_y_max - stopper_y_min - 2 * stopper_r &&
    stopper_snap_z + 2 * stopper_snap_ridge <= deck_z &&
    stopper_snap_z >= deck_z - stopper_leaf_h_z,
    "The stopper well's leaf must catch the stack and flex within its strain limit along the stoppers' straight side.");
assert(key_snap_barb >= key_fit + 0.4 && key_snap_gap_z >= key_snap_barb + 0.3 &&
    key_snap_strain <= allowable_flex_strain &&
    key_snap_prong_t + key_snap_gap_z < key_floor_depth &&
    rest_heel_z - (key_z_max + key_snap_barb + key_snap_clearance) >= 2,
    "The key's snap prong must flex within its strain limit, keep its slot below the channel floor, and leave a roof over its recess.");
assert(liner_well_y_max < case_y_min - 3 && liner_well_y_max < stopper_tab_slot_y_min - 3 &&
    liner_well_z_min - liner_clamp_gap_z >= base_z_min + 2.5 && liner_well_proud_z >= 5,
    "The liner well must stay clear of the case and the stopper well, keep a floor, and leave the stack proud.");
assert(liner_clamp_interference >= 0.2 && liner_clamp_interference <= 0.5 &&
    liner_clamp_strain <= allowable_flex_strain &&
    liner_clamp_pad_len_x <= liner_clamp_len_x - 6 &&
    liner_clamp_len_x <= liner_well_x_max - liner_well_x_min - 10 &&
    abs(liner_finger_y(liner_thick_finger)) + liner_finger_w_y / 2 <= liner_clamp_pad_len_x / 2 &&
    liner_well_y_max + liner_clamp_t_y + liner_clamp_relief_y
        <= min(stopper_tab_slot_y_min, case_y_min) - 2 &&
    liner_well_proud_z + liner_clamp_pad_y + 2 <= liner_cap_h,
    "The liner well's clamp must press lightly within its strain limit, span the thickest step either way round, keep a wall to the stopper well, and grip the top piece of a full stack.");
assert(liner_well_notch_x >= 12 && liner_well_notch_y_max - (-base_half_w_y) >= 15 &&
    liner_well_notch_y_max > liner_well_y_max &&
    liner_well_notch_y_max <= stopper_tab_slot_y_min - 3 &&
    liner_well_notch_y_max <= -phone_stand_half_w_y - 3,
    "The liner well's finger notches must take a fingertip and stay clear of the stopper well and the phone stand.");
