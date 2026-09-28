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
    "anchor_case empty"
    "grip_case empty"
    "base_case empty"
    "clips_case empty"
    "case_drop empty"
    "anchor_base empty"
    "anchor_seated nonempty"
    "anchor_bears nonempty"
    "grip_base empty"
    "grip_guide_support_0 nonempty"
    "grip_guide_support_1 nonempty"
    "tab_seated_0 nonempty"
    "tab_seated_1 nonempty"
    "lug_clear empty"
    "lug_bearing_0 nonempty"
    "lug_bearing_1 nonempty"
    "clip_parts empty"
    "clip_clamp_0 nonempty"
    "clip_clamp_1 nonempty"
    "clip_path_0 empty"
    "clip_path_1 empty"
    "service_path empty"
    "base_halves_overlap empty"
    "base_joint_locked nonempty"
    "base_joint_bears nonempty"
    "rest_retained nonempty"
    "rest_slide_on empty"
    "finger_entry empty"
    "pocket_floor nonempty"
    "phone_slot empty"
    "phone_seated nonempty"
    "stopper_stored empty"
    "stopper_stored_seated nonempty"
)
for index in {0..8}; do
    checks+=("rest_position_${index} empty")
done
for index in {0..3}; do
    checks+=("clip_retained_${index} nonempty")
    checks+=("rest_locked_${index} nonempty")
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
    if [[ "$mode" =~ ^(grip_guide_support|tab_seated|lug_bearing|clip_clamp|clip_retained|clip_path|rest_position|rest_locked|stopper_pocket|stopper_seated|stopper_located|stopper_stack_pocket|stopper_stack_contact|stopper_stack_located|stopper_tab_proud|stopper_finger_width)_([0-8])$ ]]; then
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

# Each single part must be one body; the paired parts export as two bodies.
single_parts=(base_front base_rear anchor grip rest)
paired_parts=(clips keys stoppers)
for part in "${single_parts[@]}" "${paired_parts[@]}"; do
    log_file="$tmp_dir/export_${part}.log"
    if ! openscad -D "render_fn=${render_fn}" -D "part=\"${part}\"" \
        -o "$tmp_dir/dynamometer_${part}.stl" "$project_root/dynamometer_assembly.scad" \
        >"$log_file" 2>&1 || grep -Eq 'ERROR:|WARNING:' "$log_file"; then
        printf 'Export failed: %s\n' "$part" >&2
        while IFS= read -r line; do printf '%s\n' "$line" >&2; done <"$log_file"
        exit 1
    fi
done

single_stls=()
for part in "${single_parts[@]}"; do single_stls+=("$tmp_dir/dynamometer_${part}.stl"); done
paired_stls=()
for part in "${paired_parts[@]}"; do paired_stls+=("$tmp_dir/dynamometer_${part}.stl"); done
python3 "$project_root/check-stl-components.py" "${single_stls[@]}"
python3 "$project_root/check-stl-components.py" --expect 2 "${paired_stls[@]}"

echo "STL connectivity checks passed."

# CSG export can exit successfully on assertion failure; inspect diagnostics.
invalid_parameters=(
    'loadcell_rated_kg=60'
    'structural_safety_factor=1.5'
    'u_slot_clear=0.5'
    'lug_fit=0.5'
    'lug_neck_r=7.5'
    'allowable_lug_bearing_mpa=12'
    'clip_snap=0.8'
    'clip_fin_top_z=26'
    'case_float_gap=0.5'
    'hangboard_pocket_depth_z=24'
    'hangboard_opening_w_y=76'
    'hangboard_front_z=20'
    'hangboard_lip_radius=3'
    'grip_guide_gap_z=0'
    'grip_guide_gap_z=1'
    'stopper_clearance=0.1'
    'stopper_t_list=[3,10]'
    'stopper_t_list=[10,10]'
    'stopper_t_list=[5,10,5]'
    'stopper_tab_rise=2'
    'hand_opening=75'
    'rest_adjust_range=30'
    'rest_index_pitch=8'
    'rest_bolster_rise=10'
    'key_t_x=4'
    'key_y=45'
    'base_z_min=-24'
    'base_split_x=95'
    'base_split_x=150'
    'phone_slot_w=11'
    'phone_slot_tilt=40'
    'phone_slot_depth_z=10'
    'phone_slot_z_min=0'
    'phone_stand_clear_x=2'
)
for parameter in "${invalid_parameters[@]}"; do
    log_file="$tmp_dir/invalid.log"
    openscad -D "render_fn=${render_fn}" -D 'part="base_front"' -D "$parameter" \
        -o "$tmp_dir/invalid.csg" "$project_root/dynamometer_assembly.scad" \
        >"$log_file" 2>&1 || true
    if ! grep -q 'ERROR: Assertion' "$log_file"; then
        printf 'Expected assertion for %s\n' "$parameter" >&2
        while IFS= read -r line; do printf '%s\n' "$line" >&2; done <"$log_file"
        exit 1
    fi
    printf 'Rejected unsafe parameter: %s\n' "$parameter"
done
