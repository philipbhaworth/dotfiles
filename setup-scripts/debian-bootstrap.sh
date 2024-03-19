#!/bin/bash

# Function to remove and create symbolic link for .bashrc and other configs
setup_dotfiles() {
    rm -f "$HOME/.bashrc"
    ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc"
    ln -s "$HOME/dotfiles/terminals/.wezterm.lua" "$HOME/.wezterm.lua"
    ln -s "$HOME/dotfiles/vim-config/.vimrc" "$HOME/.vimrc"
    source "$HOME/.bashrc"
}

# Function to update and upgrade the system
update_system() {
    printf "Updating and upgrading Debian/Ubuntu system.\n"
    sudo apt update && sudo apt upgrade -y
}

# Function to install core packages
install_core_packages() {
    local packages="micro vim pandoc exa bat htop"
    printf "Installing core packages.\n"
    sudo apt install -y $packages
}

# Function to enable Flatpak and install apps from Flathub
setup_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        sudo apt install -y flatpak
    fi
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sudo flatpak update
    flatpak install flathub org.wezfurlong.wezterm -y
    flatpak install flathub md.obsidian.Obsidian -y
}

# Function to display installed package versions
display_versions() {
    local commands="micro vim pandoc exa bat htop"
    printf "Installed package versions:\n"
    for cmd in $commands; do
        if command -v $cmd &>/dev/null; then
            $cmd --version
        fi
    done
    echo "Time to reboot."
}

main() {
    setup_dotfiles
    update_system
    install_core_packages
    setup_flatpak
    display_versions
    printf "Setup complete. The wheel is yours!\n"
}

main

