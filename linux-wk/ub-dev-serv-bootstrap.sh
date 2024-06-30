#!/bin/bash

# Function to remove and create symbolic link for .bashrc and other configs
setup_dotfiles() {
    echo "Setting up dotfiles..."
    if ! rm -f "$HOME/.bashrc" || \
       ! ln -s "$HOME/dots/bash/.bashrc" "$HOME/.bashrc" || \
       ! ln -s "$HOME/dots/vim-config/.vimrc" "$HOME/.vimrc"; then
        echo "Failed to setup dotfiles." >&2
        return 1
    fi
}

# Update and upgrade system
update_and_upgrade_system() {
    echo "Updating and upgrading system..."
    if ! apt-get update || ! apt-get upgrade -y; then
        echo "Failed to update and upgrade system." >&2
        return 1
    fi
}

# Install essential packages
install_essential_packages() {
    echo "Installing essential packages..."
    if ! apt-get install -y curl vim ranger unzip htop tree tmux bat; then
        echo "Failed to install essential packages." >&2
        return 1
    fi

    # Fix issue with bat
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
}

# Main script execution
main() {
    if ! setup_dotfiles; then
        echo "Dotfiles setup failed. Exiting..."
        exit 1
    fi

    if ! update_and_upgrade_system; then
        echo "System update and upgrade failed. Exiting..."
        exit 1
    fi

    if ! install_essential_packages; then
        echo "Essential package installation failed. Exiting..."
        exit 1
    fi

    echo "Bootstrap completed successfully!"
}

main
