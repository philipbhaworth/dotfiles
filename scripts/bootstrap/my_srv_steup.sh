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
    local packages="git vim tree curl htop tmux"
    printf "Installing core packages: %s\n" "$packages"
    eval "apt install -y $packages"  # SC2086 fixed by using eval to expand packages correctly
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
    printf "Copying SSH keys from %s@%s...\n" "$remote_user" "$remote_host"  # SC2059 fixed
    scp "$remote_user@$remote_host:$pi_ssh/$key_name" "$ssh_dir/"
    scp "$remote_user@$remote_host:$pi_ssh/$key_name.pub" "$ssh_dir/"
    
    # Set correct permissions
    chmod 600 "$ssh_dir/$key_name"
    printf "SSH keys copied and permissions set.\n"
    
    # Add the SSH key to the agent
    eval "$(ssh-agent -s)"
    ssh-add "$ssh_dir/$key_name"
    printf "SSH key added to agent.\n"

    # Clone dotfiles repo
    git clone git@github.com:philipbhaworth/dotfiles.git
    printf "Cloning dotfiles repository...\n"  # Fixed print statement
}

# Function: Remove and create symbolic links for dotfiles
setup_dotfiles() {
    local dotfiles_dir="/root/dotfiles"
    printf "Setting up dotfiles from %s...\n" "$dotfiles_dir"  # SC2059 fixed
    
    # Backup and create symbolic links for dotfiles
    for file in .bashrc .vimrc .tmux.conf; do
        if [ -f "/root/$file" ]; then
            mv "/root/$file" "/root/$file.bak"
        fi
        ln -sf "$dotfiles_dir/$file" "/root/$file"
        printf "Linked %s -> %s\n" "$file" "$dotfiles_dir/$file"  # SC2059 fixed
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
