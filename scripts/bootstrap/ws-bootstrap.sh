#!/bin/bash

# Function to detect the distribution
detect_distro() {
    if [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    else
        echo "unsupported"
    fi
}

# Function to check network connectivity
check_network() {
    printf "Checking network connectivity...\n"
    if ! ping -c 1 8.8.8.8 &> /dev/null; then
        echo "No network connection detected. Please connect to the internet and try again. Exiting."
        exit 1
    fi
}

# Function to remove and create symbolic links for dotfiles
setup_dotfiles() {
    printf "Setting up dotfiles...\n"
    
    # Backup and link .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        mv "$HOME/.bashrc" "$HOME/.bashrc.bak" || { echo "Failed to back up .bashrc. Exiting."; exit 1; }
    fi
    ln -s "$HOME/dotfiles/.bashrc" "$HOME/.bashrc" || { echo "Failed to create symbolic link for .bashrc. Exiting."; exit 1; }
    
    # Link other dotfiles
    ln -s "$HOME/dotfiles/.vimrc" "$HOME/.vimrc" || { echo "Failed to create symbolic link for .vimrc. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/.tmux.conf" "$HOME/.tmux.conf" || { echo "Failed to create symbolic link for .tmux.conf. Exiting."; exit 1; }
    
    printf "Dotfiles setup complete.\n"
}

# Function to update and upgrade the system
update_system() {
    local distro=$1
    printf "Updating and upgrading $distro system...\n"
    if [[ $distro == "debian" ]]; then
        sudo apt update && sudo apt upgrade -y || { echo "Failed to update system. Exiting."; exit 1; }
    elif [[ $distro == "fedora" ]]; then
        sudo dnf update -y || { echo "Failed to update system. Exiting."; exit 1; }
    else
        echo "Unsupported distribution. Exiting."
        exit 1
    fi
    printf "System update and upgrade complete.\n"
}

# Function to install core packages
install_core_packages() {
    local distro=$1
    local packages="git vim curl htop tmux bat flatpak"
    printf "Installing core packages: $packages\n"
    if [[ $distro == "debian" ]]; then
        sudo apt install -y $packages || { echo "Failed to install core packages. Exiting."; exit 1; }
    elif [[ $distro == "fedora" ]]; then
        sudo dnf install -y $packages || { echo "Failed to install core packages. Exiting."; exit 1; }
    else
        echo "Unsupported distribution. Exiting."
        exit 1
    fi
    printf "Core packages installation complete.\n"
    
    # Install Starship prompt
    #printf "Installing Starship prompt...\n"
    #curl -sS https://starship.rs/install.sh | sh > /dev/null || { echo "Failed to install Starship. Exiting."; exit 1; }
    
    # Create symlink for bat
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat || { echo "Failed to create symbolic link for bat. Exiting."; exit 1; }
}

# Function to enable Flatpak and install apps from Flathub
setup_flatpak() {
    if ! command -v flatpak &> /dev/null; then
        echo "Flatpak is not installed. Please install it first. Exiting."
        exit 1
    fi
    
    printf "Setting up Flatpak and Flathub...\n"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { echo "Failed to add Flathub remote. Exiting."; exit 1; }
    sudo flatpak update || { echo "Failed to update Flatpak. Exiting."; exit 1; }
    flatpak install flathub org.wezfurlong.wezterm -y || { echo "Failed to install Wezterm. Exiting."; exit 1; }
    flatpak install flathub md.obsidian.Obsidian -y || { echo "Failed to install Obsidian. Exiting."; exit 1; }
    flatpak install flathub app.devsuite.Ptyxis -y || { echo "Failed to install Ptyxis. Exiting."; exit 1; }
}

# Function to install additional fonts and update font cache
install_fonts() {
    printf "Installing additional fonts...\n"
    if [ -d "$HOME/dotfiles/nerd-fonts" ]; then
        sudo cp "$HOME/dotfiles/nerd-fonts"/*.{ttf,otf} /usr/share/fonts/ || { echo "Failed to move fonts. Exiting."; exit 1; }
        printf "Updating font cache...\n"
        sudo fc-cache -f -v || { echo "Failed to update font cache. Exiting."; exit 1; }
    else
        printf "No fonts directory found at $HOME/dotfiles/nerd-fonts. Skipping font installation.\n"
    fi
}

# Main function
main() {
    check_network
    local distro=$(detect_distro)
    if [[ $distro == "unsupported" ]]; then
        echo "Unsupported distribution. Exiting."
        exit 1
    fi
    setup_dotfiles
    update_system "$distro"
    install_core_packages "$distro"
    setup_flatpak
    install_fonts
    printf "Setup complete. The wheel is yours!\n"
}

# Execute the main function
main
