#!/bin/bash

# Initial state: Assume Waybar is visible (0 = visible, 1 = hidden)
# This might desync if you manually toggle Waybar, but it's the best we can do without querying Waybar directly.
BAR_HIDDEN=0

# Function to check and toggle Waybar
check_waybar() {
    # Get the ID of the currently active workspace
    WS_ID=$(hyprctl activeworkspace -j | jq '.id')

    # Count the number of non-floating (tiled) windows on this workspace
    TILED_COUNT=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $WS_ID and .floating == false)] | length")

    if [ "$TILED_COUNT" -eq 1 ]; then
        # If exactly one tiled window, we want the bar HIDDEN
        if [ "$BAR_HIDDEN" -eq 0 ]; then
            killall -SIGUSR1 waybar
            BAR_HIDDEN=1
        fi
    else
        # If 0 or >1 tiled windows, we want the bar VISIBLE
        if [ "$BAR_HIDDEN" -eq 1 ]; then
            killall -SIGUSR1 waybar
            BAR_HIDDEN=0
        fi
    fi
}

# Run the check immediately on script start
check_waybar

# Listen to the Hyprland socket for events that change window layout
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    case "$line" in
        workspace\>\>*|openwindow\>\>*|closewindow\>\>*|movewindow\>\>*)
            check_waybar
            ;;
    esac
done
