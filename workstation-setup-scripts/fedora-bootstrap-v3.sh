#!/bin/bash

# Function to remove and create symbolic links for configs
setup_dotfiles() {
    printf "Setting up symbolic links for dotfiles...\n"
    local files=( ".bashrc" ".wezterm.lua" ".vimrc" ".config/starship.toml" )
    local paths=( 
        "$HOME/dotfiles/bash/.bashrc" 
        "$HOME/dotfiles/.config/wezterm/.wezterm.lua" 
        "$HOME/dotfiles/vim-config/.vimrc" 
        "$HOME/dotfiles/.config/starship.toml" 
    )

    for i in "${!files[@]}"; do
        local target="$HOME/${files[i]}"
        rm -f "$target"
        ln -s "${paths[i]}" "$target" || { printf "Failed to link %s. Exiting.\n" "$target" >&2; return 1; }
    done
}

# Function to update Fedora system
update_system() {
    printf "Updating Fedora system...\n"
    sudo dnf update -y || { printf "Failed to update system. Exiting.\n" >&2; return 1; }
}

# Function to install core packages on Fedora
install_core_packages() {
    local packages="micro vim pandoc lsd bat htop curl tree"
    printf "Installing core packages on Fedora...\n"
    sudo dnf install -y $packages || { printf "Failed to install core packages. Exiting.\n" >&2; return 1; }

    # Install Starship prompt
    printf "Installing Starship prompt...\n"
    curl -sS https://starship.rs/install.sh | sh || { printf "Failed to install Starship. Exiting.\n" >&2; return 1; }
}

# Function to enable Flatpak and install additional Flatpak apps
setup_flatpak() {
    printf "Setting up Flatpak and installing applications...\n"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { printf "Failed to add Flathub remote. Exiting.\n" >&2; return 1; }
    sudo flatpak update -y || { printf "Failed to update Flatpak. Exiting.\n" >&2; return 1; }

    # Install desired Flatpak apps
    local flatpak_apps=(
        "com.discordapp.Discord"
        "md.obsidian.Obsidian"
        "org.localsend.localsend_app"
        "org.signal.Signal"
        "org.wezfurlong.wezterm"
    )

    for app in "${flatpak_apps[@]}"; do
        flatpak install flathub "$app" -y || { printf "Failed to install %s. Exiting.\n" "$app" >&2; return 1; }
    done
}

# Function to install additional RPM packages (VS Code, Sublime Text)
install_rpm_packages() {
    printf "Installing additional RPM packages (VS Code, Sublime Text)...\n"
    sudo rpm -ivh https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm || { printf "Failed to install VS Code. Exiting.\n" >&2; return 1; }
    sudo rpm -ivh https://download.sublimetext.com/sublime_text_build_3211_x64.rpm || { printf "Failed to install Sublime Text. Exiting.\n" >&2; return 1; }
}

# Function to display installed package versions
display_versions() {
    printf "Displaying installed package versions...\n"
    local commands="vim pandoc lsd bat htop"
    for cmd in $commands; do
        if command -v "$cmd" &>/dev/null; then
            "$cmd" --version | head -n 1
        else
            printf "%s is not installed.\n" "$cmd"
        fi
    done
}

# Function to install additional fonts and update font cache
install_fonts() {
    printf "Installing additional fonts...\n"
    local font_dir="/usr/share/fonts"
    sudo mv ~/dotfiles/nerd-fonts/*.ttf ~/dotfiles/nerd-fonts/*.otf "$font_dir" || { printf "Failed to move fonts. Exiting.\n" >&2; return 1; }
    sudo fc-cache -f -v || { printf "Failed to update font cache. Exiting.\n" >&2; return 1; }
}

# Main function to execute setup tasks
main() {
    setup_dotfiles || return 1
    # update_system || return 1
    install_core_packages || return 1
    setup_flatpak || return 1
    install_rpm_packages || return 1
    display_versions
    install_fonts || return 1
    printf "Setup complete. The wheel is yours!\n"
    
    read -rp "Do you want to reboot now? (y/n): " choice
    case "$choice" in
        y|Y ) sudo reboot;;
        * ) printf "You can reboot later. Enjoy your setup!\n";;
    esac
}

main

