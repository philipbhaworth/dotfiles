#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function: Update and upgrade Debian/Ubuntu system
update_system() {
    printf "Updating and upgrading Debian/Ubuntu system...\n"
    apt update && apt upgrade -y
    printf "System update and upgrade complete.\n"
}

# Function: Install core packages
install_core_packages() {
    local packages="git vim curl htop tmux"
    printf "Installing core packages: $packages\n"
    apt install -y $packages
    printf "Core packages installation complete.\n"
}

# Function: Set up SSH keys for root
setup_ssh_keys() {
    local remote_host="192.168.10.6"
    local remote_user="pbh"
    local key_name="homelab_key"
    local ssh_dir="/root/.ssh"
    local pi_ssh="/home/pbh/.ssh"
    
    printf "Setting up SSH keys for root...\n"
    
    # Ensure .ssh directory exists
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
    
    # Copy private and public keys from the remote host
    printf "Copying SSH keys from $remote_user@$remote_host...\n"
    scp "$remote_user@$remote_host:$pi_ssh/$key_name" "$ssh_dir/"
    scp "$remote_user@$remote_host:$pi_ssh/$key_name.pub" "$ssh_dir/"
    
    # Set correct permissions
    chmod 600 "$ssh_dir/$key_name"
    printf "SSH keys copied and permissions set.\n"
    
    # Add the SSH key to the agent
    eval "$(ssh-agent -s)"
    ssh-add "$ssh_dir/$key_name"
    printf "SSH key added to agent.\n"

    # Clone dotfiles git repo
    git clone git@github.com:philipbhaworth/dotfiles.git
    printf "Repo cloned.\n"
}

# Function: Remove and create symbolic links for dotfiles
setup_dotfiles() {
    local dotfiles_dir="/root/dotfiles"
    printf "Setting up dotfiles from $dotfiles_dir...\n"
    
    # Backup and create symbolic links for dotfiles
    for file in .bashrc .vimrc .tmux.conf; do
        if [ -f "/root/$file" ]; then
            mv "/root/$file" "/root/$file.bak"
        fi
        ln -sf "$dotfiles_dir/$file" "/root/$file"
        printf "Linked $file -> $dotfiles_dir/$file\n"
    done
    
    printf "Dotfiles setup complete.\n"
}

# Main function
main() {
    printf "Starting server setup as root...\n"
    update_system
    install_core_packages
    setup_ssh_keys
    setup_dotfiles
    printf "Setup complete. The wheel is yours!\n"
}

# Execute the main function
main

