#!/usr/bin/env bash

# Launch ktailctl
ktailctl &

# Wait for the window to appear
sleep 0.3

# Force float + size + center by class
hyprctl dispatch togglefloating "class:^(org\.fkoehler\.KTailctl)$"
hyprctl dispatch resizewindowpixel exact 1200 1000 "class:^(org\.fkoehler\.KTailctl)$"
hyprctl dispatch centerwindow "class:^(org\.fkoehler\.KTailctl)$"
