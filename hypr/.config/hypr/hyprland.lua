-- ====================================================================
-- Hyprland Lua Master Configuration
-- Clean, minimal, snappy keyboard-driven configuration
-- ====================================================================

-- ── Monitors ────────────────────────────────────────────────────────
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "auto",
    scale    = 1.0,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.0,
})

-- ── Environment Variables ──────────────────────────────────────────
local home = os.getenv("HOME") or "/home/kaizen"
hl.env("PATH", home .. "/.local/bin:" .. (os.getenv("PATH") or ""))

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Default Editors
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "zed")

-- ── Look and Feel ──────────────────────────────────────────────────
hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 3,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(89b4faff)", "rgba(cba6f7ff)"}, angle = 45 },
            inactive_border = "rgba(313244aa)",
        },
        resize_on_border = true,
        allow_tearing = true,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_layout = "us",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        follow_mouse = 1,
        sensitivity = 0.0,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            tap_to_click = true,
            scroll_factor = 0.4,
        },
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        vrr = 1,
        initial_workspace_tracking = 0,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },
})

-- ── Ultra-Fast & Snappy Animations ─────────────────────────────────
hl.curve("md3_decel",  { type = "bezier", points = { {0.05, 0.7}, {0.1, 1.0} } })
hl.curve("md3_accel",  { type = "bezier", points = { {0.3, 0.0}, {0.8, 0.15} } })
hl.curve("menu_decel", { type = "bezier", points = { {0.1, 1.0}, {0.0, 1.0} } })

hl.animation({ leaf = "global",     enabled = true,  speed = 3.0, bezier = "md3_decel" })
hl.animation({ leaf = "windows",    enabled = true,  speed = 3.0, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsIn",  enabled = true,  speed = 3.0, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true,  speed = 3.0, bezier = "md3_accel", style = "popin 60%" })
hl.animation({ leaf = "border",     enabled = true,  speed = 10.0, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true,  speed = 3.0, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces", enabled = true,  speed = 5.0, bezier = "menu_decel", style = "slide" })

-- ── Native Hyprland Autostart ────────────────────────────────────────
-- Run autostart.sh once per Hyprland instance (equivalent to exec-once).
-- Note: hl.on("hyprland.start", ...) is NOT emitted by Hyprland 0.57.x,
-- so we launch directly with an instance guard.
local sig = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
local runtime = os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. (os.getenv("UID") or "1000"))
local autostart_lock = runtime .. "/hypr/" .. (sig or "default") .. "/.autostart_completed"

local lock_fd = io.open(autostart_lock, "r")
if not lock_fd then
    hl.exec_cmd(home .. "/.config/hypr/scripts/autostart.sh")
else
    lock_fd:close()
end

-- ── Applications & Native Vicinae Tools ─────────────────────────────
local mainMod = "SUPER"

local terminal     = "kitty"
local browser      = home .. "/.local/bin/zen"
local filemanager  = "nautilus"
local filemgr_cli  = "kitty -e yazi"
local editor_gui   = "zed"
local editor_cli   = "kitty -e nvim"
local ai_agent     = "kitty -e opencode"

local launcher     = "vicinae toggle"
local clipboard    = "vicinae cmd launch clipboard:history"
local emoji_picker = "vicinae cmd launch core:search-emojis"
local file_search  = "vicinae cmd launch files:search"
local win_switcher = "vicinae cmd launch wm:switch-windows"
local nightlight   = home .. "/.config/hypr/scripts/toggle_nightlight.sh"
local wayle_toggle = home .. "/.local/bin/wayle panel toggle"

-- Applications Binds
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd(emoji_picker))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(win_switcher))
hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd(win_switcher))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(file_search))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(filemanager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(filemgr_cli))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(editor_gui))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor_cli))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(ai_agent))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd(nightlight))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(home .. "/.local/bin/wayle-settings"))

-- Topbar Menubar Toggle (Super + Shift + B)
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(wayle_toggle))

-- Window Management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- Config Reload (Super + Shift + R)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload && notify-send -a 'Hyprland' 'Config Reloaded' 'hyprland.lua applied successfully.'"))

-- Lock Screen (Super + Control + Shift + L)
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- ── COSMIC-Style Smart Window & Workspace Switching ────────────────
-- If 1 window per screen, switches directly between app screens / workspaces!
-- Visits max_occupied + 1 (first empty workspace) before wrapping to 1!
local switch_ws = home .. "/.config/hypr/scripts/switch_workspace.sh"
local move_ws   = home .. "/.config/hypr/scripts/move_to_workspace.sh"

local function smart_switch(direction, cycle_prev)
    local ws = hl.get_active_workspace()
    local wins = hl.get_workspace_windows(ws)

    -- Single app on screen: switch to next/prev screen/workspace immediately
    if #wins <= 1 then
        if cycle_prev then
            hl.dispatch(hl.dsp.exec_cmd(switch_ws .. " prev"))
        else
            hl.dispatch(hl.dsp.exec_cmd(switch_ws .. " next"))
        end
        return
    end

    -- Multiple windows: try directional focus first
    local before = hl.get_window("active")
    hl.dispatch(hl.dsp.focus({ direction = direction }))
    local after = hl.get_window("active")

    -- Hit the edge/boundary of windows on screen: switch to next/prev screen!
    if not before or not after or before == after then
        if cycle_prev then
            hl.dispatch(hl.dsp.exec_cmd(switch_ws .. " prev"))
        else
            hl.dispatch(hl.dsp.exec_cmd(switch_ws .. " next"))
        end
    end
end

local function smart_move(direction, cycle_prev)
    local ws = hl.get_active_workspace()
    local wins = hl.get_workspace_windows(ws)

    if #wins <= 1 then
        if cycle_prev then
            hl.dispatch(hl.dsp.exec_cmd(move_ws .. " prev"))
        else
            hl.dispatch(hl.dsp.exec_cmd(move_ws .. " next"))
        end
        return
    end

    local before = hl.get_window("active")
    hl.dispatch(hl.dsp.window.move({ direction = direction }))
    local after = hl.get_window("active")
    if not before or not after or before == after then
        if cycle_prev then
            hl.dispatch(hl.dsp.exec_cmd(move_ws .. " prev"))
        else
            hl.dispatch(hl.dsp.exec_cmd(move_ws .. " next"))
        end
    end
end

-- Window / Screen Switching (Super + H/L/K/J)
hl.bind(mainMod .. " + H", function() smart_switch("left", true) end)
hl.bind(mainMod .. " + L", function() smart_switch("right", false) end)
hl.bind(mainMod .. " + K", function() smart_switch("up", true) end)
hl.bind(mainMod .. " + J", function() smart_switch("down", false) end)

-- Move Window across Positions / Screens (Super + Shift + H/L/K/J)
hl.bind(mainMod .. " + SHIFT + H", function() smart_move("left", true) end)
hl.bind(mainMod .. " + SHIFT + L", function() smart_move("right", false) end)
hl.bind(mainMod .. " + SHIFT + K", function() smart_move("up", true) end)
hl.bind(mainMod .. " + SHIFT + J", function() smart_move("down", false) end)

-- Fallback Arrow Keys Navigation
hl.bind(mainMod .. " + left",  function() smart_switch("left", true) end)
hl.bind(mainMod .. " + right", function() smart_switch("right", false) end)
hl.bind(mainMod .. " + up",    function() smart_switch("up", true) end)
hl.bind(mainMod .. " + down",  function() smart_switch("down", false) end)

hl.bind(mainMod .. " + SHIFT + left",  function() smart_move("left", true) end)
hl.bind(mainMod .. " + SHIFT + right", function() smart_move("right", false) end)
hl.bind(mainMod .. " + SHIFT + up",    function() smart_move("up", true) end)
hl.bind(mainMod .. " + SHIFT + down",  function() smart_move("down", false) end)

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Workspace Mouse Scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mouse Drag and Resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/screenshot.sh --area"))
hl.bind("Print", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/screenshot.sh --full"))

-- Audio & Brightness Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set 5%+"),                          { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),                          { locked = true, repeating = true })

-- ── Window & Layer Rules ───────────────────────────────────────────
hl.window_rule({
    name  = "float-utils",
    match = { class = "^(pavucontrol|blueman-manager|nm-connection-editor|org.gnome.Calculator|com.wayle.settings|wayle-settings)$" },
    float = true,
    center = true,
})

hl.window_rule({
    name  = "zen-pip",
    match = { class = "^(zen)$", title = "^(Picture-in-Picture)$" },
    float = true,
    pin   = true,
})

hl.window_rule({
    name  = "vicinae-launcher",
    match = { class = "^(vicinae)$" },
    float = true,
    center = true,
})

-- ── Layer Rules ────────────────────────────────────────────────────
hl.layer_rule({
    name  = "blur-wayle",
    match = { namespace = "^wayle.*$" },
    blur  = true,
})

hl.layer_rule({
    name  = "blur-vicinae",
    match = { namespace = "^vicinae.*$" },
    blur  = true,
})
