#!/bin/bash

# Update and upgrade system
sudo apt-get update && sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y curl vim git

# Ensure the ~/.ssh directory and config file exist
mkdir -p ~/.ssh
touch ~/.ssh/config

# Generate SSH keys using your work email
ssh-keygen -t ed25519 -C hawrth@uiowa.edu -f ~/.ssh/id_ed25519 

# Display the public key and copy it to clipboard (manual step to add to GitLab)
echo "Add the following SSH key to GitLab:"
cat ~/.ssh/id_ed25519.pub

# Start SSH agent and add the private key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add SSH configuration for GitLab
echo -e "\n# Uiowa GitLab instance\nHost git.uiowa.edu\n  PreferredAuthentications publickey\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config

# Set proper permissions for the ~/.ssh directory and config file
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config

echo "Please add the SSH key to your GitLab account before proceeding."
read -p "Press Enter to continue after adding the SSH key to GitLab..."

# Clone the private repository
git clone git@git.uiowa.edu:7999/hawrth/dots.git

echo "Repository cloned successfully!"
