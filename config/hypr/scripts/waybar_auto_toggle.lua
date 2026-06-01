#!/usr/bin/env lua
-- scripts/waybar_auto_toggle.lua
-- Hide waybar when exactly one tiled window fills a workspace; show it otherwise.
-- Watches hyprland socket events in a loop.

local function exec(cmd)
    local h = io.popen(cmd)
    if not h then return "" end
    local out = h:read("*a"); h:close()
    return out:match("^%s*(.-)%s*$")
end

local waybar_visible = true

local function set_waybar(show)
    if show ~= waybar_visible then
        os.execute("killall -SIGUSR1 waybar")
        waybar_visible = show
    end
end

local function check()
    local ws_name = exec("hyprctl activeworkspace -j | jq -r '.name'")
    local count   = tonumber(exec(string.format(
        'hyprctl clients -j | jq "[.[] | select(.workspace.name == \\"%s\\" and .floating == false)] | length"',
        ws_name
    ))) or 0

    set_waybar(count ~= 1)
end

-- Watch the Hyprland event socket for workspace/window changes
local HYPR_SOCK = (os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000") ..
                  "/hypr/" .. (os.getenv("HYPRLAND_INSTANCE_SIGNATURE") or "") ..
                  "/.socket2.sock"

local sock = io.popen("socat - UNIX-CONNECT:" .. HYPR_SOCK)
if not sock then
    io.stderr:write("waybar_auto_toggle.lua: could not open Hyprland socket\n")
    os.exit(1)
end

-- Initial check before first event arrives
check()

for line in sock:lines() do
    -- React to events that change visible window count
    if line:match("^openwindow>>")    or line:match("^closewindow>>")    or
       line:match("^workspace>>")     or line:match("^focusedmon>>")     or
       line:match("^fullscreen>>")    or line:match("^togglefloating>>") then
        check()
    end
end

sock:close()
