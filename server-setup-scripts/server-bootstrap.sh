#!/bin/bash

# Ensure the script is run as root
if [[ "$(id -u)" != "0" ]]; then
   printf "This script must be run as root\n" >&2
   exit 1
fi

update_and_upgrade_system() {
    printf "Updating and upgrading system...\n"
    apt-get update && apt-get upgrade -y || return 1
}

set_timezone() {
    local timezone="America/Chicago"
    printf "Setting timezone to %s...\n" "$timezone"
    timedatectl set-timezone "$timezone" || return 1
}

check_and_install_ufw() {
    if ! command -v ufw &> /dev/null; then
        printf "Installing UFW...\n"
        apt-get install -y ufw || return 1
    fi
    printf "Configuring UFW...\n"
    ufw allow OpenSSH && \
    ufw default deny incoming && \
    ufw default allow outgoing && \
    ufw allow ssh && \
    ufw allow http && \
    ufw allow https && \
    echo "y" | ufw enable || return 1
}

install_essential_packages() {
    printf "Installing essential packages...\n"
    apt-get install -y curl vim lsd ranger unzip htop || return 1
}

setup_dotfiles() {
    printf "Setting up dotfiles...\n"
    rm -f "$HOME/.bashrc" && \
    ln -s "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc" && \
    ln -s "$HOME/dotfiles/vim-config/.vimrc" "$HOME/.vimrc" && \
    source "$HOME/.bashrc" || return 1
}

configure_git() {
    printf "Configuring Git user information...\n"
    local git_user_name git_user_email
    read -p "Enter your Git user name: " git_user_name
    read -p "Enter your Git user email: " git_user_email
    git config --global user.name "$git_user_name" && \
    git config --global user.email "$git_user_email" || return 1
    printf "Git user name and email configured.\n"
}

install_core_packages() {
    local packages="micro vim pandoc lsd bat htop curl unzip"
    printf "Installing core packages: %s\n" "$packages"
    apt-get install -y $packages || return 1
}

cleanup_and_reboot() {
    printf "Cleaning up and preparing for reboot...\n"
    apt-get autoremove -y && \
    printf "Setup complete. The system will now reboot.\n" && \
    reboot || return 1
}

main() {
    update_and_upgrade_system && \
    set_timezone && \
    check_and_install_ufw && \
    install_essential_packages && \
    setup_dotfiles && \
    configure_git && \
    install_core_packages && \
    cleanup_and_reboot
}

main "$@"
