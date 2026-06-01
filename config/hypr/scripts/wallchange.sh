#!/bin/bash

WALLDIR="$HOME/Pictures/wallpapers"
WALL=$(find "$WALLDIR" -type f | shuf -n 1)

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper "eDP-1,$WALL"

echo "wallpaper changed"
exit
