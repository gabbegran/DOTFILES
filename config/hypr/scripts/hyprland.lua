-- ============================================================
--  hyprland.lua  –  Main Hyprland configuration
--  Converted from hyprland.conf to Hyprland Lua API
-- ============================================================

local hypr  = require("hyprland")
local cfg   = hypr.config      -- set a keyword
local exec  = hypr.exec_once
local bind  = hypr.bind
local bindel = hypr.bindel
local bindm = hypr.bindm

-- Script root (all Lua scripts live here)
local SCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts/"

-- ============================================================
-- PROGRAMS
-- ============================================================
local terminal    = "alacritty"
local fileManager = "thunar"
local menu        = "rofi -show drun -theme ~/.config/rofi/config.rasi"
local clip        = "cliphist list | rofi -dmenu -display-columns 2 -p '' -theme ~/.config/rofi/config.rasi | cliphist decode | wl-copy"
local browser     = "zen"
local mainMod     = "SUPER"

-- ============================================================
-- MONITORS
-- ============================================================
hypr.env("WLR_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")

hypr.monitor("eDP-1",    "1920x1080@60",  "0x0",  1)
hypr.monitor("DP-1",     "2560x1440@170", "auto", 1)
hypr.monitor("HDMI-A-1", "1920x1080@120", "auto", 1)
hypr.monitor("",         "preferred",     "auto", 1)   -- fallback

-- ============================================================
-- ENVIRONMENT VARIABLES
-- ============================================================
hypr.env("HYPRCURSOR_THEME",                 "MyCursor")
hypr.env("HYPRCURSOR_SIZE",                  "16")
hypr.env("QT_QPA_PLATFORM",                  "wayland;xcb")
hypr.env("QT_QPA_PLATFORMTHEME",             "kde")
hypr.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hypr.env("GTK_THEME",                        "GlassMonochrome")
hypr.env("GTK2_RC_FILES",                    os.getenv("HOME") .. "/.themes/GlassMonochrome/gtk-2.0/gtkrc")

-- ============================================================
-- AUTOSTART
-- ============================================================
exec("waybar")
exec("nm-applet --indicator")
exec("hyprpaper")
exec("dunst")
exec("wl-paste --type text  --watch cliphist store")
exec("wl-paste --type image --watch cliphist store")

-- Lua scripts launched as background processes
exec("lua " .. SCRIPTS .. "waybar_auto_toggle.lua")
exec("lua " .. SCRIPTS .. "battery_border.lua")

-- ============================================================
-- GENERAL
-- ============================================================
cfg("general:gaps_in",              5)
cfg("general:gaps_out",             5)           -- from gui.conf (overrides 20)
cfg("general:border_size",          3)           -- from gui.conf
cfg("general:col.active_border",    "rgba(00000000)")
cfg("general:col.inactive_border",  "rgba(00000000)")
cfg("general:resize_on_border",     false)       -- gui.conf: 0
cfg("general:allow_tearing",        true)
cfg("general:layout",               "dwindle")
cfg("general:hover_icon_on_border", false)

-- Snap (gui.conf)
cfg("general:snap:enabled", true)

-- ============================================================
-- DECORATION
-- ============================================================
cfg("decoration:rounding",           10)
cfg("decoration:rounding_power",     2)
cfg("decoration:active_opacity",     1.0)
cfg("decoration:inactive_opacity",   0.7)

-- Shadow
cfg("decoration:shadow:enabled",      false)
cfg("decoration:shadow:range",        4)
cfg("decoration:shadow:render_power", 3)
cfg("decoration:shadow:color",        "rgba(1a1a1aee)")

-- Blur
cfg("decoration:blur:enabled",           true)
cfg("decoration:blur:size",              10)    -- gui.conf: 10
cfg("decoration:blur:passes",            3)
cfg("decoration:blur:vibrancy",          0.15)
cfg("decoration:blur:new_optimizations", true)
cfg("decoration:blur:ignore_opacity",    true)
cfg("decoration:blur:xray",             true)   -- gui.conf

-- ============================================================
-- ANIMATIONS
-- ============================================================
cfg("animations:enabled", true)

-- Bezier curves
hypr.bezier("easeOutQuint",   0.23, 1,    0.32, 1)
hypr.bezier("easeInOutCubic", 0.65, 0.05, 0.36, 1)
hypr.bezier("linear",         0,    0,    1,    1)
hypr.bezier("almostLinear",   0.5,  0.5,  0.75, 1)
hypr.bezier("quick",          0.15, 0,    0.1,  1)

-- Animations
hypr.animation("global",        true, 10,   "default")
hypr.animation("border",        true, 5.39, "easeOutQuint")
hypr.animation("windows",       true, 4.79, "easeOutQuint")
hypr.animation("windowsIn",     true, 4.1,  "easeOutQuint", "popin 87%")
hypr.animation("windowsOut",    true, 1.49, "linear",       "popin 87%")
hypr.animation("fadeIn",        true, 1.73, "almostLinear")
hypr.animation("fadeOut",       true, 1.46, "almostLinear")
hypr.animation("fade",          true, 3.03, "quick")
hypr.animation("layers",        true, 3.81, "easeOutQuint")
hypr.animation("layersIn",      true, 4,    "easeOutQuint",  "fade")
hypr.animation("layersOut",     true, 1.5,  "linear",        "fade")
hypr.animation("fadeLayersIn",  true, 1.79, "almostLinear")
hypr.animation("fadeLayersOut", true, 1.39, "almostLinear")
hypr.animation("workspaces",    true, 1.94, "almostLinear",  "fade")
hypr.animation("workspacesIn",  true, 1.21, "almostLinear",  "fade")
hypr.animation("workspacesOut", true, 1.94, "almostLinear",  "fade")
hypr.animation("zoomFactor",    true, 7,    "quick")

-- ============================================================
-- LAYOUT
-- ============================================================
cfg("dwindle:preserve_split", true)

cfg("master:new_status", "master")

-- ============================================================
-- MISC / DEBUG
-- ============================================================
cfg("misc:force_default_wallpaper",  0)
cfg("misc:disable_hyprland_logo",    true)
cfg("debug:vfr",                     true)
cfg("misc:vrr",                      true)    -- gui.conf: 1
cfg("misc:animate_manual_resizes",   true)    -- gui.conf
cfg("misc:disable_splash_rendering", true)    -- gui.conf

-- ============================================================
-- INPUT
-- ============================================================
cfg("input:kb_layout",  "se")
cfg("input:follow_mouse", 1)
cfg("input:sensitivity",  0)
cfg("input:touchpad:natural_scroll",          true)
cfg("input:touchpad:middle_button_emulation", true)  -- gui.conf

cfg("cursor:hide_on_touch", false)  -- gui.conf

-- Gestures
hypr.gesture(3, "horizontal", "workspace")
cfg("gestures:workspace_swipe_forever", true)  -- gui.conf
cfg("gestures:workspace_swipe_touch",   true)  -- gui.conf

-- Per-device
hypr.device("epic-mouse-v1", { sensitivity = -0.5 })

-- ============================================================
-- WORKSPACE RULES  (smart gaps)
-- ============================================================
hypr.workspace("w[t1]", { gapsout = 0, gapsin = 0 })
hypr.workspace("f[1]",  { gapsout = 0, gapsin = 0 })

-- ============================================================
-- WINDOW / LAYER RULES
-- ============================================================
hypr.layerrule("blur",               "namespace:^(rofi)$")
hypr.layerrule("ignorealpha 1",      "namespace:^(rofi)$")

hypr.windowrule("opacity 0.85 0.75", "class:^(dolphin)$")

-- ============================================================
-- KEYBINDINGS  –  App launchers
-- ============================================================
bind(mainMod,           "return", "exec",    terminal)
bind(mainMod,           "E",      "exec",    fileManager)
bind(mainMod,           "space",  "exec",    menu)
bind(mainMod,           "Z",      "exec",    browser)
bind(mainMod .. " SHIFT", "E",   "exec",    terminal .. " -e yazi")

-- KTailctl (uses its own Lua launcher so float/resize/center is handled)
bind(mainMod, "T", "exec", "lua " .. SCRIPTS .. "launch_ktailctl.lua")

-- ============================================================
-- KEYBINDINGS  –  Window control
-- ============================================================
bind(mainMod,           "W",     "killactive",         "")
bind(mainMod .. " SHIFT", "L",  "exec",               "hyprctl dispatch exit")
bind(mainMod .. " SHIFT", "F",  "togglefloating",     "")
bind(mainMod,           "F",    "fullscreen",          "")
bind(mainMod,           "P",    "pseudo",              "")
bind(mainMod,           "J",    "layoutmsg",         "togglesplit")
bind(mainMod,           "Print","exec",                "hyprshot -m region --clipboard-only")
bind(mainMod .. " SHIFT", "V",  "exec",               clip)

-- ============================================================
-- KEYBINDINGS  –  Navigation
-- ============================================================
bind(mainMod, "left",  "workspace", "-1")
bind(mainMod, "right", "workspace", "+1")
bind(mainMod, "up",    "movefocus", "u")
bind(mainMod, "down",  "movefocus", "d")

for i = 1, 9 do
    bind(mainMod,           tostring(i), "workspace",      i)
    bind(mainMod .. " SHIFT", tostring(i), "movetoworkspace", i)
end
bind(mainMod,           "0", "workspace",      10)
bind(mainMod .. " SHIFT", "0", "movetoworkspace", 10)

-- Scratchpad / magic workspace
bind(mainMod,           "S", "togglespecialworkspace", "magic")
bind(mainMod .. " SHIFT", "S", "movetoworkspace",      "special:magic")

-- Mouse workspace scroll
bind(mainMod, "mouse_down", "workspace", "e+1")
bind(mainMod, "mouse_up",   "workspace", "e-1")

-- Mouse move / resize
bindm(mainMod, "mouse:272", "movewindow")
bindm(mainMod, "mouse:273", "resizewindow")

-- ============================================================
-- KEYBINDINGS  –  Multimedia  (volume via scripts/volume.lua)
-- ============================================================
bindel("", "XF86AudioRaiseVolume", "exec", "lua " .. SCRIPTS .. "volume.lua --inc")
bindel("", "XF86AudioLowerVolume", "exec", "lua " .. SCRIPTS .. "volume.lua --dec")
bindel("", "XF86AudioMute",        "exec", "lua " .. SCRIPTS .. "volume.lua --toggle")
bindel("", "XF86AudioMicMute",     "exec", "lua " .. SCRIPTS .. "volume.lua --toggle-mic")

-- Keyboard backlight via scripts/kbbacklight.lua
bindel("", "XF86MonBrightnessUp",   "exec", "lua " .. SCRIPTS .. "kbbacklight.lua --inc")
bindel("", "XF86MonBrightnessDown", "exec", "lua " .. SCRIPTS .. "kbbacklight.lua --dec")

-- Flash waybar (e.g. bind to a key or called from other scripts)
bind(mainMod, "B", "exec", "lua " .. SCRIPTS .. "flash_waybar.lua")
