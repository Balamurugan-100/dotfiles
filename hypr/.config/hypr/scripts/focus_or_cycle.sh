#!/usr/bin/env bash
# ====================================================================
# COSMIC-style Smart Window Focus & Move for Hyprland
# Moves focus/window directionally; if at the boundary (last window),
# it smoothly wraps around and cycles/switches windows!
# ====================================================================

set -euo pipefail

DIR="${1:-r}"       # l, r, u, d (or h, j, k, l, left, right, up, down)
ACTION="${2:-focus}" # focus or move

# Normalize direction
case "${DIR,,}" in
    l|h|left)
        HYPR_DIR="l"
        CYCLE_DIR="prev"
        ;;
    r|l_right|right)
        HYPR_DIR="r"
        CYCLE_DIR=""
        ;;
    u|k|up)
        HYPR_DIR="u"
        CYCLE_DIR="prev"
        ;;
    d|j|down)
        HYPR_DIR="d"
        CYCLE_DIR=""
        ;;
    *)
        HYPR_DIR="r"
        CYCLE_DIR=""
        ;;
esac

# Check active window before operation
ACTIVE_INFO=$(hyprctl activewindow -j 2>/dev/null || echo "{}")
ACTIVE_ADDR=$(echo "${ACTIVE_INFO}" | jq -r '.address // empty' 2>/dev/null || true)

# If no active window, cycle immediately
if [[ -z "${ACTIVE_ADDR}" || "${ACTIVE_ADDR}" == "null" ]]; then
    if [[ -n "${CYCLE_DIR}" ]]; then
        hyprctl dispatch cyclenext prev 2>/dev/null || true
    else
        hyprctl dispatch cyclenext 2>/dev/null || true
    fi
    exit 0
fi

if [[ "${ACTION}" == "move" ]]; then
    POS_BEFORE=$(echo "${ACTIVE_INFO}" | jq -r '(.at // []) | join(",")' 2>/dev/null || true)
    hyprctl dispatch movewindow "${HYPR_DIR}" 2>/dev/null || true
    POS_AFTER=$(hyprctl activewindow -j 2>/dev/null | jq -r '(.at // []) | join(",")' 2>/dev/null || true)

    # If position didn't change, we reached the boundary -> swap wrap around
    if [[ "${POS_BEFORE}" == "${POS_AFTER}" ]]; then
        if [[ -n "${CYCLE_DIR}" ]]; then
            hyprctl dispatch swapnext prev 2>/dev/null || true
        else
            hyprctl dispatch swapnext 2>/dev/null || true
        fi
    fi
else
    # Focus action
    hyprctl dispatch movefocus "${HYPR_DIR}" 2>/dev/null || true
    ACTIVE_AFTER=$(hyprctl activewindow -j 2>/dev/null | jq -r '.address // empty' 2>/dev/null || true)

    # If active window didn't change, we reached the boundary (last window) -> cycle wrap around
    if [[ "${ACTIVE_ADDR}" == "${ACTIVE_AFTER}" ]]; then
        if [[ -n "${CYCLE_DIR}" ]]; then
            hyprctl dispatch cyclenext prev 2>/dev/null || true
        else
            hyprctl dispatch cyclenext 2>/dev/null || true
        fi
    fi
fi
