#!/usr/bin/env bash
# Hyprland Desktop Autostart
set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:/usr/local/bin:$PATH"

# 0. Wait for the Hyprland IPC socket to accept connections
# (hyprpaper aborts at startup if it can't reach the compositor socket yet)
for _ in $(seq 1 50); do
    hyprctl version >/dev/null 2>&1 && break
    sleep 0.1
done

# 1. Import session environment
dbus-update-activation-environment \
    --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE PATH

# 2. Desktop portals (non-blocking)
systemctl --user start --no-block \
    xdg-desktop-portal-hyprland.service \
    xdg-desktop-portal.service \
    2>/dev/null || true

# 2b. Kill stale daemons left over from a previous Hyprland session.
# Without this, the pgrep guards below can match an orphan from the old
# session and skip starting a fresh instance for THIS session (no
# wallpaper, no topbar, no idle daemon). SIGTERM first, then SIGKILL any
# stragglers (unloading a large wallpaper can be slow) so a dying process
# can never satisfy the pgrep guards below.
pkill -x hyprpaper 2>/dev/null || true
pkill -x hypridle 2>/dev/null || true
pkill -x hyprpolkitagent 2>/dev/null || true
pkill -x wayle 2>/dev/null || true
pkill -f 'wl-paste --type text --watch cliphist store' 2>/dev/null || true
pkill -f 'wl-paste --type image --watch cliphist store' 2>/dev/null || true
sleep 0.3
pkill -9 -x hyprpaper 2>/dev/null || true
pkill -9 -x hypridle 2>/dev/null || true
pkill -9 -x hyprpolkitagent 2>/dev/null || true
pkill -9 -x wayle 2>/dev/null || true
pkill -9 -f 'wl-paste --type text --watch cliphist store' 2>/dev/null || true
pkill -9 -f 'wl-paste --type image --watch cliphist store' 2>/dev/null || true
sleep 0.3

# 3. Authentication agent
if [[ -x /usr/libexec/hyprpolkitagent ]]; then
    /usr/libexec/hyprpolkitagent &
elif [[ -x /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]]; then
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
fi

# 4. Wallpaper
if ! pgrep -x hyprpaper >/dev/null; then
    hyprpaper >"${XDG_CACHE_HOME:-$HOME/.cache}/hyprpaper.log" 2>&1 &
fi

# 5. Wayle desktop shell
if ! pgrep -f 'wayle shell' >/dev/null; then
    wayle shell >"${XDG_CACHE_HOME:-$HOME/.cache}/wayle.log" 2>&1 &
fi

# 6. Idle daemon
if ! pgrep -x hypridle >/dev/null; then
    hypridle >/dev/null 2>&1 &
fi

# 7. Clipboard history
if ! pgrep -f '[w]l-paste --type text --watch cliphist store' >/dev/null; then
    wl-paste --type text --watch cliphist store >/dev/null 2>&1 &
fi

if ! pgrep -f '[w]l-paste --type image --watch cliphist store' >/dev/null; then
    wl-paste --type image --watch cliphist store >/dev/null 2>&1 &
fi

# 8. Vicinae (systemd service preferred, direct fallback otherwise)
if ! systemctl --user start --no-block vicinae.service 2>/dev/null; then
    if ! pgrep -x vicinae-server >/dev/null 2>&1; then
        vicinae server >/dev/null 2>&1 &
    fi
fi
