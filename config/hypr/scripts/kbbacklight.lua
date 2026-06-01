#!/usr/bin/env lua
-- scripts/kbbacklight.lua
-- Control keyboard backlight brightness and send OSD notifications.
-- Usage: lua kbbacklight.lua [--get|--inc|--dec|--zero|--full]

local HOME  = os.getenv("HOME")
local iDIR  = HOME .. "/.config/mako/icons"
local KBD   = "*::kbd_backlight"

local function exec(cmd)
    local h = io.popen(cmd)
    if not h then return "" end
    local out = h:read("*a"); h:close()
    return out:match("^%s*(.-)%s*$")
end

local function get_backlight()
    return tonumber(exec("cat /sys/class/leds/" .. KBD .. "/brightness")) or 0
end

local function get_icon()
    local v = get_backlight()
    if v <= 1 then
        return iDIR .. "/brightness-20.png"
    elseif v <= 2 then
        return iDIR .. "/brightness-60.png"
    else
        return iDIR .. "/brightness-100.png"
    end
end

local function notify()
    local level = exec("brightnessctl -d '" .. KBD .. "' g")
    local icon  = get_icon()
    os.execute(string.format(
        'notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "%s" "Keyboard Brightness : %s"',
        icon, level
    ))
end

local function inc() os.execute("brightnessctl -d '" .. KBD .. "' set 33%+"); notify() end
local function dec() os.execute("brightnessctl -d '" .. KBD .. "' set 33%-"); notify() end
local function zero() os.execute("brightnessctl -d '" .. KBD .. "' s 0%") end
local function full() os.execute("brightnessctl -d '" .. KBD .. "' s 100%") end

local flag = arg and arg[1] or ""

if     flag == "--get"  then print(get_backlight())
elseif flag == "--inc"  then inc()
elseif flag == "--dec"  then dec()
elseif flag == "--zero" then zero()
elseif flag == "--full" then full()
else                         print(get_backlight())
end
