#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

if ! command -v openscad >/dev/null 2>&1; then
    echo "openscad not found in PATH" >&2
    exit 1
fi

render_fn="${OPENSCAD_RENDER_FN:-24}"
check_jobs="${CHECK_JOBS:-4}"

if [[ ! "$render_fn" =~ ^[0-9]+$ ]] || (( render_fn < 3 )); then
    echo "OPENSCAD_RENDER_FN must be an integer >= 3" >&2
    exit 1
fi
if [[ ! "$check_jobs" =~ ^[0-9]+$ ]] || (( check_jobs < 1 )); then
    echo "CHECK_JOBS must be an integer >= 1" >&2
    exit 1
fi

checks=(
    "frame_case empty"
    "grip_case empty"
    "frame_grip empty"
    "frame_grip_rated empty"
    "grip_guide_support_0 nonempty"
    "grip_guide_support_1 nonempty"
    "stopper_stored empty"
    "stopper_stored_seated nonempty"
    "phone_slot empty"
    "phone_seated nonempty"
    "interfaces_case empty"
    "interfaces_frame empty"
    "interfaces_grip empty"
    "interfaces_loadcell_contact nonempty"
    "interfaces_loadcell_relief empty"
    "service_path empty"
    "frame_split_complete empty"
    "frame_split_overlap empty"
    "frame_split_bore_wall empty"
    "frame_split_hardware_frame empty"
    "frame_split_hardware_recessed empty"
    "frame_split_hardware_clear empty"
    "wrist_slide_on empty"
    "left_eye_alignment nonempty"
    "right_eye_alignment nonempty"
    "wrist_frame_center empty"
    "wrist_frame_min empty"
    "wrist_frame_max empty"
    "wrist_case empty"
    "wrist_grip empty"
    "wrist_pad_hole_min empty"
    "wrist_pad_hole_max empty"
    "wrist_frame_index_min empty"
    "wrist_frame_index_max empty"
    "finger_entry empty"
    "pocket_floor nonempty"
    "wrist_contact_skin empty"
    "wrist_deck_open empty"
    "wrist_bolster_front_plane empty"
    "wrist_bolster_top empty"
    "wrist_bolster_height empty"
    "wrist_bolster_fillet nonempty"
)
for index in {0..8}; do
    checks+=("wrist_position_${index} empty")
done
for index in {0..3}; do
    checks+=("foot_contact_${index} nonempty")
done
for index in {0..7}; do
    checks+=("frame_split_clamp_${index} nonempty")
done
for index in {0..1}; do
    checks+=("stopper_pocket_${index} empty")
    checks+=("stopper_seated_${index} nonempty")
    checks+=("stopper_stack_pocket_${index} empty")
    checks+=("stopper_stack_contact_${index} nonempty")
    checks+=("stopper_tab_proud_${index} nonempty")
done
for index in {0..3}; do
    checks+=("stopper_located_${index} nonempty")
    checks+=("stopper_stack_located_${index} nonempty")
    checks+=("stopper_finger_width_${index} empty")
done

current_job_count() {
    jobs -pr | wc -l | tr -d ' '
}

# macOS ships bash 3.2, which lacks `wait -n` (bash 4.3+); poll instead.
wait_for_any_job() {
    if (( BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 3) )); then
        wait -n || true
    else
        sleep 0.2
    fi
}

check_mode() {
    local mode="$1"
    local expected="$2"
    local log_file="$tmp_dir/${mode}.log"
    local out_file="$tmp_dir/${mode}.stl"
    local status_file="$tmp_dir/${mode}.status"
    local error_file="$tmp_dir/${mode}.error"
    local result log_text exit_code=0 scad_mode="$mode" test_position=0
    if [[ "$mode" =~ ^(wrist_position|foot_contact|frame_split_clamp|grip_guide_support|stopper_pocket|stopper_seated|stopper_located|stopper_stack_pocket|stopper_stack_contact|stopper_stack_located|stopper_tab_proud|stopper_finger_width)_([0-8])$ ]]; then
        scad_mode="${BASH_REMATCH[1]}"
        test_position="${BASH_REMATCH[2]}"
    fi

    openscad -D "render_fn=${render_fn}" -D "mode=\"${scad_mode}\"" \
        -D "test_position=${test_position}" \
        -o "$out_file" "$project_root/collision_check.scad" >"$log_file" 2>&1 || exit_code=$?
    log_text="$(<"$log_file")"
    # An assertion failure may ALSO report an empty top-level object.
    # Never accept that as a passing collision test.
    if grep -Eq 'ERROR:|WARNING:' "$log_file"; then
        result="openscad-error"
    elif (( exit_code == 0 )); then
        result="nonempty"
    elif [[ "$log_text" == *"Current top level object is empty"* ]]; then
        result="empty"
    else
        result="openscad-error"
    fi

    printf '%-32s %s (expected %s)\n' "$mode" "$result" "$expected" >"$status_file"
    if [[ "$result" != "$expected" ]]; then
        cp "$log_file" "$error_file"
        return 1
    fi
}

echo "Running ${#checks[@]} collision checks with CHECK_JOBS=$check_jobs"

pids=()
for check in "${checks[@]}"; do
    IFS=' ' read -r mode expected <<<"$check"
    check_mode "$mode" "$expected" &
    pids+=("$!")

    while (( $(current_job_count) >= check_jobs )); do
        wait_for_any_job
    done
done

failed=0
for pid in "${pids[@]}"; do
    if ! wait "$pid"; then
        failed=1
    fi
done

for check in "${checks[@]}"; do
    IFS=' ' read -r mode _ <<<"$check"
    if [[ -f "$tmp_dir/${mode}.status" ]]; then
        while IFS= read -r line; do
            printf '%s\n' "$line"
        done <"$tmp_dir/${mode}.status"
    else
        printf '%-32s %s\n' "$mode" "missing-status"
        failed=1
    fi
done

if (( failed )); then
    for check in "${checks[@]}"; do
        IFS=' ' read -r mode _ <<<"$check"
        if [[ -f "$tmp_dir/${mode}.error" ]]; then
            printf '\n--- %s ---\n' "$mode" >&2
            while IFS= read -r line; do
                printf '%s\n' "$line" >&2
            done <"$tmp_dir/${mode}.error"
        fi
    done
    exit 1
fi

echo "Collision checks passed."

# The load-bearing parts must each be one body. The unloaded stoppers export
# together and must be exactly two bodies, one per stopper.
parts=(frame_left frame_right grip wrist_rest stoppers)
stls=()
for part in "${parts[@]}"; do
    log_file="$tmp_dir/export_${part}.log"
    if [[ "$part" != stoppers ]]; then
        stls+=("$tmp_dir/dynamometer_${part}.stl")
    fi
    if ! openscad -D "render_fn=${render_fn}" -D "part=\"${part}\"" \
        -o "$tmp_dir/dynamometer_${part}.stl" "$project_root/dynamometer_assembly.scad" \
        >"$log_file" 2>&1 || grep -Eq 'ERROR:|WARNING:' "$log_file"; then
        printf 'Export failed: %s\n' "$part" >&2
        while IFS= read -r line; do printf '%s\n' "$line" >&2; done <"$log_file"
        exit 1
    fi
done

python3 "$project_root/check-stl-components.py" "${stls[@]}"
python3 "$project_root/check-stl-components.py" --expect 2 \
    "$tmp_dir/dynamometer_stoppers.stl"

echo "STL connectivity checks passed."

# CSG export can exit successfully on assertion failure; inspect diagnostics.
invalid_parameters=(
    'loadcell_rated_kg=60'
    'structural_safety_factor=1.5'
    'hangboard_pocket_depth_z=24'
    'hangboard_opening_w_y=76'
    'grip_rail_gap_y=1'
    'grip_guide_gap_z=0'
    'grip_guide_gap_z=1'
    'stopper_clearance=0.1'
    'stopper_t_list=[3,10]'
    'stopper_t_list=[10,10]'
    'stopper_t_list=[5,10,5]'
    'stopper_tab_rise=2'
    'hangboard_body_w_x=30'
    'hangboard_lip_radius=3'
    'hand_opening=75'
    'wrist_adjust_range=30'
    'frame_rail_t=12'
    'clevis_plate_t=4'
    'allowable_insert_bending_mpa=30'
    'allowable_collar_bearing_mpa=12'
    'wrist_saddle_depth_x=40'
    'wrist_saddle_depth_x=60'
    'wrist_saddle_depth_x=80'
    'wrist_saddle_t=10'
    'wrist_cradle_edge_w=6'
    'wrist_cradle_rise=10'
    'wrist_cradle_edge_radius=3'
    'wrist_palm_bolster_depth_x=18'
    'wrist_palm_bolster_depth_x=26'
    'wrist_palm_bolster_rise=16'
    'wrist_palm_bolster_rise=26'
    'wrist_palm_bolster_front_r=4'
    'wrist_palm_bolster_rear_r=3'
    'wrist_palm_bolster_rear_r=7'
    'wrist_palm_bolster_fillet_r=2'
    'wrist_palm_bolster_embed=4'
    'wrist_upper_arm_joint_x=20'
    'wrist_post_channel_clearance=1'
    'wrist_post_channel_y_margin=1'
    'phone_slot_w=11'
    'phone_slot_tilt=40'
    'phone_slot_depth_z=10'
    'support_foot_clearance=4'
    'loadcell_bolt_l=55'
    'loadcell_bolt_l=70'
    'frame_split_x=30'
    'frame_split_x=80'
    'frame_split_lap_len=36'
    'frame_split_bolt_d=6'
    'frame_split_bolt_l=40'
    'frame_split_bolt_tip_recess=0'
    'frame_split_bolt_tip_recess=4'
    'frame_split_bolt_pitch=12'
    'allowable_frame_bolt_shear_mpa=30'
)
for parameter in "${invalid_parameters[@]}"; do
    log_file="$tmp_dir/invalid.log"
    openscad -D "render_fn=${render_fn}" -D 'part="frame_left"' -D "$parameter" \
        -o "$tmp_dir/invalid.csg" "$project_root/dynamometer_assembly.scad" \
        >"$log_file" 2>&1 || true
    if ! grep -q 'ERROR: Assertion' "$log_file"; then
        printf 'Expected assertion for %s\n' "$parameter" >&2
        while IFS= read -r line; do printf '%s\n' "$line" >&2; done <"$log_file"
        exit 1
    fi
    printf 'Rejected unsafe parameter: %s\n' "$parameter"
done
