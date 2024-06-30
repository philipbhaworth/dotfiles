#!/bin/bash

# Function to create symlinks for config files and directories
create_symlinks() {
    echo "Creating symlinks for config files and directories..."

    # Array of source and destination pairs
    declare -A symlinks=(
        ["$HOME/dots/zsh/.zshrc"]="$HOME/.zshrc"
        ["$HOME/dots/.config/alacritty"]="$HOME/.config/alacritty"
        ["$HOME/dots/.config/starship.toml"]="$HOME/.config/starship.toml"
        ["$HOME/dots/terminal/.wezterm.lua"]="$HOME/.wezterm.lua"
    )

    for src in "${!symlinks[@]}"; do
        dest="${symlinks[$src]}"

        # Create destination directory if it doesn't exist
        dest_dir=$(dirname "$dest")
        if [ ! -d "$dest_dir" ]; then
            mkdir -p "$dest_dir" || { echo "Failed to create directory $dest_dir"; exit 1; }
        fi

        # Backup existing files or symlinks
        if [ -e "$dest" ] || [ -L "$dest" ]; then
            if [ "$(readlink "$dest")" != "$src" ]; then
                echo "Backing up existing $dest to $dest.bak"
                mv "$dest" "$dest.bak" || { echo "Failed to backup $dest"; exit 1; }
            else
                echo "Symlink $dest already points to $src, skipping..."
                continue
            fi
        fi

        # Create the symlink
        echo "Creating symlink: $src -> $dest"
        ln -s "$src" "$dest" || { echo "Failed to create symlink $dest"; exit 1; }
    done
}

# Main script
echo "Starting symlink creation script..."

create_symlinks

echo "Symlink creation script completed."
