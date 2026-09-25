#!/usr/bin/env bash
# Render the book illustrations from illustrations.scad into ../src/images.
# Usage: bash render-illustrations.sh [view ...]
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$here/../src/images"
jobs="${RENDER_JOBS:-4}"
size="${RENDER_SIZE:-1400,900}"
mkdir -p "$out"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# view -> "rx,ry,rz" (auto-framed) or "tx,ty,tz,rx,ry,rz,distance"
declare -A cameras=(
    [overview]="62,0,28"
    [plate1]="0,0,0"
    [plate2]="0,0,0"
    [dry_fit]="60,0,35"
    [slide_rest]="58,0,32"
    [glue]="58,0,28"
    [glue_braces]="100,0,30"
    [case_in]="58,0,25"
    [grip_in]="58,0,25"
    [bolt_stack]="0,0,0"
    [bolt_done]="0,0,0"
    [wrist_pin]="0,0,0"
    [position_min]="0,0,0"
    [position_max]="0,0,0"
    [printed_hardware]="55,0,30"
)

views=("$@")
if [ "${#views[@]}" -eq 0 ]; then
    views=("${!cameras[@]}")
fi

render() {
    local view="$1" cam="${cameras[$1]}" framing scheme tag
    # Three values: rotation with auto-framing. Seven: explicit gimbal camera.
    if [ "$(tr -cd , <<<"$cam" | wc -c)" -eq 2 ]; then
        framing=(--viewall --autocenter --camera="0,0,0,${cam},500")
    else
        framing=(--camera="$cam")
    fi
    # Render on a light and a black background; matte.py derives transparency.
    for scheme in Tomorrow Starnight; do
        tag="$tmp/${view}.${scheme}"
        openscad --preview --projection=p "${framing[@]}" \
            --colorscheme="$scheme" --imgsize="$size" \
            -D "view=\"${view}\"" \
            -o "${tag}.png" "$here/illustrations.scad" \
            >"${tag}.log" 2>&1 || { cat "${tag}.log" >&2; return 1; }
        if grep -qE "WARNING|ERROR" "${tag}.log"; then
            grep -E "WARNING|ERROR" "${tag}.log" >&2
            return 1
        fi
    done
    python3 "$here/matte.py" "$tmp/${view}.Tomorrow.png" "$tmp/${view}.Starnight.png" \
        "$tmp/${view}.png"
    magick "$tmp/${view}.png" -trim +repage -bordercolor none -border 40 "$out/${view}.png"
    echo "rendered ${view}.png"
}
export -f render
export here out size tmp

status=0
for view in "${views[@]}"; do
    render "$view" &
    while [ "$(jobs -rp | wc -l)" -ge "$jobs" ]; do wait -n || status=1; done
done
while [ "$(jobs -rp | wc -l)" -gt 0 ]; do wait -n || status=1; done
exit "$status"
