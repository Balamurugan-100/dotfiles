#!/usr/bin/env bash
# ====================================================================
# Toggle Hyprsunset (Night Light / Blue Light Filter)
# ====================================================================

if pgrep -x "hyprsunset" >/dev/null; then
    pkill -x "hyprsunset"
    notify-send -a "Night Light" -u low "Night Light Disabled" "Color temperature restored to normal."
else
    hyprsunset -t 4500 &
    notify-send -a "Night Light" -u low "Night Light Enabled" "Color temperature set to warm 4500K."
fi
