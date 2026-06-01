#!/usr/bin/env lua
-- scripts/flash_waybar.lua
-- If the current workspace has exactly one tiled window (waybar hidden),
-- briefly flash the bar so the user can see it.

local function exec(cmd)
    local h = io.popen(cmd)
    if not h then return "" end
    local out = h:read("*a"); h:close()
    return out:match("^%s*(.-)%s*$")
end

local ws_name = exec("hyprctl activeworkspace -j | jq -r '.name'")

local tiled_count = tonumber(exec(string.format(
    'hyprctl clients -j | jq "[.[] | select(.workspace.name == \\"%s\\" and .floating == false)] | length"',
    ws_name
))) or 0

if tiled_count == 1 then
    -- Bar is hidden by waybar-auto-toggle → flash it
    os.execute("killall -SIGUSR1 waybar")
    os.execute("sleep 3")
    os.execute("killall -SIGUSR1 waybar")
else
    -- Bar is already visible, nothing to do
    os.exit(0)
end
