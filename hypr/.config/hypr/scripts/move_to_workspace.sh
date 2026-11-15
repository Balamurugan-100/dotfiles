#!/usr/bin/env bash
# move_to_workspace.sh [next|prev]
dir="${1:-next}"

active=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // 1')
if [[ -z "$active" || "$active" == "null" ]]; then active=1; fi

mapfile -t occupied < <(hyprctl workspaces -j 2>/dev/null | jq -r '.[] | select(.windows > 0 and .id > 0) | .id' | sort -n)

if [[ ${#occupied[@]} -eq 0 ]]; then
    max=1
    min=1
else
    min=${occupied[0]}
    max=${occupied[-1]}
fi

if [[ "$dir" == "next" ]]; then
    if (( active >= max + 1 )); then
        target=$min
    else
        target=$(( active + 1 ))
    fi
else
    if (( active <= min )); then
        target=$(( max + 1 ))
    else
        target=$(( active - 1 ))
    fi
fi

hyprctl dispatch "hl.dsp.window.move({ workspace = $target })" >/dev/null
hyprctl dispatch "hl.dsp.focus({ workspace = $target })" >/dev/null
