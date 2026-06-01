------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@170",
    position = "auto",
    scale    = "1",
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "alacritty"
local fileManager = "thunar"
local menu        = "rofi -show drun -theme ~/.config/rofi/config.rasi"
local browser     = "zen"
local clip        = 'cliphist list | rofi -dmenu -display-columns 2 -p "" -theme ~/.config/rofi/config.rasi | cliphist decode | wl-copy'
local top         = "waybar"
local stats       = "btop"
local scripts     = os.getenv("HOME") .. "/.config/hypr/scripts/"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hyprctl reload")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("~/.config/hypr/scripts/wallloop.sh")
    hl.exec_cmd("flatpak run com.spotify.Client")
    
    -- Lua scripts launched as background processes
    -- hl.exec_cmd("lua " .. scripts .. "waybar_auto_toggle.lua")
    hl.exec_cmd("lua " .. scripts .. "battery_border.lua")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_THEME", "MyCursor")
hl.env("HYPRCURSOR_SIZE", "16")
hl.env("GTK_THEME", "GlassMonochrome")
hl.env("GTK2_RC_FILES", os.getenv("HOME") .. "/.themes/GlassMonochrome/gtk-2.0/gtkrc")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 10, -- from gui.conf (overrides 20)
        border_size      = 1, -- from gui.conf (overrides 2)

        col              = {
            active_border   = "rgba(ffffff00)",
            inactive_border = "rgba(00000000)",
        },

        resize_on_border = false, -- from gui.conf
        allow_tearing    = true,
        layout           = "default",
        snap             = { enabled = true }, -- from gui.conf
        hover_icon_on_border = false, -- from gui.conf
    },

    cursor = { 
        enable_hyprcursor = true, 
        no_hardware_cursors = true,
        hide_on_touch = false, -- from gui.conf
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 0,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.7,

        shadow = {
            enabled = true,
            range = 5,
            render_power = 2,
            color = "rgba(00000000)",
        },

        blur             = {
            enabled           = true,
            size              = 8,
            passes            = 4,
            vibrancy          = 0.15,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false, -- Disabled to fix movement flashing
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.window_rule({
    name      = "firefox-on-ws3",
    match     = { class = "^(firefox)$" },
    workspace = "3 silent"
})

hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        vrr = false, 
        animate_manual_resizes = false, 
        disable_splash_rendering = true, 
    },
})

hl.config({
    debug = {
        vfr = false,
    },
})

hl.config({
    input = {
        kb_layout    = "se",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        -- infamous xset r rate 200 35;
        repeat_rate  = 35,
        repeat_delay = 200,
        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad     = {
            natural_scroll = true,
            middle_button_emulation = true, -- from gui.conf
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.config({
    gestures = {
        workspace_swipe_forever = true, -- from gui.conf
        workspace_swipe_touch = true, -- from gui.conf
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local main_mod = "SUPER" -- Sets "Windows" key as main modifier

-- Helper for dispatchers not yet in the Lua API or causing issues
local function dispatch(cmd, arg)
    local command = arg and (cmd .. " " .. arg) or cmd
    return hl.dsp.exec_cmd("hyprctl dispatch " .. command)
end

-- App launch keybinds
hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(main_mod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + Z", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + SHIFT + E", hl.dsp.exec_cmd(terminal .. " -e yazi"))
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd("lua " .. scripts .. "launch_ktailctl.lua"))
-- hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("lua " .. scripts .. "flash_waybar.lua"))

-- Window control
hl.bind(main_mod .. " + W", hl.dsp.window.close())
hl.bind(main_mod .. " + SHIFT + L", hl.dsp.exit())
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", dispatch("layoutmsg", "togglesplit"))
hl.bind(main_mod .. " + Print", hl.dsp.exec_cmd("XDG_CURRENT_DESKTOP=sway flameshot gui"))
hl.bind(main_mod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(main_mod .. " + SHIFT + V", hl.dsp.exec_cmd(clip))

-- Navigation
hl.bind(main_mod .. " + Left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(main_mod .. " + Right", hl.dsp.focus({ workspace = "+1" }))
hl.bind(main_mod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + Down", hl.dsp.focus({ direction = "down" }))

-- Switch focus to monitors
hl.bind(main_mod .. " + SHIFT_R + 2", dispatch("focusmonitor", "HDMI-A-1"))

-- Switch workspaces with main_mod + [0-9]
-- Move active window to a workspace with main_mod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i == 10 and 0 or i
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(main_mod .. " + S", dispatch("togglespecialworkspace", "magic"))
hl.bind(main_mod .. " + SHIFT + S", dispatch("movetoworkspace", "special:magic"))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys (via Lua scripts)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("lua " .. scripts .. "volume.lua --inc"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("lua " .. scripts .. "volume.lua --dec"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("lua " .. scripts .. "volume.lua --toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("lua " .. scripts .. "volume.lua --toggle-mic"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("lua " .. scripts .. "brightness.lua --inc"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("lua " .. scripts .. "brightness.lua --dec"), { locked = true, repeating = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    name      = "spotify-on-music",
    match     = { class = "^(Spotify)$" },
    workspace = "special:music silent"
})

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- USER MADE / Theme specific rules
hl.workspace_rule({
    workspace = "w[t1]",
    gaps_in   = 0,
    gaps_out  = 0,
})

hl.workspace_rule({
    workspace = "f[1]",
    gaps_in   = 0,
    gaps_out  = 0,
})

hl.layer_rule({
    name         = "blur-rofi",
    match        = { namespace = "^(rofi)$" },
    blur         = true,
    ignore_alpha = 1,
})

hl.layer_rule({
    name         = "blur-swaync",
    match        = { namespace = "swaync-control-center" },
    blur         = true,
    ignore_alpha = 1,
})

hl.layer_rule({
    name         = "blur-swaync-notifications",
    match        = { namespace = "swaync-notification-window" },
    blur         = true,
    ignore_alpha = 1,
})

hl.layer_rule({
    name         = "waybar",
    match        = { namespace = "waybar" },
    blur         = true,
    ignore_alpha = 0.5,
})

hl.window_rule({
    name    = "dolphin-opacity",
    match   = { class = "^(dolphin)$" },
    opacity = "0.85 0.75",
})

-- SwayNC Toggle
hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
