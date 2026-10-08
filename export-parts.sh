#!/usr/bin/env bash
# Export printable parts as crimpdeq-platform-<part>.stl.
# Usage: bash export-parts.sh [part ...]   (default: every part)
# EXPORT_DIR sets the output directory (default: exports/).
# ON_PLATE=true places each part where it sits on its print plate.
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out_dir="${EXPORT_DIR:-$project_root/exports}"
render_fn="${OPENSCAD_RENDER_FN:-96}"
export_jobs="${EXPORT_JOBS:-4}"
on_plate="${ON_PLATE:-false}"

if ! command -v openscad >/dev/null 2>&1; then
    echo "openscad not found in PATH" >&2
    exit 1
fi
if [[ ! "$render_fn" =~ ^[0-9]+$ ]] || (( render_fn < 3 )); then
    echo "OPENSCAD_RENDER_FN must be an integer >= 3" >&2
    exit 1
fi
if [[ ! "$export_jobs" =~ ^[0-9]+$ ]] || (( export_jobs < 1 )); then
    echo "EXPORT_JOBS must be an integer >= 1" >&2
    exit 1
fi
if [[ "$on_plate" != true && "$on_plate" != false ]]; then
    echo "ON_PLATE must be true or false" >&2
    exit 1
fi

parts=("$@")
if (( ${#parts[@]} == 0 )); then
    parts=(base_front base_rear anchor grip clips key rest stoppers)
fi

mkdir -p "$out_dir"

export_part() {
    local part="$1"
    local stl="$out_dir/crimpdeq-platform-${part}.stl"
    local log_file="$stl.log"
    if ! openscad -D "render_fn=${render_fn}" -D "part=\"${part}\"" -D "on_plate=${on_plate}" \
        -o "$stl" "$project_root/dynamometer_assembly.scad" >"$log_file" 2>&1 ||
        grep -Eq 'ERROR:|WARNING:' "$log_file"; then
        printf 'Export failed: %s\n' "$part" >&2
        while IFS= read -r line; do printf '%s\n' "$line" >&2; done <"$log_file"
        rm -f "$log_file"
        return 1
    fi
    rm -f "$log_file"
    printf 'Exported %s\n' "$stl"
}

# macOS ships bash 3.2, which lacks `wait -n` (bash 4.3+); poll instead.
wait_for_any_job() {
    if (( BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 3) )); then
        wait -n
    else
        sleep 0.2
    fi
}

failed=0
pids=()
for part in "${parts[@]}"; do
    export_part "$part" &
    pids+=("$!")
    while (( $(jobs -pr | wc -l) >= export_jobs )); do
        wait_for_any_job || true
    done
done
for pid in "${pids[@]}"; do
    wait "$pid" || failed=1
done
exit "$failed"
