#!/usr/bin/env lua
-- scripts/brightness.lua
-- Control screen brightness and send OSD notifications.
-- Usage: lua brightness.lua [--get|--inc|--dec]

local HOME = os.getenv("HOME")
local iDIR = HOME .. "/.config/mako/icons"

local function exec(cmd)
    local h = io.popen(cmd)
    if not h then return "" end
    local out = h:read("*a"); h:close()
    return out:match("^%s*(.-)%s*$")
end

local function get_brightness()
    local current = tonumber(exec("brightnessctl g")) or 0
    local max = tonumber(exec("brightnessctl m")) or 1
    return math.floor((current / max) * 100)
end

local function get_icon()
    local v = get_brightness()
    if v <= 20 then
        return iDIR .. "/brightness-20.png"
    elseif v <= 40 then
        return iDIR .. "/brightness-40.png"
    elseif v <= 60 then
        return iDIR .. "/brightness-60.png"
    elseif v <= 80 then
        return iDIR .. "/brightness-80.png"
    else
        return iDIR .. "/brightness-100.png"
    end
end

local function notify()
    local level = get_brightness()
    local icon  = get_icon()
    os.execute(string.format(
        'notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "%s" "Brightness : %s%%"',
        icon, level
    ))
end

local function inc() os.execute("brightnessctl set 5%+"); notify() end
local function dec() os.execute("brightnessctl set 5%-"); notify() end

local flag = arg and arg[1] or ""

if     flag == "--get"  then print(get_brightness())
elseif flag == "--inc"  then inc()
elseif flag == "--dec"  then dec()
else                         print(get_brightness())
end
