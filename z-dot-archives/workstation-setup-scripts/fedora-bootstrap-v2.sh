#!/bin/bash

# Function to remove and create symbolic links for configs
setup_dotfiles() {
    printf "Setting up symbolic links for dotfiles...\n"
    rm -f "$HOME/.bashrc" && ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc" || { echo "Failed to link .bashrc. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/.config/wezterm/.wezterm.lua" "$HOME/.wezterm.lua" || { echo "Failed to link .wezterm.lua. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/vim-config/.vimrc" "$HOME/.vimrc" || { echo "Failed to link .vimrc. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/.config/starship.toml" "$HOME/.config/starship.toml" || { echo "Failed to link starship.toml. Exiting."; exit 1; }
}

# Function to update Fedora system
update_system() {
    printf "Updating Fedora system...\n"
    sudo dnf update -y || { echo "Failed to update system. Exiting."; exit 1; }
}

# Function to install core packages on Fedora
install_core_packages() {
    local packages="micro vim pandoc lsd bat htop curl tree"
    printf "Installing core packages on Fedora...\n"
    sudo dnf install -y $packages || { echo "Failed to install core packages. Exiting."; exit 1; }
    # Install Starship prompt
    printf "Installing Starship prompt...\n"
    curl -sS https://starship.rs/install.sh | sh || { echo "Failed to install Starship. Exiting."; exit 1; }
}

# Function to enable Flatpak and install additional Flatpak apps
setup_flatpak() {
    printf "Setting up Flatpak and installing applications...\n"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { echo "Failed to add Flathub remote. Exiting."; exit 1; }
    sudo flatpak update -y || { echo "Failed to update Flatpak. Exiting."; exit 1; }

    # Install desired Flatpak apps
    local flatpak_apps=(
        "com.discordapp.Discord"
        "md.obsidian.Obsidian"
        "org.localsend.localsend_app"
        "org.signal.Signal"
        "org.wezfurlong.wezterm"
    )

    for app in "${flatpak_apps[@]}"; do
        flatpak install flathub "$app" -y || { echo "Failed to install $app. Exiting."; exit 1; }
    done
}

# Function to install additional RPM packages (VS Code, Sublime Text)
install_rpm_packages() {
    printf "Installing additional RPM packages (VS Code, Sublime Text)...\n"
    sudo rpm -ivh https://code.visualstudio.com/docs/?dv=linux64_rpm || { echo "Failed to install VS Code. Exiting."; exit 1; }
    sudo rpm -ivh https://download.sublimetext.com/sublime_text_build_3211_x64.rpm || { echo "Failed to install Sublime Text. Exiting."; exit 1; }
}

# Function to display installed package versions
display_versions() {
    printf "Displaying installed package versions...\n"
    local commands="vim pandoc lsd bat htop"
    for cmd in $commands; do
        if command -v $cmd &>/dev/null; then
            $cmd --version
        fi
    done
}

# Function to install additional fonts and update font cache
install_fonts() {
    printf "Installing additional fonts...\n"
    sudo mv ~/dotfiles/nerd-fonts/*.ttf ~/dotfiles/nerd-fonts/*.otf /usr/share/fonts/ || { echo "Failed to move fonts. Exiting."; exit 1; }
    sudo fc-cache -f -v || { echo "Failed to update font cache. Exiting."; exit 1; }
}

# Main function to execute setup tasks
main() {
    setup_dotfiles
    # update_system || exit 1
    install_core_packages
    setup_flatpak
    install_rpm_packages
    display_versions
    install_fonts
    printf "Setup complete. The wheel is yours!\n"
    read -p "Do you want to reboot now? (y/n): " choice
    case "$choice" in
        y|Y ) sudo reboot;;
        * ) echo "You can reboot later. Enjoy your setup!";;
    esac
}

main

