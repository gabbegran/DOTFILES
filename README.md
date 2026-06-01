# My Dotfiles
Backup and setup for my configuration files across multiple systems.

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/gabbegran/DOTFILES.git ~/dotfiles
cd ~/dotfiles
```

### 2. Install dependencies (Arch-based systems)
This script installs the necessary packages via `pacman` and an AUR helper (`paru` or `yay`).
```bash
chmod +x install_dependencies.sh
./install_dependencies.sh
```

### 3. Deploy configurations
This script creates symbolic links from the repository to your `~/.config` and home directory. It will back up existing files to `.bak`.
```bash
chmod +x setup_configs.sh
./setup_configs.sh
```

## Included Configs
- **Shell:** Zsh (.zshrc, .p10k.zsh), Bash (.bashrc)
- **WM/DE:** Hyprland, i3, Niri
- **Terminals:** Alacritty, Foot, Kitty, Ghostty
- **File Managers:** Yazi, Ranger, Superfile
- **Others:** Waybar, Polybar, Rofi, Wofi, Helix, Dunst, Spicetify, SDDM (MacTahoe), and more.

## Required Fonts
To make the UI look correct, you should install these fonts:
- **JetBrainsMono Nerd Font** (Main terminal/UI font)
- **MesloLGS NF** (For Powerlevel10k)
- **SF Pro Display / Text** (Apple fonts used in some configs)
- **Noto Sans/Serif** (General fallback)
