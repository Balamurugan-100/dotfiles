#!/usr/bin/env bash
# Hyprland Desktop Autostart
set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:/usr/local/bin:$PATH"

# Prevent running multiple times within the same Hyprland instance (e.g. on reload)
INSTANCE_SIGNATURE="${HYPRLAND_INSTANCE_SIGNATURE:-default}"
LOCK_FILE="${XDG_RUNTIME_DIR:-/run/user/$UID}/hypr/${INSTANCE_SIGNATURE}/.autostart_completed"

if [[ -f "$LOCK_FILE" ]]; then
    exit 0
fi
mkdir -p "$(dirname "$LOCK_FILE")"
touch "$LOCK_FILE"

# 0. Wait for the Hyprland IPC socket to accept connections
# (hyprpaper aborts at startup if it can't reach the compositor socket yet)
for _ in $(seq 1 50); do
    hyprctl version >/dev/null 2>&1 && break
    sleep 0.1
done

# 1. Import session environment
dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE PATH 2>/dev/null || true
systemctl --user import-environment \
    WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE PATH 2>/dev/null || true

# 2. Desktop portals (non-blocking)
systemctl --user start --no-block \
    xdg-desktop-portal-hyprland.service \
    xdg-desktop-portal.service \
    2>/dev/null || true

# 2b. Clean up any stale orphan daemons left over from a previous session.
pkill -x hyprpaper 2>/dev/null || true
pkill -x hypridle 2>/dev/null || true
pkill -x hyprpolkitagent 2>/dev/null || true
pkill -x wayle 2>/dev/null || true
pkill -f 'wl-paste --type text --watch cliphist store' 2>/dev/null || true
pkill -f 'wl-paste --type image --watch cliphist store' 2>/dev/null || true
sleep 0.2
pkill -9 -x hyprpaper 2>/dev/null || true
pkill -9 -x hypridle 2>/dev/null || true
pkill -9 -x hyprpolkitagent 2>/dev/null || true
pkill -9 -x wayle 2>/dev/null || true
pkill -9 -f 'wl-paste --type text --watch cliphist store' 2>/dev/null || true
pkill -9 -f 'wl-paste --type image --watch cliphist store' 2>/dev/null || true

# 3. Authentication agent
if ! pgrep -x hyprpolkitagent >/dev/null; then
    if [[ -x /usr/libexec/hyprpolkitagent ]]; then
        /usr/libexec/hyprpolkitagent >/dev/null 2>&1 &
    elif [[ -x /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]]; then
        /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &
    fi
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

disown -a 2>/dev/null || true
