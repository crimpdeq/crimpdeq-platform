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

all_views="overview plate1 plate2 join_base anchor_in case_in clips_in lug_section
rest_on position_min position_max stoppers phone"

# view -> "rx,ry,rz" (auto-framed) or "tx,ty,tz,rx,ry,rz,distance"
camera() {
    case "$1" in
        overview | position_min | position_max) echo "58,0,28" ;;
        join_base | anchor_in | rest_on) echo "58,0,32" ;;
        case_in | clips_in) echo "55,0,25" ;;
        phone) echo "68,0,62" ;;
        stoppers) echo "50,0,20" ;;
        plate1 | plate2 | lug_section) echo "0,0,0" ;;
        *) echo "Unknown view: $1" >&2; return 1 ;;
    esac
}

# macOS ships bash 3.2, which lacks `wait -n` (bash 4.3+); poll instead.
wait_for_any_job() {
    if (( BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 3) )); then
        wait -n
    else
        sleep 0.2
    fi
}

views=("$@")
if [ "${#views[@]}" -eq 0 ]; then
    read -r -a views <<<"$(echo $all_views)"
fi

render() {
    local view="$1" cam framing scheme tag
    cam="$(camera "$view")" || return 1
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
status=0
pids=()
for view in "${views[@]}"; do
    render "$view" &
    pids+=("$!")
    while [ "$(jobs -rp | wc -l)" -ge "$jobs" ]; do wait_for_any_job || true; done
done
for pid in "${pids[@]}"; do
    wait "$pid" || status=1
done
exit "$status"
