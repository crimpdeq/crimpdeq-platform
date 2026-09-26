//
// Standalone Crimpdeq hand-dynamometer dimensions.
// Units: mm, N, MPa unless noted.
//

// Crimpdeq v2 enclosure/load-cell interface snapshot.
lc_L = 80;
lc_W = 40;
lc_T = 4;
loadcell_lift = 2.5;
eye_d = 17;
eye_edge_start = 6;
eye_center_offset = eye_edge_start + eye_d / 2;
clear_x = 0.8;
pcb_L = 63.8;
rear_clear = 0.8;
front_clear = 2.0;
usb_cable_boot_w = 12.0;

case_wall_t = 3;
case_floor_t = 3;
case_lid_t = 3;
case_inner_z_min = -lc_T / 2;
case_inner_z_max = 25;
loadcell_bottom_z = case_inner_z_min + loadcell_lift;
loadcell_center_z = loadcell_bottom_z + lc_T / 2;
loadcell_top_z = loadcell_bottom_z + lc_T;

case_inner_x_min = -lc_L / 2 - clear_x;
case_inner_x_max = lc_L / 2 + clear_x;
case_inner_y_min = -pcb_L / 2 - rear_clear;
case_inner_y_max = pcb_L / 2 + front_clear;
case_outer_x_min = case_inner_x_min - case_wall_t;
case_outer_x_max = case_inner_x_max + case_wall_t;
case_outer_y_min = case_inner_y_min - case_wall_t;
case_outer_y_max = case_inner_y_max + case_wall_t;
case_outer_z_min = case_inner_z_min - case_floor_t;
case_outer_z_max = case_inner_z_max + case_lid_t;
case_center_z = (case_outer_z_min + case_outer_z_max) / 2;
case_depth_z = case_outer_z_max - case_outer_z_min;

// Verified sensor rating.
loadcell_rated_kg = is_undef(loadcell_rated_kg) ? 50 : loadcell_rated_kg;
gravity = 9.80665;
loadcell_rated_force_n = loadcell_rated_kg * gravity;
structural_safety_factor = is_undef(structural_safety_factor) ? 2.0 : structural_safety_factor;
design_force_n = loadcell_rated_force_n * structural_safety_factor;

// Load-cell eye datums.
dyno_eye_x_left = -lc_L / 2 + eye_center_offset;
dyno_eye_x_right = lc_L / 2 - eye_center_offset;
dyno_eye_y = 0;
dyno_eye_z = loadcell_center_z;

// M8 retainer, steel load-transfer sleeve, and aluminium flanged eye collars.
pin_nominal_d = is_undef(pin_nominal_d) ? 8 : pin_nominal_d;
bushing_od = is_undef(bushing_od) ? 16.4 : bushing_od;
bushing_id = pin_nominal_d + 0.4;
bushing_core_od = is_undef(bushing_core_od) ? 12.4 : bushing_core_od;
bushing_core_clearance = 0.5;
pin_hole_d = bushing_core_od + bushing_core_clearance;
bushing_collar_id = bushing_core_od + 0.3;
bushing_eye_collar_body_h = lc_T / 2 - 0.1;
bushing_eye_collar_flange_t = 0.5;
bushing_eye_collar_flange_od = eye_d + 0.6;
clevis_plate_t = is_undef(clevis_plate_t) ? 5 : clevis_plate_t;
clevis_case_gap = is_undef(clevis_case_gap) ? 1.0 : clevis_case_gap;
clevis_width_y = is_undef(clevis_width_y) ? 26 : clevis_width_y;
clevis_end_r = clevis_width_y / 2;

frame_depth_z = case_depth_z + 2 * clevis_case_gap + 2 * clevis_plate_t;
frame_z_min = case_outer_z_min - clevis_case_gap - clevis_plate_t;
frame_z_max = case_outer_z_max + clevis_case_gap + clevis_plate_t;
clevis_gap_z = frame_depth_z - 2 * clevis_plate_t;
bushing_length = frame_depth_z;
bushing_center_z = (frame_z_min + frame_z_max) / 2;

// Fixed outer frame. The rails clear the finger grip, which is wider than
// the case, so the grip sets the frame's inner width.
frame_rail_t = is_undef(frame_rail_t) ? 15 : frame_rail_t;
frame_left_post_t = is_undef(frame_left_post_t) ? 22 : frame_left_post_t;
frame_palm_post_t = is_undef(frame_palm_post_t) ? 22 : frame_palm_post_t;
frame_corner_r = 7;
frame_center_y = (case_outer_y_min + case_outer_y_max) / 2;
grip_rail_gap_y = is_undef(grip_rail_gap_y) ? 3 : grip_rail_gap_y;
hangboard_opening_w_y = is_undef(hangboard_opening_w_y) ? 80 : hangboard_opening_w_y;
hangboard_side_wall_t = 4;
hangboard_body_w_y = hangboard_opening_w_y + 2 * hangboard_side_wall_t;

frame_inner_y_min = frame_center_y - hangboard_body_w_y / 2 - grip_rail_gap_y;
frame_inner_y_max = frame_center_y + hangboard_body_w_y / 2 + grip_rail_gap_y;
frame_outer_y_min = frame_inner_y_min - frame_rail_t;
frame_outer_y_max = frame_inner_y_max + frame_rail_t;
frame_case_clear_y = min(case_outer_y_min - frame_inner_y_min,
    frame_inner_y_max - case_outer_y_max);

frame_left_post_inner_x = case_outer_x_min - 4;
frame_left_post_outer_x = frame_left_post_inner_x - frame_left_post_t;

// Four-finger hangboard pocket, independently modelled from the reference.
// The pocket opens toward +Z and loads its right-hand lip along +X.
hangboard_case_clear_x = 4;
hangboard_body_x_min = case_outer_x_max + hangboard_case_clear_x;
hangboard_body_w_x = is_undef(hangboard_body_w_x) ? 36 : hangboard_body_w_x;
hangboard_body_x_max = hangboard_body_x_min + hangboard_body_w_x;
hangboard_body_y_min = frame_inner_y_min + grip_rail_gap_y;
hangboard_body_y_max = frame_inner_y_max - grip_rail_gap_y;
hangboard_body_depth_z = is_undef(hangboard_body_depth_z) ? 31 : hangboard_body_depth_z;
hangboard_front_z = frame_z_max;
hangboard_back_z = hangboard_front_z - hangboard_body_depth_z;
hangboard_pocket_depth_z = is_undef(hangboard_pocket_depth_z) ? 25 : hangboard_pocket_depth_z;
hangboard_pocket_back_z = hangboard_front_z - hangboard_pocket_depth_z;
hangboard_back_wall_t = hangboard_pocket_back_z - hangboard_back_z;
hangboard_left_wall_t = 6;
hangboard_right_lip_t = 10;
hangboard_opening_x_min = hangboard_body_x_min + hangboard_left_wall_t;
hangboard_opening_x_max = hangboard_body_x_max - hangboard_right_lip_t;
hangboard_opening_y_min = hangboard_body_y_min + hangboard_side_wall_t;
hangboard_opening_y_max = hangboard_body_y_max - hangboard_side_wall_t;
hangboard_opening_r = 4;
hangboard_draft = 1;
// Roll only the loaded edge; retain the full left spine and side walls.
hangboard_lip_radius = is_undef(hangboard_lip_radius) ? 2 : hangboard_lip_radius;
hangboard_lip_min_t = hangboard_right_lip_t - hangboard_lip_radius;
finger_grip_center_x = (hangboard_body_x_min + hangboard_body_x_max) / 2;
finger_yoke_spine_y = clevis_width_y;

// The grip hangs from a single eye joint, which lets it tip. Ledges on the
// rail inner faces catch the underside of its side walls with a small Z gap.
// They leave X free, so they carry no measured load while the grip is level.
grip_guide_gap_z = is_undef(grip_guide_gap_z) ? 0.3 : grip_guide_gap_z;
grip_guide_bearing_y = is_undef(grip_guide_bearing_y) ? 4 : grip_guide_bearing_y;
grip_guide_t = 6;
grip_guide_w_y = grip_rail_gap_y + grip_guide_bearing_y;
grip_guide_x_min = hangboard_body_x_min;
grip_guide_x_max = hangboard_body_x_max + 2;
grip_guide_z_max = hangboard_back_z - grip_guide_gap_z;
grip_guide_z_min = grip_guide_z_max - grip_guide_t;

// Drop-in pocket stoppers raise the floor to give shallower edges. The
// closed pocket walls locate them; a cord knotted through each pull hole
// lifts them out. They stack in a storage well in the left end of the frame.
stopper_edge_depths = is_undef(stopper_edge_depths) ? [20, 15, 10] : stopper_edge_depths;
stopper_clearance = is_undef(stopper_clearance) ? 0.25 : stopper_clearance;
stopper_count = len(stopper_edge_depths);
stopper_x_min = hangboard_opening_x_min + hangboard_draft + stopper_clearance;
stopper_x_max = hangboard_opening_x_max - hangboard_draft - stopper_clearance;
stopper_y_min = hangboard_opening_y_min + hangboard_draft + stopper_clearance;
stopper_y_max = hangboard_opening_y_max - hangboard_draft - stopper_clearance;
stopper_r = hangboard_opening_r - hangboard_draft;
stopper_pull_hole_d = 3.5;
stopper_pull_knot_d = 7;
stopper_pull_knot_h = 2;
stopper_pull_inset_y = 4;
stopper_stack_h = hangboard_pocket_depth_z * stopper_count
    - sum_list(stopper_edge_depths);
function sum_list(v, i = 0) = i >= len(v) ? 0 : v[i] + sum_list(v, i + 1);
function stopper_t(edge_depth) = hangboard_pocket_depth_z - edge_depth;
function stopper_min_t(i = 0) = i >= stopper_count ? hangboard_pocket_depth_z
    : min(stopper_t(stopper_edge_depths[i]), stopper_min_t(i + 1));

// Adjustable palm/wrist-heel pad beside the hangboard pocket.
hand_opening = is_undef(hand_opening) ? 65 : hand_opening;
wrist_adjust_range = is_undef(wrist_adjust_range) ? 40 : wrist_adjust_range;
wrist_pad_t_x = is_undef(wrist_pad_t_x) ? 14 : wrist_pad_t_x;
wrist_pad_center_x = hangboard_body_x_max + hand_opening + wrist_pad_t_x / 2;
// The pad clears the grip-guide ledges as it slides onto the right half.
wrist_pad_rail_clear_y = grip_guide_w_y + 1;
wrist_pad_y_min = frame_inner_y_min + wrist_pad_rail_clear_y;
wrist_pad_y_max = frame_inner_y_max - wrist_pad_rail_clear_y;
wrist_pad_corner_r = 5;
wrist_post_clear_x = 3;
frame_palm_post_inner_x =
    wrist_pad_center_x + wrist_adjust_range + wrist_pad_t_x / 2 + wrist_post_clear_x;
frame_palm_post_outer_x = frame_palm_post_inner_x + frame_palm_post_t;
palm_grip_center_x = (frame_palm_post_inner_x + frame_palm_post_outer_x) / 2;

// Four integral corner feet support the fixed frame on a flat bench. Their
// soles sit below the nuts and both wrist-pin tips, even at full travel.
loadcell_washer_t = 1.6;
loadcell_nut_h = 6.5;
support_foot_w_x = 12;
support_foot_w_y = 12;
support_foot_clearance = is_undef(support_foot_clearance) ? 6 : support_foot_clearance;
support_foot_x_left = (frame_left_post_outer_x + frame_left_post_inner_x) / 2;
support_foot_x_right = palm_grip_center_x;
support_foot_y_bottom = frame_outer_y_min + frame_rail_t / 2;
support_foot_y_top = frame_outer_y_max - frame_rail_t / 2;
support_foot_top_z = frame_z_min + 2;

fixed_clevis_x_min = frame_left_post_inner_x - 1.5;
fixed_clevis_x_max = dyno_eye_x_left + clevis_end_r;
moving_clevis_x_min = dyno_eye_x_right - clevis_end_r;
moving_clevis_x_max = hangboard_opening_x_min;

// Discrete holes in the fixed rails positively lock posture/hand-size
// adjustment. Two push-button ball-lock pins make adjustment tool-free.
wrist_mount_x = wrist_pad_center_x;
wrist_mount_y_bottom = (frame_outer_y_min + frame_inner_y_min) / 2;
wrist_mount_y_top = (frame_inner_y_max + frame_outer_y_max) / 2;
wrist_quick_pin_d = is_undef(wrist_quick_pin_d) ? 6 : wrist_quick_pin_d;
wrist_quick_pin_clearance = 0.3;
wrist_mount_hole_d = wrist_quick_pin_d + wrist_quick_pin_clearance;
wrist_index_hole_d = wrist_mount_hole_d;
wrist_index_pitch = 10;
wrist_index_count = round(2 * wrist_adjust_range / wrist_index_pitch) + 1;
wrist_plate_t = 7.2;
wrist_plate_frame_gap = 0.3;
wrist_plate_z_min_1 = frame_z_min - wrist_plate_frame_gap - wrist_plate_t;
wrist_plate_z_max_1 = frame_z_min - wrist_plate_frame_gap;
wrist_plate_z_min_2 = frame_z_max + wrist_plate_frame_gap;
wrist_plate_z_max_2 = frame_z_max + wrist_plate_frame_gap + wrist_plate_t;
wrist_rest_z_min = wrist_plate_z_min_1;
wrist_rest_z_max = wrist_plate_z_max_2;
wrist_quick_pin_grip_l = is_undef(wrist_quick_pin_grip_l) ? 60 : wrist_quick_pin_grip_l;
wrist_quick_pin_tip_l = 4;
wrist_quick_pin_head_d = 18;
wrist_quick_pin_head_h = 8;
wrist_quick_pin_button_d = 8;
wrist_quick_pin_button_h = 2;
wrist_quick_pin_lock_ball_d = 2;
wrist_quick_pin_stack_h = wrist_rest_z_max - wrist_rest_z_min;
wrist_arm_h_y = 10;
// Keep the above-frame arms outside the uninterrupted palm contact area.
wrist_arm_pad_overlap_y = 4;
wrist_arm_w_x = 28;
wrist_arm_x_min = wrist_pad_center_x - wrist_arm_w_x / 2;
wrist_arm_x_max = wrist_pad_center_x + wrist_arm_w_x / 2;
wrist_lanyard_hole_d = 3.5;
wrist_lanyard_x = wrist_pad_center_x;
wrist_lanyard_y_bottom = wrist_pad_y_min - 3;
wrist_lanyard_y_top = wrist_pad_y_max + 3;
wrist_index_remaining_web_y = frame_rail_t - wrist_index_hole_d;
wrist_index_ligament_x = wrist_index_pitch - wrist_index_hole_d;
hand_opening_min = hand_opening - wrist_adjust_range;
hand_opening_max = hand_opening + wrist_adjust_range;

// One continuous L-shaped palm/heel saddle, not a hand resting on the rails.
// Keep the 60 mm pin stack independent of the taller contact surface.
wrist_saddle_depth_x = is_undef(wrist_saddle_depth_x) ? 65 : wrist_saddle_depth_x;
wrist_saddle_t = is_undef(wrist_saddle_t) ? 18 : wrist_saddle_t;
wrist_saddle_x_min = wrist_pad_center_x - wrist_pad_t_x / 2;
wrist_saddle_x_max = wrist_saddle_x_min + wrist_saddle_depth_x;
// The palm/heel deck sits above the +Z finger-pocket mouth, high enough to
// keep the thumb above the pin heads. Its underside clears the frame top, so
// it passes over the right post and joins the upper arms.
wrist_rest_raise = is_undef(wrist_rest_raise) ? 20 : wrist_rest_raise;
wrist_deck_frame_clearance = 2;
wrist_saddle_z_max = hangboard_front_z + wrist_rest_raise;
wrist_saddle_z_min = wrist_saddle_z_max - wrist_saddle_t;
wrist_saddle_core_width_y = wrist_pad_y_max - wrist_pad_y_min - 2 * wrist_pad_corner_r;
wrist_pin_access_d = wrist_quick_pin_head_d + 2;
// The pin-tip model is the lowest point of the adjustable hardware.
wrist_pin_tip_low_z = wrist_rest_z_max - wrist_quick_pin_grip_l
    - wrist_quick_pin_lock_ball_d / 2 - 0.2 - wrist_quick_pin_tip_l;
loadcell_nut_low_z = frame_z_min - loadcell_washer_t - loadcell_nut_h;
support_foot_bottom_z = min(wrist_pin_tip_low_z, loadcell_nut_low_z)
    - support_foot_clearance;

// Low side lips and a full-width palm bolster on the finger-facing (-X) side.
// The full-thickness central heel surface stays solid.
wrist_cradle_edge_w = is_undef(wrist_cradle_edge_w) ? 5 : wrist_cradle_edge_w;
wrist_cradle_rise = is_undef(wrist_cradle_rise) ? 2 : wrist_cradle_rise;
wrist_cradle_embed = 3;
wrist_cradle_edge_radius = is_undef(wrist_cradle_edge_radius) ? 2.4 : wrist_cradle_edge_radius;
wrist_cradle_z_min = wrist_saddle_z_max - wrist_cradle_embed;
wrist_cradle_z_max = wrist_saddle_z_max + wrist_cradle_rise;
wrist_cradle_open_width_y = wrist_pad_y_max - wrist_pad_y_min - 2 * wrist_cradle_edge_w;
// Straight GoGor LITE-style palm bolster: a full-width rounded-rectangle
// section with a nearly flat top. Its -X face continues the palm face and it
// extends only toward +X, so the nine 25-105 mm openings are unchanged.
wrist_palm_bolster_depth_x =
    is_undef(wrist_palm_bolster_depth_x) ? 22 : wrist_palm_bolster_depth_x;
wrist_palm_bolster_rise = is_undef(wrist_palm_bolster_rise) ? 12 : wrist_palm_bolster_rise;
wrist_palm_bolster_front_r =
    is_undef(wrist_palm_bolster_front_r) ? 6 : wrist_palm_bolster_front_r;
wrist_palm_bolster_rear_r =
    is_undef(wrist_palm_bolster_rear_r) ? 5 : wrist_palm_bolster_rear_r;
wrist_palm_bolster_fillet_r =
    is_undef(wrist_palm_bolster_fillet_r) ? 3 : wrist_palm_bolster_fillet_r;
// Root the bolster below the deck/face edge radius so the -X plane has no
// groove at the deck datum.
wrist_palm_bolster_embed =
    is_undef(wrist_palm_bolster_embed) ? 6 : wrist_palm_bolster_embed;
wrist_palm_bolster_x_min = wrist_saddle_x_min;
wrist_palm_bolster_x_max = wrist_palm_bolster_x_min + wrist_palm_bolster_depth_x;
wrist_palm_bolster_z_min = wrist_saddle_z_max - wrist_palm_bolster_embed;
wrist_palm_bolster_z_max = wrist_saddle_z_max + wrist_palm_bolster_rise;
wrist_palm_bolster_flat_top_x =
    wrist_palm_bolster_depth_x - wrist_palm_bolster_front_r - wrist_palm_bolster_rear_r;
// Open heel deck from the bolster's rear face to the rear edge band. The
// bolster intentionally reduces it from 50 mm to 38 mm.
wrist_cradle_open_depth_x =
    wrist_saddle_depth_x - wrist_palm_bolster_depth_x - wrist_cradle_edge_w;
wrist_cradle_open_depth_min_x = 38;
// The upper arms join the palm face and the deck above them, behind the
// palm-face plane. Extend them rearward above the frame to keep that joint
// section; the lower arms keep their original clearance to the right feet.
wrist_upper_arm_joint_x = is_undef(wrist_upper_arm_joint_x) ? 24 : wrist_upper_arm_joint_x;
wrist_upper_arm_x_max = wrist_saddle_x_min + wrist_upper_arm_joint_x;

// Simplified positive-lock checks at the 2.0x frame design load.
wrist_fastener_count = 2;
// Screen either locking station for the entire force, not ideal 50/50 sharing.
wrist_force_per_fastener_n = design_force_n;
wrist_pin_double_shear_area_mm2 =
    2 * PI * wrist_quick_pin_d * wrist_quick_pin_d / 4;
wrist_pin_design_shear_mpa =
    wrist_force_per_fastener_n / wrist_pin_double_shear_area_mm2;
wrist_arm_bearing_area_mm2 = 2 * wrist_plate_t * wrist_quick_pin_d;
wrist_arm_design_bearing_mpa = wrist_force_per_fastener_n / wrist_arm_bearing_area_mm2;
// Screen one upper arm's joint to the saddle for the entire force,
// without relying on the lower arm or the other station to share it.
wrist_upper_arm_joint_shear_mpa = wrist_force_per_fastener_n /
    (wrist_upper_arm_joint_x * wrist_plate_t);
wrist_rail_bearing_area_mm2 = frame_depth_z * wrist_quick_pin_d;
wrist_rail_design_bearing_mpa = wrist_force_per_fastener_n / wrist_rail_bearing_area_mm2;
allowable_quick_pin_shear_mpa =
    is_undef(allowable_quick_pin_shear_mpa) ? 150 : allowable_quick_pin_shear_mpa;
allowable_printed_bearing_mpa =
    is_undef(allowable_printed_bearing_mpa) ? 12 : allowable_printed_bearing_mpa;

// Front (+Y) service tunnel for the case switch and USB cable.
service_tunnel_w = 22;
service_tunnel_z_min = case_outer_z_min + 1;
service_tunnel_z_max = case_outer_z_max - 1;
service_tunnel_y_min = case_outer_y_max - 0.2;
service_tunnel_y_max = frame_outer_y_max + 0.2;

rated_preview_deflection = 0.4;

// Unloaded accessory block outboard of the left anchor post (-X): a well
// for the stacked pocket stoppers next to the post, then a tilted slot that
// holds a phone facing the user. Neither is in the load path.
stopper_well_clearance = 0.5;
stopper_well_x_max = frame_left_post_outer_x;
stopper_well_x_min = stopper_well_x_max
    - (stopper_x_max - stopper_x_min) - 2 * stopper_well_clearance;
stopper_well_y_min = stopper_y_min - stopper_well_clearance;
stopper_well_y_max = stopper_y_max + stopper_well_clearance;
stopper_well_depth_z = stopper_stack_h + 1;
stopper_well_z_min = frame_z_max - stopper_well_depth_z;
phone_slot_w = is_undef(phone_slot_w) ? 14 : phone_slot_w;
phone_slot_depth_z = is_undef(phone_slot_depth_z) ? 16 : phone_slot_depth_z;
phone_slot_tilt = is_undef(phone_slot_tilt) ? 15 : phone_slot_tilt;
phone_slot_inner_wall_x = 4;
phone_slot_outer_wall_x = 5;
phone_slot_z_min = frame_z_max - phone_slot_depth_z;
// The slot's +X face meets the top face here and leans toward -X; its floor
// is flat so it bridges when the half prints upside down.
phone_slot_x_top = stopper_well_x_min - phone_slot_inner_wall_x
    - phone_slot_depth_z * tan(phone_slot_tilt);
phone_slot_top_w_x = phone_slot_w / cos(phone_slot_tilt);
frame_x_min = phone_slot_x_top - phone_slot_top_w_x - phone_slot_outer_wall_x;
frame_accessory_len_x = frame_left_post_outer_x - frame_x_min;
// Largest phone, in its case, checked in the slot in either orientation.
phone_probe_t = 13;
phone_probe_l = 165;
phone_probe_w = 80;

// Two-piece frame for printers with a 256 mm bed (Bambu Lab A1/P1/X1). Each
// rail is spliced by a bolted half-lap: the left half keeps the upper half of
// the rail depth, the right half the lower half. Rail compression bears on the
// lap shoulders; two M5 bolts per rail clamp the lap and carry any shear or
// tension. The joint lets the wrist rest slide onto the right half before the
// frame is closed.
frame_split_x = is_undef(frame_split_x) ? 70 : frame_split_x;
frame_split_bed_max = is_undef(frame_split_bed_max) ? 240 : frame_split_bed_max;
frame_split_lap_len = is_undef(frame_split_lap_len) ? 48 : frame_split_lap_len;
frame_split_x_min = frame_split_x - frame_split_lap_len / 2;
frame_split_x_max = frame_split_x + frame_split_lap_len / 2;
frame_split_lap_z = (frame_z_min + frame_z_max) / 2;
frame_split_upper_t = frame_z_max - frame_split_lap_z;
frame_split_lower_t = frame_split_lap_z - frame_z_min;
frame_split_left_len = frame_split_x_max - frame_x_min;
frame_split_right_len = frame_palm_post_outer_x - frame_split_x_min;
// ISO 4762 M5 socket-head screws from the top face into DIN 985 nyloc nuts
// held in hex pockets in the lower face; both stay recessed. The counterbore
// depth follows from the screw length so the tip ends just inside the lower
// face, where it picks up a nut held at the pocket mouth and draws it in.
frame_split_bolt_d = is_undef(frame_split_bolt_d) ? 5 : frame_split_bolt_d;
frame_split_bolt_l = is_undef(frame_split_bolt_l) ? 35 : frame_split_bolt_l;
frame_split_bolt_pitch = is_undef(frame_split_bolt_pitch) ? 24 : frame_split_bolt_pitch;
frame_split_bolt_hole_d = frame_split_bolt_d + 0.5;
frame_split_bolt_head_d = 1.7 * frame_split_bolt_d;
frame_split_bolt_head_h = frame_split_bolt_d;
frame_split_bolt_cbore_d = frame_split_bolt_head_d + 1;
frame_split_bolt_tip_recess =
    is_undef(frame_split_bolt_tip_recess) ? 1 : frame_split_bolt_tip_recess;
frame_split_nut_af = 1.6 * frame_split_bolt_d;
frame_split_nut_h = frame_split_bolt_d;
frame_split_nut_pocket_af = frame_split_nut_af + 0.4;
// The bolt tip passes the nylon insert by this much.
frame_split_bolt_protrusion = 1.5;
frame_split_bolt_x = [frame_split_x - frame_split_bolt_pitch / 2,
    frame_split_x + frame_split_bolt_pitch / 2];
frame_split_bolt_y = [wrist_mount_y_bottom, wrist_mount_y_top];
frame_split_bolt_count = len(frame_split_bolt_x) * len(frame_split_bolt_y);
frame_split_bolt_tip_z = frame_z_min + frame_split_bolt_tip_recess;
frame_split_bolt_head_z = frame_split_bolt_tip_z + frame_split_bolt_l;
frame_split_bolt_cbore_depth = frame_z_max - frame_split_bolt_head_z;
frame_split_nut_top_z =
    frame_split_bolt_tip_z + frame_split_bolt_protrusion + frame_split_nut_h;
frame_split_nut_pocket_depth = frame_split_nut_top_z - frame_z_min;
// Thread overlap with the nut held at the pocket mouth, before tightening.
frame_split_nut_start_engagement =
    frame_z_min + frame_split_nut_h - frame_split_bolt_tip_z;
frame_split_bolt_end_dist = (frame_split_lap_len - frame_split_bolt_pitch) / 2;
frame_split_bolt_side_wall_y = (frame_rail_t
    - max(frame_split_bolt_cbore_d, frame_split_nut_pocket_af)) / 2;
// Printed bolt bearing length in each half, excluding the head counterbore
// and nut pocket.
frame_split_bolt_bearing_l = min(frame_split_bolt_head_z - frame_split_lap_z,
    frame_split_lap_z - frame_split_nut_top_z);

// Nominal load-path screens, not a strength qualification. Material limits
// require coupon verification in the actual print orientation/environment.
allowable_printed_bending_mpa = is_undef(allowable_printed_bending_mpa) ? 30 : allowable_printed_bending_mpa;
allowable_printed_tension_mpa = is_undef(allowable_printed_tension_mpa) ? 12 : allowable_printed_tension_mpa;
allowable_insert_bending_mpa = is_undef(allowable_insert_bending_mpa) ? 120 : allowable_insert_bending_mpa;
allowable_collar_bearing_mpa = is_undef(allowable_collar_bearing_mpa) ? 90 : allowable_collar_bearing_mpa;

// The left anchor post, not the unloaded right end post, reacts the eye load.
anchor_half_span = (frame_outer_y_max - frame_outer_y_min) / 2;
anchor_section_modulus_mm3 = frame_depth_z * frame_left_post_t * frame_left_post_t / 6;
anchor_design_bending_mpa = design_force_n * anchor_half_span / anchor_section_modulus_mm3;
rail_net_tension_mpa = wrist_force_per_fastener_n / (frame_depth_z * wrist_index_remaining_web_y);
rail_ligament_shear_mpa = wrist_force_per_fastener_n / (2 * frame_depth_z * wrist_index_ligament_x);
service_net_tension_mpa = design_force_n /
    (frame_rail_t * (frame_depth_z - (service_tunnel_z_max - service_tunnel_z_min)));

// Screen one rail's lap joint for the entire frame force, as for the wrist
// stations. Compression bears on a lap shoulder; the bolts (thread root taken
// as 0.8 d) and the thinner tongue are also screened for it as shear and
// tension. The eccentric tongue sees the force offset by a quarter depth.
allowable_frame_bolt_shear_mpa =
    is_undef(allowable_frame_bolt_shear_mpa) ? 150 : allowable_frame_bolt_shear_mpa;
frame_split_bolts_per_rail = len(frame_split_bolt_x);
frame_split_tongue_t = min(frame_split_upper_t, frame_split_lower_t);
frame_split_bolt_design_shear_mpa = design_force_n /
    (frame_split_bolts_per_rail * PI * pow(0.8 * frame_split_bolt_d, 2) / 4);
frame_split_bolt_design_bearing_mpa = design_force_n /
    (frame_split_bolts_per_rail * frame_split_bolt_d * frame_split_bolt_bearing_l);
frame_split_shoulder_bearing_mpa = design_force_n / (frame_rail_t * frame_split_tongue_t);
frame_split_tongue_net_tension_mpa = design_force_n / (frame_split_tongue_t *
    (frame_rail_t - max(frame_split_bolt_cbore_d, frame_split_nut_pocket_af)));
frame_split_tongue_design_bending_mpa = design_force_n * frame_depth_z / 4 /
    (frame_rail_t * pow(frame_split_tongue_t, 2) / 6) + frame_split_shoulder_bearing_mpa;

// Sleeve as a simply supported annular beam between cheek midplanes, with
// the sensor force applied at its actual (off-centre) Z datum. No credit for
// the loose M8 retainer sharing bending.
sleeve_support_low_z = frame_z_min + clevis_plate_t / 2;
sleeve_support_high_z = frame_z_max - clevis_plate_t / 2;
sleeve_span = sleeve_support_high_z - sleeve_support_low_z;
sleeve_a = dyno_eye_z - sleeve_support_low_z;
sleeve_b = sleeve_support_high_z - dyno_eye_z;
// Offset sensor loads the lower cheek more heavily than the upper cheek.
clevis_max_reaction_n = design_force_n * max(sleeve_a, sleeve_b) / sleeve_span;
clevis_design_bearing_mpa = clevis_max_reaction_n / (clevis_plate_t * bushing_core_od);
clevis_net_tension_mpa = clevis_max_reaction_n / (clevis_plate_t * (clevis_width_y - pin_hole_d));
sleeve_section_modulus_mm3 = PI * (pow(bushing_core_od, 4) - pow(bushing_id, 4)) /
    (32 * bushing_core_od);
sleeve_design_bending_mpa = design_force_n * sleeve_a * sleeve_b /
    (sleeve_span * sleeve_section_modulus_mm3);
collar_design_bearing_mpa = design_force_n /
    (2 * bushing_eye_collar_body_h * bushing_core_od);

// Full force at the pocket rim, distributed over its usable width. Local
// one-finger loading, layer adhesion and stress concentrations are not covered.
lip_section_modulus_mm3 = (hangboard_opening_y_max - hangboard_opening_y_min) *
    pow(hangboard_lip_min_t, 2) / 6;
lip_design_bending_mpa = design_force_n * hangboard_pocket_depth_z / lip_section_modulus_mm3;
wrist_arm_lever_y = max(wrist_mount_y_top - wrist_pad_y_max,
    wrist_pad_y_min - wrist_mount_y_bottom) + wrist_pad_corner_r;
wrist_arm_section_modulus_mm3 = wrist_plate_t * pow(wrist_arm_w_x - wrist_mount_hole_d, 2) / 6;
wrist_arm_design_bending_mpa = wrist_force_per_fastener_n / 2 * wrist_arm_lever_y /
    wrist_arm_section_modulus_mm3;
// Local heel-deck cantilever screen, using the full design force at its end
// and only the full-thickness central width. Not a vertical system load rating.
wrist_saddle_overhang = wrist_saddle_depth_x - wrist_pad_t_x;
wrist_saddle_section_modulus_mm3 = wrist_saddle_core_width_y * pow(wrist_saddle_t, 2) / 6;
wrist_saddle_design_bending_mpa = design_force_n * wrist_saddle_overhang /
    wrist_saddle_section_modulus_mm3;

assert(loadcell_rated_kg == 50, "This interface is restricted to the 50 kg sensor.");
assert(structural_safety_factor >= 2, "Use a structural design factor of at least 2.0.");
assert(bushing_od < eye_d, "Eye-collar body must clear the load-cell eye.");
assert(bushing_id > pin_nominal_d, "Pin spacer ID must clear the M8 retainer.");
assert(bushing_core_od >= bushing_id + 3.5, "Pin-spacer wall is too thin.");
assert(bushing_core_od < bushing_od, "Pin spacer must be smaller than the eye collar.");
assert(bushing_collar_id > bushing_core_od, "Eye collar must slide over the pin spacer.");
assert(bushing_eye_collar_flange_od < eye_d + 1.0,
    "Eye-collar flange must fit the Ø18 mm enclosure access hole.");
assert(pin_hole_d > bushing_core_od, "Clevis bores must clear the pin spacer.");
assert(clevis_plate_t >= 4, "Clevis plates must be at least 4 mm thick.");
assert(clevis_width_y >= 3 * pin_nominal_d,
    "Clevis width must provide adequate pin edge distance.");
assert(frame_case_clear_y >= 4,
    "Frame rails must clear the enclosure by at least 4 mm in Y.");
assert(grip_rail_gap_y >= 2 && grip_guide_bearing_y >= 3 &&
    grip_guide_gap_z > 0 && grip_guide_gap_z <= 0.5 &&
    grip_guide_x_min > frame_split_x_min + 1 &&
    grip_guide_z_max < frame_split_lap_z - 2 &&
    grip_guide_z_min > frame_z_min + 2 &&
    grip_guide_x_max > hangboard_body_x_max + rated_preview_deflection,
    "Grip guides must sit under the grip side walls with a small Z gap, inside the right half's lower lap tongue, and leave X free.");
assert(hangboard_body_x_min > case_outer_x_max,
    "Hangboard grip collides with the enclosure.");
assert(hangboard_pocket_depth_z == 25,
    "The hangboard pocket must remain 25 mm deep.");
assert(hangboard_back_wall_t >= 6,
    "Hangboard pocket back wall must be at least 6 mm thick.");
assert(hangboard_opening_w_y >= 80 &&
    abs(hangboard_opening_y_max - hangboard_opening_y_min - hangboard_opening_w_y) < 0.001,
    "Four-finger opening must be at least 80 mm wide.");
assert(hangboard_opening_x_max > hangboard_opening_x_min,
    "Hangboard pocket opening collapsed in X.");
assert(hangboard_lip_radius > 0 && hangboard_lip_radius <= 2,
    "Loading-edge radius must be in (0, 2] mm.");
assert(hangboard_lip_min_t >= 8,
    "Rounded hangboard loading lip must retain at least 8 mm thickness.");
assert(hangboard_opening_x_max - hangboard_opening_x_min - 2 * hangboard_draft >= 18,
    "Finger pocket must retain at least 18 mm clearance at its floor.");
assert(hangboard_opening_y_max - hangboard_opening_y_min - 2 * hangboard_draft >= 78,
    "Finger pocket must retain at least 78 mm usable width at its floor.");
assert(stopper_clearance >= 0.15 && stopper_clearance <= 0.4 &&
    stopper_r >= 2 && stopper_min_t() >= 5 &&
    stopper_min_t() - stopper_pull_knot_h >= 3 &&
    stopper_pull_inset_y - stopper_pull_knot_d / 2 >= 0.5 &&
    stopper_y_max - stopper_pull_inset_y - stopper_pull_hole_d / 2
        > frame_center_y + 32 &&
    stopper_y_min + stopper_pull_inset_y + stopper_pull_hole_d / 2
        < frame_center_y - 32,
    "Stoppers need a sliding fit, at least 5 mm thickness, and pull holes outside the 64 mm finger width.");
assert(hand_opening >= 40 && hand_opening <= 90,
    "Nominal hand_opening should remain within 40-90 mm.");
assert(hand_opening_min == 25 && hand_opening_max == 105 && wrist_index_count == 9,
    "Preserve nine 25-105 mm opening positions.");
assert(wrist_saddle_depth_x >= 50 && wrist_saddle_depth_x <= 65,
    "Heel saddle must provide a 50-65 mm continuous contact surface.");
assert(wrist_saddle_t >= 2 * wrist_pad_corner_r + 4 &&
    wrist_rest_raise >= 15 && wrist_rest_raise <= 25 &&
    wrist_saddle_z_min >= frame_z_max + wrist_deck_frame_clearance &&
    wrist_saddle_z_min <= wrist_plate_z_max_2 - 3 &&
    wrist_saddle_z_max >= wrist_plate_z_max_2 + wrist_quick_pin_head_h
        + wrist_quick_pin_button_h + 2,
    "The heel deck must clear the frame top, join the upper arms, and sit above the pin heads.");
assert(wrist_saddle_core_width_y >= 64 &&
    wrist_arm_pad_overlap_y >= 4 && wrist_arm_pad_overlap_y <= wrist_cradle_edge_w &&
    wrist_upper_arm_x_max >= wrist_arm_x_max &&
    wrist_upper_arm_x_max > wrist_palm_bolster_x_max &&
    wrist_upper_arm_joint_shear_mpa <= allowable_printed_tension_mpa / 2,
    "Upper arms must stay outside the skin-contact deck and keep their saddle joint section.");
assert(wrist_cradle_edge_w >= 4 && wrist_cradle_edge_w <= wrist_pad_corner_r &&
    wrist_cradle_open_width_y >= 64 &&
    wrist_cradle_open_depth_x >= wrist_cradle_open_depth_min_x,
    "The palm cradle must retain a 38 mm open, uninterrupted heel deck.");
assert(wrist_cradle_rise >= 1.5 && wrist_cradle_rise <= 4 &&
    wrist_cradle_embed > 0 && wrist_cradle_embed < wrist_saddle_t / 2 &&
    wrist_cradle_edge_radius >= 2 &&
    wrist_cradle_edge_radius < min(wrist_cradle_edge_w,
        wrist_cradle_rise + wrist_cradle_embed) / 2,
    "Palm side rims must be low with broad rounded contact edges.");
assert(wrist_palm_bolster_x_min == wrist_saddle_x_min &&
    wrist_palm_bolster_flat_top_x >= 8 &&
    wrist_palm_bolster_x_max - wrist_palm_bolster_rear_r - 1
        >= wrist_saddle_x_min + wrist_pad_t_x &&
    wrist_palm_bolster_x_max + wrist_palm_bolster_fillet_r
        < wrist_saddle_x_max - wrist_cradle_edge_w,
    "Palm bolster must start at the palm face, keep a nearly flat top, and cover the arm plates.");
assert(wrist_palm_bolster_rise >= 10 && wrist_palm_bolster_rise <= 14 &&
    wrist_palm_bolster_front_r >= 5 && wrist_palm_bolster_front_r <= 8 &&
    wrist_palm_bolster_rear_r >= 4 &&
    wrist_palm_bolster_rear_r <= wrist_palm_bolster_front_r &&
    wrist_palm_bolster_fillet_r >= 3 &&
    wrist_palm_bolster_fillet_r <= wrist_palm_bolster_rise
        - max(wrist_palm_bolster_front_r, wrist_palm_bolster_rear_r) - 1,
    "Palm bolster needs large rolled edges and a >=3 mm fillet on a vertical rear face.");
assert(wrist_palm_bolster_embed > wrist_pad_corner_r &&
    wrist_palm_bolster_embed <= wrist_saddle_t - 4,
    "Palm bolster must root below the palm-face edge radius, inside the deck.");
assert(support_foot_w_x <= min(frame_left_post_t, frame_palm_post_t) - 4 &&
    support_foot_w_y <= frame_rail_t - 2 &&
    support_foot_top_z > frame_z_min && support_foot_bottom_z < frame_z_min,
    "Feet must overlap both posts and rails without exceeding their footprints.");
assert(support_foot_x_right - support_foot_w_x / 2 >
    wrist_pad_center_x + wrist_adjust_range + wrist_pad_t_x / 2,
    "Right-hand feet obstruct the palm at maximum travel.");
assert(support_foot_bottom_z + 5 <= min(wrist_pin_tip_low_z, loadcell_nut_low_z),
    "Fasteners must remain at least 5 mm above the support plane.");
assert(wrist_mount_y_top - wrist_pin_access_d / 2 > wrist_pad_y_max &&
    wrist_mount_y_bottom + wrist_pin_access_d / 2 < wrist_pad_y_min,
    "Keep pin heads and their extraction paths outside the contact saddle.");
assert(wrist_saddle_design_bending_mpa <= allowable_printed_bending_mpa,
    "Heel saddle exceeds configured nominal bending stress.");
assert(wrist_quick_pin_d >= 6,
    "Use quick-release pins at least 6 mm in diameter.");
assert(wrist_mount_hole_d > wrist_quick_pin_d,
    "Pad holes must clear the quick-release pins.");
assert(abs(wrist_quick_pin_stack_h - wrist_quick_pin_grip_l) <= 0.2,
    "Quick-release pin grip length must match the pad/frame stack.");
assert(wrist_mount_hole_d < frame_rail_t - 4,
    "Wrist mounting holes leave too little frame rail material.");
assert(abs(
    2 * wrist_adjust_range
    - wrist_index_pitch * round(2 * wrist_adjust_range / wrist_index_pitch)
) < 0.001,
    "The wrist travel must divide evenly into indexed positions.");
assert(wrist_pad_center_x - wrist_adjust_range - wrist_pad_t_x / 2
    >= hangboard_body_x_max + 25,
    "Palm pad gets too close to the hangboard pocket at minimum adjustment.");
assert(wrist_pad_center_x + wrist_adjust_range + wrist_pad_t_x / 2
    <= frame_palm_post_inner_x - wrist_post_clear_x + 0.001,
    "Palm pad collides with the fixed outer post at maximum adjustment.");
assert(wrist_index_remaining_web_y >= 8,
    "Index holes leave too little top/bottom rail material.");
assert(wrist_index_ligament_x >= 3.5,
    "Index holes are too close together.");
assert(wrist_pin_design_shear_mpa <= allowable_quick_pin_shear_mpa,
    "Wrist quick-release pins exceed the configured design shear stress.");
assert(wrist_arm_design_bearing_mpa <= allowable_printed_bearing_mpa,
    "Wrist-pad arms exceed the configured printed bearing stress.");
assert(wrist_rail_design_bearing_mpa <= allowable_printed_bearing_mpa,
    "Frame rails exceed the configured printed bearing stress.");
assert(service_tunnel_w > usb_cable_boot_w + 2,
    "Service tunnel is too narrow for the USB cable boot.");
assert(anchor_design_bending_mpa <= allowable_printed_bending_mpa,
    "Left anchor post exceeds configured bending stress.");
assert(clevis_design_bearing_mpa <= allowable_printed_bearing_mpa &&
    clevis_net_tension_mpa <= allowable_printed_tension_mpa,
    "Clevis cheeks exceed configured bearing/net-section stress.");
assert(rail_net_tension_mpa <= allowable_printed_tension_mpa &&
    service_net_tension_mpa <= allowable_printed_tension_mpa &&
    rail_ligament_shear_mpa <= allowable_printed_tension_mpa / 2,
    "Perforated rails or service bridge exceed configured nominal stress.");
assert(sleeve_a > 0 && sleeve_b > 0 &&
    sleeve_design_bending_mpa <= allowable_insert_bending_mpa,
    "Metal pin sleeve exceeds configured bending stress or sensor is outside supports.");
assert(collar_design_bearing_mpa <= allowable_collar_bearing_mpa,
    "Metal eye collars exceed configured bearing stress.");
assert(lip_design_bending_mpa <= allowable_printed_bending_mpa &&
    wrist_arm_design_bending_mpa <= allowable_printed_bending_mpa,
    "Finger lip or wrist arms exceed configured nominal bending stress.");
assert(frame_split_x_min - 3 > service_tunnel_w / 2 &&
    frame_split_x_min - 3 > fixed_clevis_x_max &&
    frame_split_x_max + 3 <= wrist_arm_x_min - wrist_adjust_range &&
    frame_split_left_len <= frame_split_bed_max &&
    frame_split_right_len <= frame_split_bed_max,
    "Frame lap joint must cross plain rails only, clear the wrist arms and leave both halves printable.");
assert(phone_slot_w >= 13 && phone_slot_w <= 16 &&
    phone_slot_depth_z >= 12 && phone_slot_z_min > stopper_well_z_min - 20 &&
    phone_slot_tilt >= 5 && phone_slot_tilt <= 25 &&
    stopper_well_z_min >= frame_z_min + 8 && phone_slot_z_min >= frame_z_min + 8,
    "Phone slot must fit a phone in its case, lean it back, and keep solid floors under the slot and stopper well.");
assert(frame_split_bolt_end_dist >= 2 * frame_split_bolt_hole_d &&
    frame_split_bolt_pitch >= 3 * frame_split_bolt_d &&
    frame_split_bolt_side_wall_y >= 2.5 &&
    frame_split_bolt_bearing_l >= 2 * frame_split_bolt_d &&
    frame_split_nut_pocket_depth >= frame_split_nut_h &&
    frame_split_bolt_cbore_depth >= frame_split_bolt_head_h + 0.5 &&
    frame_split_bolt_tip_recess >= 0.5 &&
    frame_split_nut_start_engagement >= frame_split_nut_h / 2,
    "Frame lap bolts need edge distance, rail walls, bearing length, recessed heads and nuts, and a screw that reaches a nut at the pocket mouth.");
assert(frame_split_bolt_design_shear_mpa <= allowable_frame_bolt_shear_mpa &&
    frame_split_bolt_design_bearing_mpa <= allowable_printed_bearing_mpa &&
    frame_split_shoulder_bearing_mpa <= allowable_printed_bearing_mpa &&
    frame_split_tongue_net_tension_mpa <= allowable_printed_tension_mpa &&
    frame_split_tongue_design_bending_mpa <= allowable_printed_bending_mpa,
    "Frame lap joint exceeds configured bolt shear or printed bearing, tension or bending stress.");
