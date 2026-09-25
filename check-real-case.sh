#!/usr/bin/env bash
# Optional integration check against the current sibling crimpdeq-case source.
# The standalone platform model and its normal collision suite do not depend
# on the sibling repository at runtime.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case_dir="${CRIMPDEQ_CASE_DIR:-$root/../crimpdeq-case/case}"
for file in case_main.scad case_lid.scad; do
    if [[ ! -f "$case_dir/$file" ]]; then
        echo "Missing $case_dir/$file (set CRIMPDEQ_CASE_DIR to the case source directory)" >&2
        exit 1
    fi
done

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
# Include the platform's own parameters. `use` imports only modules from the
# case repository so same-name variables/modules cannot shadow platform data.
scad="$tmp_dir/actual-case-check.scad"
printf 'use <%s/dynamometer_parts.scad>\n' "$root" >"$scad"
printf 'use <%s/case_main.scad>\n' "$case_dir" >>"$scad"
printf 'use <%s/case_lid.scad>\n' "$case_dir" >>"$scad"
printf 'include <%s/dynamometer_dimensions.scad>\n' "$root" >>"$scad"
cat >>"$scad" <<'SCAD'
render_fn = is_undef(render_fn) ? 24 : render_fn;
$fn = render_fn;
mode = is_undef(mode) ? "frame" : mode;
index = is_undef(index) ? 0 : index;
assert(index >= 0 && index < wrist_index_count && index == floor(index));
module real_case() { main_part(); lid_part(); }
intersection() {
    if (mode == "frame") fixed_frame();
    else if (mode == "grip") moving_finger_grip();
    else if (mode == "bushings") dynamometer_bushings();
    else if (mode == "wrist")
        adjustable_wrist_rest(x_offset = -wrist_adjust_range + index * wrist_index_pitch);
    else assert(false, str("Unknown mode ", mode));
    real_case();
}
SCAD

render_fn="${OPENSCAD_RENDER_FN:-24}"
[[ "$render_fn" =~ ^[0-9]+$ ]] && (( render_fn >= 3 )) || {
    echo 'OPENSCAD_RENDER_FN must be an integer >= 3' >&2
    exit 1
}
for mode in frame grip bushings wrist; do
    for index in $(if [[ "$mode" == wrist ]]; then seq 0 8; else echo 0; fi); do
        log="$tmp_dir/$mode-$index.log"
        code=0
        openscad -D "render_fn=$render_fn" -D "mode=\"$mode\"" -D "index=$index" \
            -o "$tmp_dir/$mode-$index.stl" "$scad" >"$log" 2>&1 || code=$?
        if grep -Eq 'ERROR:|WARNING:' "$log" ||
           (( code == 0 )) ||
           ! grep -q 'Current top level object is empty' "$log"; then
            echo "Real-case collision check failed: $mode index=$index" >&2
            while IFS= read -r line; do printf '%s\n' "$line" >&2; done <"$log"
            exit 1
        fi
        echo "Real case / $mode / index=$index: clear"
    done
done
