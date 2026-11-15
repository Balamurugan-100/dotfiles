-- ====================================================================
-- Hyprland Lua Master Configuration
-- Clean, minimal, snappy keyboard-driven configuration
-- ====================================================================

-- ── Monitors ────────────────────────────────────────────────────────
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- ── Environment Variables ──────────────────────────────────────────
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- NVIDIA & Hybrid GPU Optimizations
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

-- Cursor Settings
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Default Editors
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "zed")

-- ── Look and Feel ──────────────────────────────────────────────────
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(89b4faff)", "rgba(cba6f7ff)"}, angle = 45 },
            inactive_border = "rgba(313244aa)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = 0x6611111b,
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            vibrancy = 0.1696,
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
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        vrr = 1,
    },
})

-- ── Snappy Animations ──────────────────────────────────────────────
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })

hl.animation({ leaf = "global",     enabled = true,  speed = 4.0, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",    enabled = true,  speed = 2.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",  enabled = true,  speed = 2.2, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true,  speed = 1.8, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "border",     enabled = true,  speed = 2.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade",       enabled = true,  speed = 2.0, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true,  speed = 2.5, bezier = "easeOutQuint", style = "slide" })

-- ── Autostart ──────────────────────────────────────────────────────
hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/autostart.sh")

-- ── Applications & Native Vicinae Tools ─────────────────────────────
local mainMod = "SUPER"

local terminal     = "kitty"
local browser      = "zen"
local filemanager  = "nautilus"
local filemgr_cli  = "kitty -e yazi"
local editor_gui   = "zed"
local editor_cli   = "kitty -e nvim"

local launcher     = "vicinae toggle"
local clipboard    = "vicinae cmd launch clipboard:history"
local win_switcher = "vicinae cmd launch wm:switch-windows"
local emoji_picker = "vicinae cmd launch core:search-emojis"
local file_search  = "vicinae cmd launch files:search"
local nightlight   = os.getenv("HOME") .. "/.config/hypr/scripts/toggle_nightlight.sh"

-- Applications Binds
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd(emoji_picker))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(win_switcher))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(file_search))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(filemanager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(filemgr_cli))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(editor_gui))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor_cli))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd(nightlight))

-- Topbar Menubar Toggle (Mac-style show/hide)
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd("wayle panel toggle"))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd("wayle panel toggle"))

-- Window Management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- Lock Screen (Super + Control + Shift + L)
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- ── COSMIC-Style Smart Navigation (Directional + Edge Wrap) ────────
local function smart_focus(direction, cycle_prev)
    local before = hl.get_window("active")
    hl.dispatch(hl.dsp.focus({ direction = direction }))
    local after = hl.get_window("active")
    if not before or not after or before == after then
        hl.dispatch(hl.dsp.window.cycle_next({ prev = cycle_prev }))
    end
end

local function smart_move(direction)
    local before = hl.get_window("active")
    hl.dispatch(hl.dsp.window.move({ direction = direction }))
    local after = hl.get_window("active")
    if not before or not after or before == after then
        hl.dispatch(hl.dsp.window.swap({ direction = direction }))
    end
end

-- Focus navigation (Super + H/L/K/J)
hl.bind(mainMod .. " + H", function() smart_focus("left", true) end)
hl.bind(mainMod .. " + L", function() smart_focus("right", false) end)
hl.bind(mainMod .. " + K", function() smart_focus("up", true) end)
hl.bind(mainMod .. " + J", function() smart_focus("down", false) end)

-- Move window (Super + Shift + H/L/K/J)
hl.bind(mainMod .. " + SHIFT + H", function() smart_move("left") end)
hl.bind(mainMod .. " + SHIFT + L", function() smart_move("right") end)
hl.bind(mainMod .. " + SHIFT + K", function() smart_move("up") end)
hl.bind(mainMod .. " + SHIFT + J", function() smart_move("down") end)

-- Fallback Arrow Keys Navigation
hl.bind(mainMod .. " + left",  function() smart_focus("left", true) end)
hl.bind(mainMod .. " + right", function() smart_focus("right", false) end)
hl.bind(mainMod .. " + up",    function() smart_focus("up", true) end)
hl.bind(mainMod .. " + down",  function() smart_focus("down", false) end)

hl.bind(mainMod .. " + SHIFT + left",  function() smart_move("left") end)
hl.bind(mainMod .. " + SHIFT + right", function() smart_move("right") end)
hl.bind(mainMod .. " + SHIFT + up",    function() smart_move("up") end)
hl.bind(mainMod .. " + SHIFT + down",  function() smart_move("down") end)

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
    match = { class = "^(pavucontrol|blueman-manager|nm-connection-editor|org.gnome.Calculator|wayle-settings)$" },
    float = true,
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
