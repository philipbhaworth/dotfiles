# Function to remove and create symbolic link for .bashrc and other configs
setup_dotfiles() {
    rm -f "$HOME/.bashrc"
    ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc" || { echo "Failed to create symbolic link for .bashrc. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/terminals/.wezterm.lua" "$HOME/.wezterm.lua" || { echo "Failed to create symbolic link for .wezterm.lua. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/vim-config/.vimrc" "$HOME/.vimrc" || { echo "Failed to create symbolic link for .vimrc. Exiting."; exit 1; }
    # Create .config symlinks
    ln -s "$HOME/dotfiles/.config/starship.toml" "$HOME/.config/starship.toml" || { echo "Failed to create symbolic link for starship.toml. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/.config/tilix" "$HOME/.config/tilix" || { echo "Failed to create symbolic link for tilix. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/.config/micro" "$HOME/.config/micro" || { echo "Failed to create symbolic link for micro. Exiting."; exit 1; }
}

# Function to detect distribution and perform update & upgrade
update_system() {
    if [[ -f /etc/debian_version ]]; then
        printf "Updating and upgrading Debian/Ubuntu system.\n"
        sudo apt update && sudo apt upgrade -y || { echo "Failed to update system. Exiting."; return 1; }
    elif [[ -f /etc/fedora-release ]]; then
        printf "Updating and upgrading Fedora system.\n"
        sudo dnf update -y || { echo "Failed to update system. Exiting."; return 1; }
    else
        printf "Unsupported distribution. Exiting.\n" >&2
        return 1
    fi
}

# Function to install core packages based on the detected distribution
install_core_packages() {
    local packages="micro vim pandoc lsd bat htop lf curl"
    printf "Installing core packages...\n"
    if [[ -f /etc/debian_version ]]; then
        packages+=" flatpak"  # Adding flatpak for Debian/Ubuntu
        printf "Adding Flatpak repository...\n"
        sudo apt install -y flatpak || { echo "Failed to install Flatpak. Exiting."; exit 1; }
    fi
    sudo dnf install -y $packages || { echo "Failed to install core packages. Exiting."; exit 1; }
    # Install Starship prompt
    printf "Installing Starship prompt...\n"
    curl -sS https://starship.rs/install.sh | sh || { echo "Failed to install Starship. Exiting."; exit 1; }
}

# Function to enable Flatpak and install apps from Flathub
setup_flatpak() {
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { echo "Failed to add Flathub remote. Exiting."; exit 1; }
    sudo flatpak update || { echo "Failed to update Flatpak. Exiting."; exit 1; }
    flatpak install flathub org.wezfurlong.wezterm -y || { echo "Failed to install Wezterm. Exiting."; exit 1; }
    flatpak install flathub md.obsidian.Obsidian -y || { echo "Failed to install Obsidian. Exiting."; exit 1; }
    flatpak install flathub org.geany.Geany -y || { echo "Failed to install Geany. Exiting."; exit 1; }
}

# Function to configure Git with user input
configure_git() {
    echo "Configuring Git user information..."
    read -p "Enter your Git user name: " git_user_name
    read -p "Enter your Git user email: " git_user_email

    git config --global user.name "$git_user_name" || { echo "Failed to configure Git user name. Exiting."; exit 1; }
    git config --global user.email "$git_user_email" || { echo "Failed to configure Git user email. Exiting."; exit 1; }

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

# Function to install additional fonts and update font cache
install_fonts() {
    printf "Installing additional fonts...\n"
    sudo mv ~/dotfiles/nerd-fonts/*.ttf ~/dotfiles/nerd-fonts/*.otf /usr/share/fonts/ || { echo "Failed to move fonts. Exiting."; exit 1; }
    printf "Updating font cache...\n"
    sudo fc-cache -f -v || { echo "Failed to update font cache. Exiting."; exit 1; }
}

# Function to add color schemes for Gnome Terminal
setup_gnome_terminal_colors() {
    printf "Adding color schemes for Gnome Terminal...\n"
    curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 - || { echo "Failed to add color schemes. Exiting."; exit 1; }
}

main() {
    setup_dotfiles
    update_system || exit 1
    install_core_packages
    setup_flatpak
    configure_git
    display_versions
    install_fonts
    setup_gnome_terminal_colors
    printf "Setup complete. The wheel is yours!\n"
    read -p "Do you want to reboot now? (y/n): " choice
    case "$choice" in
        y|Y ) sudo reboot;;
        * ) echo "You can reboot later. Enjoy your setup!";;
    esac
}

main
