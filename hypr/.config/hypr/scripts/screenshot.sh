#!/usr/bin/env bash
# ====================================================================
# Minimal Screenshot Script for Hyprland
# Supports area selection and full screen captures
# Automatically copies to clipboard and saves to ~/Pictures/Screenshots
# ====================================================================

set -euo pipefail

SAVE_DIR="${HOME}/Pictures/Screenshots"
mkdir -p "${SAVE_DIR}"

TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
FILENAME="${SAVE_DIR}/Screenshot_${TIMESTAMP}.png"

MODE="${1:---area}"

if [[ "${MODE}" == "--area" ]]; then
    GEOM=$(slurp 2>/dev/null) || exit 0
    grim -g "${GEOM}" "${FILENAME}"
elif [[ "${MODE}" == "--full" ]]; then
    sleep 0.2
    grim "${FILENAME}"
else
    echo "Usage: $0 [--area|--full]"
    exit 1
fi

if [[ -f "${FILENAME}" ]]; then
    wl-copy < "${FILENAME}"
    notify-send -a "Screenshot" -i "${FILENAME}" "Screenshot Captured" "Saved to ${FILENAME} and copied to clipboard."
fi
