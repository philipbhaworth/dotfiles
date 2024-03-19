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
    sudo apt install -y neofetch htop vim pandoc ranger micro exa
elif [ -f /etc/fedora-release ]; then
    echo "Detected Fedora system."
    sudo dnf update -y
    # Install packages
    sudo dnf install -y neofetch htop vim pandoc micro ranger exa
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$NAME" = "openSUSE Leap" ] || [ "$NAME" = "openSUSE Tumbleweed" ]; then
        echo "Detected openSUSE system."
        sudo zypper refresh
        sudo zypper update -y
        # Install packages. Note: Some package names may differ. Adjust as necessary.
        sudo zypper install -y neofetch htop vim pandoc ranger micro exa
    else
        echo "Unsupported distribution. Exiting."
        exit 1
    fi
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
ranger --version
# exa might not be directly available in openSUSE repositories, consider an alternative or manual installation.

echo "time to reboot!"
