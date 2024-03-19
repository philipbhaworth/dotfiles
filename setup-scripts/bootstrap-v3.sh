#!/bin/bash

# Function to remove and create symbolic link for .bashrc and other configs
setup_dotfiles() {
    rm -f "$HOME/.bashrc"
    ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc"
    ln -s "$HOME/dotfiles/terminals/.wezterm.lua" "$HOME/.wezterm.lua"
    ln -s "$HOME/dotfiles/vim-config/.vimrc" "$HOME/.vimrc"
    source "$HOME/.bashrc"
}

# Function to detect distribution and perform update & upgrade
update_system() {
    if [[ -f /etc/debian_version ]]; then
        printf "Updating and upgrading Debian/Ubuntu system.\n"
        sudo apt update && sudo apt upgrade -y
    elif [[ -f /etc/fedora-release ]]; then
        printf "Updating and upgrading Fedora system.\n"
        sudo dnf update -y
    else
        printf "Unsupported distribution. Exiting.\n" >&2
        return 1
    fi
}

# Function to install core packages based on the detected distribution
install_core_packages() {
    if [[ -f /etc/debian_version ]]; then
        local packages="micro vim pandoc exa bat htop"
        printf "Installing core packages on Debian/Ubuntu.\n"
        sudo apt install -y $packages
    elif [[ -f /etc/fedora-release ]]; then
        local packages="micro vim pandoc eza bat htop" # Use eza for Fedora
        printf "Installing core packages on Fedora.\n"
        sudo dnf install -y $packages
    fi
}

# Function to enable Flatpak and install apps from Flathub
setup_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        if [[ -f /etc/debian_version ]]; then
            sudo apt install -y flatpak
        elif [[ -f /etc/fedora-release ]]; then
            sudo dnf install -y flatpak
        fi
    fi
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sudo flatpak update
    flatpak install flathub org.wezfurlong.wezterm -y
    flatpak install flathub md.obsidian.Obsidian -y
}

# Function to configure Git with user input
configure_git() {
    echo "Configuring Git user information..."
    read -p "Enter your Git user name: " git_user_name
    read -p "Enter your Git user email: " git_user_email

    git config --global user.name "$git_user_name"
    git config --global user.email "$git_user_email"

    echo "Git user name and email configured."
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
    update_system || exit 1
    install_core_packages
    setup_flatpak
    configure_git  # Add this line to call your new function
    display_versions
    printf "Setup complete. The wheel is yours!\n"
    echo "Time to reboot."
}

main
