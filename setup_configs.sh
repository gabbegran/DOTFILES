#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# Create .config if it doesn't exist
mkdir -p "$CONFIG_DIR"

echo ":: Deploying dotfiles from $DOTFILES_DIR"

# 1. Link items in the 'config' directory to ~/.config/
echo ":: Linking .config directories..."
for dir in "$DOTFILES_DIR/config"/*; do
    target_name=$(basename "$dir")
    target_path="$CONFIG_DIR/$target_name"
    
    # Back up existing config if it's not already a link
    if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
        echo "   Backing up existing $target_name to ${target_path}.bak"
        mv "$target_path" "${target_path}.bak"
    fi
    
    # Create symlink
    echo "   Linking $target_name"
    ln -sfn "$dir" "$target_path"
done

# 2. Link home directory files
echo ":: Linking home directory files..."
HOME_FILES=(".bashrc" ".zshrc" ".p10k.zsh" ".gitconfig")

for file in "${HOME_FILES[@]}"; do
    target_path="$HOME/$file"
    source_path="$DOTFILES_DIR/$file"
    
    if [ -f "$source_path" ]; then
        # Back up existing file if it's not already a link
        if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
            echo "   Backing up existing $file to ${target_path}.bak"
            mv "$target_path" "${target_path}.bak"
        fi
        
        echo "   Linking $file"
        ln -sfn "$source_path" "$target_path"
    fi
done

echo ":: Configuration deployment complete!"
