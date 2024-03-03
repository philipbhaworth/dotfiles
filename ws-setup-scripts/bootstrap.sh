#!/bin/bash

# Remove existing .bashrc from home directory
rm -f $HOME/.bashrc

# Create a symbolic link to the .bashrc in ~/dotfiles/bash/
ln -s $HOME/dotfiles/bash/.bashrc $HOME/.bashrc

# Source the newly linked .bashrc
source $HOME/.bashrc

# Detect the distribution and update & upgrade
if [ -f /etc/debian_version ]; then
    echo "Detected Debian/Ubuntu system."
    sudo apt update && sudo apt upgrade -y
    # Install packages
    sudo apt install -y neofetch htop vim pandoc micro exa
elif [ -f /etc/fedora-release ]; then
    echo "Detected Fedora system."
    sudo dnf update -y
    # Install packages
    sudo dnf install -y neofetch htop vim pandoc micro neovim exa
else
    echo "Unsupported distribution. Exiting."
    exit 1
fi

# Echo installed package versions
echo "Installed package versions:"
neofetch --version
htop --version
vim --version
pandoc --version
micro --version
if [ -f /etc/fedora-release ]; then
    nvim --version
fi

echo "Setup complete. The wheel is yours!"
