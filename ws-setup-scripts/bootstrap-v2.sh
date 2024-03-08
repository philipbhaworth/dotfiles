#!/bin/bash

# Function to remove and create symbolic link for .bashrc
setup_bashrc() {
    rm -f "$HOME/.bashrc"
    ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc"
    source "$HOME/.bashrc"
}

# Function to detect distribution and perform update & upgrade
update_system() {
    if [[ -f /etc/debian_version ]]; then
        printf "Detected Debian/Ubuntu system.\n"
        sudo apt update && sudo apt upgrade -y
    elif [[ -f /etc/fedora-release ]]; then
        printf "Detected Fedora system.\n"
        sudo dnf update -y
    else
        printf "Unsupported distribution. Exiting.\n" >&2
        return 1
    fi
}

# Function to install common packages including bat
install_common_packages() {
    local packages="neofetch htop pandoc ranger micro exa bat"
    if [[ -f /etc/debian_version ]]; then
        sudo apt install -y $packages gnome-tweaks tilix
    elif [[ -f /etc/fedora-release ]]; then
        sudo dnf install -y $packages gnome-tweaks tilix
    fi
}

# Function to enable Flatpak and add the Flathub repository
enable_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        sudo apt install -y flatpak
    fi
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak update
}

# Function to display installed package versions
display_versions() {
    local commands="neofetch htop pandoc micro ranger bat"
    printf "Installed package versions:\n"
    for cmd in $commands; do
        if command -v $cmd &>/dev/null; then
            $cmd --version
        fi
    done
    if [[ -f /etc/fedora-release ]]; then
        if command -v tilix &>/dev/null; then
            tilix --version
        fi
        if command -v gnome-tweaks &>/dev/null; then
            gnome-tweaks --version
        fi
    fi
}

main() {
    setup_bashrc
    update_system || return 1
    install_common_packages
    enable_flatpak
    display_versions
    printf "Setup complete. The wheel is yours!\n"
}

main

