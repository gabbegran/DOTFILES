#!/usr/bin/env lua
-- scripts/volume.lua
-- Control PipeWire/PulseAudio volume and microphone via pamixer, with OSD.
-- Usage: lua volume.lua [--get|--inc|--dec|--toggle|--toggle-mic|
--                        --get-icon|--get-mic-icon|--mic-inc|--mic-dec]

local HOME = os.getenv("HOME")
local iDIR = HOME .. "/.config/mako/icons"

local function exec(cmd)
    local h = io.popen(cmd)
    if not h then return "" end
    local out = h:read("*a"); h:close()
    return out:match("^%s*(.-)%s*$")
end

local function notify(icon, msg)
    os.execute(string.format(
        'notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "%s" "%s"',
        icon, msg
    ))
end

-- ── Volume ────────────────────────────────────────────────────────────────────

local function get_volume()
    return tonumber(exec("pamixer --get-volume")) or 0
end

local function get_icon()
    local v = get_volume()
    if v == 0               then return iDIR .. "/volume-mute.png"
    elseif v <= 30          then return iDIR .. "/volume-low.png"
    elseif v <= 60          then return iDIR .. "/volume-mid.png"
    else                         return iDIR .. "/volume-high.png"
    end
end

local function inc_volume()
    os.execute("pamixer -i 5")
    notify(get_icon(), "Volume : " .. get_volume() .. " %")
end

local function dec_volume()
    os.execute("pamixer -d 5")
    notify(get_icon(), "Volume : " .. get_volume() .. " %")
end

local function toggle_mute()
    local muted = exec("pamixer --get-mute")
    if muted == "false" then
        os.execute("pamixer -m")
        notify(iDIR .. "/volume-mute.png", "Volume Switched OFF")
    else
        os.execute("pamixer -u")
        notify(get_icon(), "Volume Switched ON")
    end
end

-- ── Microphone ────────────────────────────────────────────────────────────────

local function get_mic_icon()
    -- All levels use the same microphone icon; kept separate for easy extension
    return iDIR .. "/microphone.png"
end

local function get_mic_volume()
    return tonumber(exec("pamixer --default-source --get-volume")) or 0
end

local function toggle_mic()
    local muted = exec("pamixer --default-source --get-mute")
    if muted == "false" then
        os.execute("pamixer --default-source -m")
        notify(iDIR .. "/microphone-mute.png", "Microphone Switched OFF")
    else
        os.execute("pamixer --default-source -u")
        notify(get_mic_icon(), "Microphone Switched ON")
    end
end

local function inc_mic()
    os.execute("pamixer --default-source -i 5")
    notify(get_mic_icon(), "Mic-Level : " .. get_mic_volume() .. " %")
end

local function dec_mic()
    os.execute("pamixer --default-source -d 5")
    notify(get_mic_icon(), "Mic-Level : " .. get_mic_volume() .. " %")
end

-- ── Dispatch ──────────────────────────────────────────────────────────────────

local flag = arg and arg[1] or ""

if     flag == "--get"          then print(get_volume())
elseif flag == "--inc"          then inc_volume()
elseif flag == "--dec"          then dec_volume()
elseif flag == "--toggle"       then toggle_mute()
elseif flag == "--toggle-mic"   then toggle_mic()
elseif flag == "--get-icon"     then print(get_icon())
elseif flag == "--get-mic-icon" then print(get_mic_icon())
elseif flag == "--mic-inc"      then inc_mic()
elseif flag == "--mic-dec"      then dec_mic()
else                                 print(get_volume())
end
