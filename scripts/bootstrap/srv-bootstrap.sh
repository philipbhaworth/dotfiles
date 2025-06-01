#!/bin/bash

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

# Function to update and upgrade Debian/Ubuntu system
update_system() {
    printf "Updating and upgrading Debian/Ubuntu system...\n"
    sudo apt update && sudo apt upgrade -y || { echo "Failed to update system. Exiting."; exit 1; }
    printf "System update and upgrade complete.\n"
}

# Function to install core packages
install_core_packages() {
    local packages="git vim curl htop tmux"
    printf "Installing core packages: $packages\n"
    sudo apt install -y $packages || { echo "Failed to install core packages. Exiting."; exit 1; }
    printf "Core packages installation complete.\n"
}

# Main function
main() {
    setup_dotfiles
    update_system
    install_core_packages
    printf "Setup complete. The wheel is yours!\n"
}

# Execute the main function
main
