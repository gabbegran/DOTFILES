#!/usr/bin/env lua
-- scripts/battery_border.lua
-- Polls battery state every 60 s and sets a red active-border when low.

local LOW_THRESHOLD   = 30
local NORMAL_BORDER   = "rgba(00000000)"
local LOW_BORDER      = "rgba(ff0000ee) rgba(ff5555ee) 45deg"

local function exec(cmd)
    local h = io.popen(cmd)
    if not h then return "" end
    local out = h:read("*a"); h:close()
    return out:match("^%s*(.-)%s*$")
end

local function set_border(color)
    os.execute(string.format('hyprctl keyword general:col.active_border "%s"', color))
end

-- Find battery device
local battery = exec("upower -e | grep battery | head -n 1")
if battery == "" then
    io.stderr:write("battery_border.lua: no battery found\n")
    os.exit(1)
end

while true do
    local info       = exec(string.format("upower -i '%s'", battery))
    local percentage = tonumber(info:match("percentage:%s+(%d+)%%") or "")
    local state      = info:match("state:%s+(%S+)") or ""

    if percentage and percentage <= LOW_THRESHOLD and state == "discharging" then
        set_border(LOW_BORDER)
    else
        set_border(NORMAL_BORDER)
    end

    os.execute("sleep 60")
end
