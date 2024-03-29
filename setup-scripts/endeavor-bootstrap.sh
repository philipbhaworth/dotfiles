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
    printf "Updating and upgrading Arch system.\n"
    sudo pacman -Syu --noconfirm
}

# Function to install core packages
install_core_packages() {
    local packages="micro vim pandoc lsd bat htop"
    printf "Installing core packages.\n"
    sudo pacman -S --noconfirm $packages
}

# Function to enable Flatpak and install apps from Flathub
setup_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        sudo pacman -S --noconfirm flatpak
    fi
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sudo flatpak update
    flatpak install flathub org.wezfurlong.wezterm -y
    flatpak install flathub md.obsidian.Obsidian -y
    flatpak install flathub org.geany.Geany -y
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
    local commands="micro vim pandoc lsd bat htop"
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
    configure_git
    display_versions
    printf "Setup complete. The wheel is yours!\n"
}

main
