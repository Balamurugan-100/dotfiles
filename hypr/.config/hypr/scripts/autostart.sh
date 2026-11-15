#!/usr/bin/env bash
# ====================================================================
# Hyprland / Desktop Autostart Script
# Starts and manages desktop daemons cleanly across session restarts
# ====================================================================

# Ensure user binaries and mise shims are in PATH
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# Import current Wayland session environment to D-Bus and systemd user session
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH 2>/dev/null
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH 2>/dev/null

# Clean up stale session daemons from previous/dead compositor sessions
killall -9 hyprpaper 2>/dev/null
killall -9 wayle 2>/dev/null
killall -9 hypridle 2>/dev/null

# 1. Polkit Authentication Agent
if ! pgrep -f "hyprpolkitagent|polkit-gnome" >/dev/null; then
    (/usr/libexec/hyprpolkitagent 2>/dev/null || /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 2>/dev/null) >/dev/null 2>&1 &
fi

# 2. Hyprpaper Wallpaper Daemon
hyprpaper >/dev/null 2>&1 &

# 3. Wayle Desktop Shell (Topbar & OSD)
wayle shell >/dev/null 2>&1 &

# 4. Hypridle Screen Idle & Lock Daemon
hypridle >/dev/null 2>&1 &

# 5. Vicinae Launcher & Clipboard Daemon (Restart for current WAYLAND_DISPLAY)
(systemctl --user restart vicinae.service 2>/dev/null || vicinae server >/dev/null 2>&1) &

# 6. Wayland Clipboard History Watchers
if ! pgrep -f "wl-paste --type text --watch cliphist" >/dev/null; then
    wl-paste --type text --watch cliphist store >/dev/null 2>&1 &
fi
if ! pgrep -f "wl-paste --type image --watch cliphist store" >/dev/null; then
    wl-paste --type image --watch cliphist store >/dev/null 2>&1 &
fi
