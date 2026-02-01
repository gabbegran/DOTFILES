#!/bin/bash
# Auto-detect Linux distribution and return appropriate launcher icon path
# Usage: get-launcher-icon.sh

# Default icon directory (update this path for your system)
ICON_DIR="${ICON_DIR:-$HOME/.config/waybar/icons}"

# Fallback to Arch logo if distribution not detected
DEFAULT_ICON="$ICON_DIR/arch.png"

# Read distribution info from /etc/os-release
if [ -f /etc/os-release ]; then
    . /etc/os-release
    # Use LOGO variable if available, otherwise fall back to ID
    if [ -n "$LOGO" ]; then
        ICON_NAME="${LOGO,,}"  # Convert to lowercase
    else
        ICON_NAME="${ID,,}"  # Convert to lowercase
    fi
else
    # Fallback detection methods if /etc/os-release doesn't exist
    if [ -f /etc/cachyos-release ]; then
        ICON_NAME="cachyos"
    elif [ -f /etc/endeavouros-release ]; then
        ICON_NAME="endeavouros"
    elif [ -f /etc/manjaro-release ]; then
        ICON_NAME="manjaro"
    elif [ -f /etc/garuda-release ]; then
        ICON_NAME="garuda"
    elif [ -f /etc/arch-release ]; then
        ICON_NAME="arch"
    else
        ICON_NAME="arch"
    fi
fi

# Build icon path
ICON_PATH="$ICON_DIR/${ICON_NAME}.png"

# Check if icon exists, otherwise use default
if [ -f "$ICON_PATH" ]; then
    echo "$ICON_PATH"
else
    echo "$DEFAULT_ICON"
fi
