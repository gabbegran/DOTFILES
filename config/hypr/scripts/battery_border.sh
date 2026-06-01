#!/bin/bash

LOW_BATTERY_THRESHOLD=30
NORMAL_BORDER="rgba(00000000)"
LOW_BATTERY_BORDER="rgba(ff0000ee) rgba(ff5555ee) 45deg"

# Battery path
BATTERY=$(upower -e | grep battery | head -n 1)

if [ -z "$BATTERY" ]; then
    echo "No battery found"
    exit 1
fi

while true; do
    # Get battery info
    BAT_INFO=$(upower -i "$BATTERY")
    PERCENTAGE=$(echo "$BAT_INFO" | grep percentage | awk '{print $2}' | sed 's/%//')
    STATE=$(echo "$BAT_INFO" | grep state | awk '{print $2}')

    if [ "$PERCENTAGE" -le "$LOW_BATTERY_THRESHOLD" ] && [ "$STATE" == "discharging" ]; then
        hyprctl keyword general:col.active_border "$LOW_BATTERY_BORDER"
    else
        hyprctl keyword general:col.active_border "$NORMAL_BORDER"
    fi

    sleep 60
done
