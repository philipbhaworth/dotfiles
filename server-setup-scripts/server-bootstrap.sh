#!/bin/bash

# Enhanced setup script with error handling, including installation of lsd via snap

# Ensure the script is run as root
if [[ "$(id -u)" != "0" ]]; then
   printf "This script must be run as root\n" >&2
   return 1
fi

# Enable strict error handling
set -o errexit
set -o pipefail
set -o nounset

# Update and upgrade system
update_and_upgrade_system() {
    printf "Updating and upgrading system...\n"
    if ! apt-get update || ! apt-get upgrade -y; then
        printf "Failed to update and upgrade system.\n" >&2
        return 1
    fi
}

# Set timezone
set_timezone() {
    local timezone="America/Chicago"
    printf "Setting timezone to %s...\n" "$timezone"
    if ! timedatectl set-timezone "$timezone"; then
        printf "Failed to set timezone to %s.\n" "$timezone" >&2
        return 1
    fi
}

# Install and configure UFW
check_and_install_ufw() {
    if ! command -v ufw &> /dev/null; then
        printf "Installing UFW...\n"
        if ! apt-get install -y ufw; then
            printf "Failed to install UFW.\n" >&2
            return 1
        fi
    fi
    printf "Configuring UFW...\n"
    ufw allow OpenSSH && \
    ufw default deny incoming && \
    ufw default allow outgoing && \
    ufw allow ssh && \
    ufw allow http && \
    ufw allow https && \
    echo "y" | ufw enable || {
        printf "Failed to configure UFW.\n" >&2
        return 1
    }
}

# Install essential packages, excluding lsd
install_essential_packages() {
    printf "Installing essential packages...\n"
    if ! apt-get install -y curl vim git ranger unzip htop; then
        printf "Failed to install essential packages.\n" >&2
        return 1
    fi
}

# Install lsd via snap
install_lsd() {
    printf "Installing lsd via snap...\n"
    if ! snap install lsd; then
        printf "Failed to install lsd via snap.\n" >&2
        return 1
    fi
}
setup_dotfiles() {
    printf "Setting up dotfiles...\n"
    if ! rm -f "$HOME/.bashrc" || \
       ! ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc" || \
       ! ln -s "$HOME/dotfiles/vim-config/.vimrc" "$HOME/.vimrc"; then
        printf "Failed to setup dotfiles.\n" >&2
        return 1
    fi
}

setup_dotfiles() {
    printf "Setting up dotfiles...\n"
    if ! rm -f "$HOME/.bashrc" || \
       ! ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc" || \
       ! ln -s "$HOME/dotfiles/vim-config/.vimrc" "$HOME/.vimrc"; then
        printf "Failed to setup dotfiles.\n" >&2
        return 1
    fi
}

# Configure Git
configure_git() {
    printf "Configuring Git user information...\n"
    local git_user_name git_user_email
    read -p "Enter your Git user name: " git_user_name
    read -p "Enter your Git user email: " git_user_email
    if ! git config --global user.name "$git_user_name" || ! git config --global user.email "$git_user_email"; then
        printf "Failed to configure Git user information.\n" >&2
        return 1
    fi
    printf "Git user name and email configured.\n"
}

# Cleanup and reboot
cleanup_and_reboot() {
    printf "Cleaning up and preparing for reboot...\n"
    if ! apt-get autoremove -y; then
        printf "Failed to clean up.\n" >&2
        return 1
    fi
    printf "Setup complete. The system will now reboot.\n"
    reboot || {
        printf "Failed to reboot system.\n" >&2
        return 1
    }
}

main() {
    update_and_upgrade_system || return 1
    set_timezone || return 1
    check_and_install_ufw || return 1
    install_essential_packages || return 1
    install_lsd || return 1
    setup_dotfiles || return 1
    configure_git || return 1
    cleanup_and_reboot || return 1
}

main "$@"

