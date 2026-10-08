#!/usr/bin/env bash
# Optional integration check against the current sibling crimpdeq-case source.
# The standalone platform model and its normal collision suite do not depend
# on the sibling repository at runtime.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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
printf 'use <%s/platform/parts.scad>\n' "$root" >"$scad"
printf 'use <%s/case_main.scad>\n' "$case_dir" >>"$scad"
printf 'use <%s/case_lid.scad>\n' "$case_dir" >>"$scad"
printf 'include <%s/platform/dimensions.scad>\n' "$root" >>"$scad"
cat >>"$scad" <<'SCAD'
render_fn = is_undef(render_fn) ? 24 : render_fn;
$fn = render_fn;
mode = is_undef(mode) ? "base" : mode;
index = is_undef(index) ? 0 : index;
assert(index >= 0 && index < rest_index_count && index == floor(index));
module real_case() { main_part(); lid_part(); }
if (mode == "drop") {
    // The real case lowers onto both lugs without touching them.
    intersection() {
        union() { anchor_block(); finger_grip(); }
        for (dz = [0.01, 1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 20])
            translate([0, 0, dz]) real_case();
    }
} else if (mode == "clip_path") {
    // Both clips drop in beside their lugs and slide in without touching it.
    intersection() {
        for (side = ["left", "right"]) {
            for (dz = [0.01, 2, 5, 10, 15, 20, 25])
                translate([0, 0, dz]) eye_clip(side, dx = clip_install_travel);
            for (dx = [0 : 1 : clip_install_travel])
                translate([0, 0, 0.01]) eye_clip(side, dx = dx);
        }
        real_case();
    }
} else intersection() {
    if (mode == "base") { base_front(); base_rear(); }
    else if (mode == "anchor") anchor_block();
    else if (mode == "grip") {
        finger_grip();
        translate([rated_preview_deflection, 0, 0]) finger_grip();
    }
    else if (mode == "clips") eye_clips();
    else if (mode == "phone") { phone_reference(); phone_reference(portrait = true); }
    else if (mode == "stoppers") stored_pocket_stoppers();
    else if (mode == "rest") {
        palm_rest(rest_offset(index));
        index_key(rest_offset(index));
    }
    else assert(false, str("Unknown mode ", mode));
    real_case();
}
SCAD

render_fn="${OPENSCAD_RENDER_FN:-24}"
[[ "$render_fn" =~ ^[0-9]+$ ]] && (( render_fn >= 3 )) || {
    echo 'OPENSCAD_RENDER_FN must be an integer >= 3' >&2
    exit 1
}
for mode in base anchor grip clips stoppers phone drop clip_path rest; do
    for index in $(if [[ "$mode" == rest ]]; then seq 0 6; else echo 0; fi); do
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
