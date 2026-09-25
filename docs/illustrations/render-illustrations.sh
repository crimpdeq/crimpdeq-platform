#!/usr/bin/env bash
# Render the book illustrations from illustrations.scad into ../src/images.
# Usage: bash render-illustrations.sh [view ...]
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$here/../src/images"
jobs="${RENDER_JOBS:-4}"
size="${RENDER_SIZE:-1400,900}"
mkdir -p "$out"

# view -> "rx,ry,rz" (auto-framed) or "tx,ty,tz,rx,ry,rz,distance"
declare -A cameras=(
    [overview]="62,0,28"
    [plate1]="0,0,0"
    [plate2]="0,0,0"
    [dry_fit]="60,0,35"
    [slide_rest]="58,0,32"
    [glue]="58,0,28"
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
    local view="$1" cam="${cameras[$1]}" framing
    # Three values: rotation with auto-framing. Seven: explicit gimbal camera.
    if [ "$(tr -cd , <<<"$cam" | wc -c)" -eq 2 ]; then
        framing=(--viewall --autocenter --camera="0,0,0,${cam},500")
    else
        framing=(--camera="$cam")
    fi
    openscad --preview --projection=p "${framing[@]}" \
        --colorscheme=Tomorrow --imgsize="$size" \
        -D "view=\"${view}\"" \
        -o "$out/${view}.png" "$here/illustrations.scad" \
        >"$out/.${view}.log" 2>&1 || { cat "$out/.${view}.log" >&2; return 1; }
    if grep -qE "WARNING|ERROR" "$out/.${view}.log"; then
        grep -E "WARNING|ERROR" "$out/.${view}.log" >&2
        return 1
    fi
    rm -f "$out/.${view}.log"
    magick "$out/${view}.png" -trim +repage -bordercolor "#f8f8f8" -border 40 "$out/${view}.png"
    echo "rendered ${view}.png"
}
export -f render
export here out size

status=0
for view in "${views[@]}"; do
    render "$view" &
    while [ "$(jobs -rp | wc -l)" -ge "$jobs" ]; do wait -n || status=1; done
done
while [ "$(jobs -rp | wc -l)" -gt 0 ]; do wait -n || status=1; done
exit "$status"
