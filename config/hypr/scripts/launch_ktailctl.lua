#!/usr/bin/env lua
-- scripts/launch_ktailctl.lua
-- Launch KTailctl and force float, size, and center it.

local CLASS = "class:^(org\\.fkoehler\\.KTailctl)$"

local function dispatch(cmd)
    os.execute(string.format('hyprctl dispatch %s "%s"', cmd, CLASS))
end

os.execute("ktailctl &")
os.execute("sleep 0.3")

dispatch("togglefloating")
dispatch("resizewindowpixel exact 1200 1000")
dispatch("centerwindow")
