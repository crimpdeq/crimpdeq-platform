#!/usr/bin/env bash
# Export printable parts as crimpdeq-platform-<part>.stl.
# Usage: bash export-parts.sh [part ...]   (default: every part)
# EXPORT_DIR sets the output directory (default: exports/).
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out_dir="${EXPORT_DIR:-$project_root/exports}"
render_fn="${OPENSCAD_RENDER_FN:-96}"
export_jobs="${EXPORT_JOBS:-4}"

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

parts=("$@")
if (( ${#parts[@]} == 0 )); then
    parts=(
        frame grip wrist_rest pin_spacer_pair
        frame_left frame_right frame_split_pegs frame_split_braces
        fit_bolt_set fit_quick_pin_pair
    )
fi

mkdir -p "$out_dir"

export_part() {
    local part="$1"
    local stl="$out_dir/crimpdeq-platform-${part}.stl"
    local log_file="$stl.log"
    if ! openscad -D "render_fn=${render_fn}" -D "part=\"${part}\"" \
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

failed=0
for part in "${parts[@]}"; do
    export_part "$part" &
    while (( $(jobs -pr | wc -l) >= export_jobs )); do
        wait -n || failed=1
    done
done
while (( $(jobs -pr | wc -l) > 0 )); do
    wait -n || failed=1
done
exit "$failed"
