#!/bin/bash

# Logic from waybar-auto-toggle.sh to determine if bar is likely hidden
WS_ID=$(hyprctl activeworkspace -j | jq '.id')
TILED_COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS_ID and .floating == false)] | length")

# Logging to help debug
# echo "WS_ID: $WS_ID, TILED_COUNT: $TILED_COUNT" >> /tmp/flash_waybar.log

# If TILED_COUNT is 1, the bar is hidden by waybar-auto-toggle.sh
if [ "$TILED_COUNT" -eq 1 ]; then
    # Waybar is likely hidden, so flash it
    killall -SIGUSR1 waybar
    sleep 3
    killall -SIGUSR1 waybar
else
    # Waybar is likely already visible, do nothing
    exit 0
fi
