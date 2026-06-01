#!/bin/bash

# Define the list of packages to install
# Core and GUI
PACKAGES=(
    "alacritty"
    "btop"
    "cava"
    "dunst"
    "fastfetch"
    "foot"
    "helix"
    "hyprland"
    "kitty"
    "rofi"
    "waybar"
    "wofi"
    "yazi"
    "zellij"
    "starship"
    "thunar"
    "network-manager-applet"
    "hyprpaper"
    "brightnessctl"
    "pipewire"
    "wireplumber"
    "playerctl"
    "fuzzel"
    "swaylock"
    "grim"
    "slurp"
    "jq" # Often needed for scripts
    "cliphist" # Common clipboard manager for hyprland
    "wl-clipboard"
    "swaync"
    "ranger"
    "htop"
    "thefuck"
    "polybar"
    "i3-wm"
)

# AUR Packages (might need an AUR helper)
# Note: niri and hyprshot are often in AUR
AUR_PACKAGES=(
    "niri" 
    "hyprshot"
    "spotify" 
    "eww"
    "ghostty-git"
    "wlogout"
    "superfile-bin"
    "nwg-look"
    "nwg-dock-hyprland"
    "waycorner"
    "spicetify-cli"
    "spotify-tui"
)

echo "Detected packages from config:"
for pkg in "${PACKAGES[@]}"; do
    echo " - $pkg"
done
echo " - (And potential AUR packages: ${AUR_PACKAGES[*]})"
echo ""

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1. Update system with Pacman
if command_exists pacman; then
    echo ":: Updating system repositories..."
    sudo pacman -Sy
else
    echo "Error: pacman not found. This script is intended for Arch-based systems."
    exit 1
fi

# 2. Install official packages
echo ":: Installing official packages..."
sudo pacman -S --needed "${PACKAGES[@]}"

# 3. Install AUR packages
AUR_HELPER=""
if command_exists paru; then
    AUR_HELPER="paru"
elif command_exists yay; then
    AUR_HELPER="yay"
fi

if [ -n "$AUR_HELPER" ]; then
    echo ":: AUR helper detected: $AUR_HELPER"
    echo ":: Installing AUR packages..."
    "$AUR_HELPER" -S --needed "${AUR_PACKAGES[@]}"
else
    echo ":: No AUR helper (paru/yay) detected."
    echo ":: Skipping AUR packages: ${AUR_PACKAGES[*]}"
    echo ":: Please install them manually."
fi

echo ":: Dependency installation complete!"
