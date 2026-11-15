#!/usr/bin/env bash
# ====================================================================
# Hyprland Desktop Autostart Script
# Starts and manages background desktop daemons cleanly without duplicates
# ====================================================================

# 1. Polkit Authentication Agent
if ! pgrep -f "hyprpolkitagent|polkit-gnome" >/dev/null; then
    /usr/libexec/hyprpolkitagent 2>/dev/null || /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 2>/dev/null &
fi

# 2. Hyprpaper Wallpaper Daemon
if ! pgrep -x "hyprpaper" >/dev/null; then
    hyprpaper &
fi

# 3. Wayle Desktop Shell (Topbar & OSD)
if ! pgrep -f "wayle shell" >/dev/null; then
    wayle shell &
fi

# 4. Hypridle Screen Idle & Lock Daemon
if ! pgrep -x "hypridle" >/dev/null; then
    hypridle &
fi

# 5. Vicinae Launcher & Clipboard Daemon
systemctl --user start vicinae.service 2>/dev/null || vicinae server &

# 6. Wayland Clipboard History Watchers
if ! pgrep -f "wl-paste --type text --watch cliphist" >/dev/null; then
    wl-paste --type text --watch cliphist store &
fi
if ! pgrep -f "wl-paste --type image --watch cliphist store" >/dev/null; then
    wl-paste --type image --watch cliphist store &
fi
