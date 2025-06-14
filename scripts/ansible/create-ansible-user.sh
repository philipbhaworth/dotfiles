#!/bin/bash
# create-ansible-user.sh
# Creates ansible user with SSH key and sudo access
#
# USAGE INSTRUCTIONS:
# After fresh Ubuntu install with your regular user, run these commands from your jump host:
#
# 1. Copy your public key to the server:
#    scp ~/.ssh/id_ed25519_ansible.pub user@SERVER_IP:/tmp/
#
# 2. Copy this script to the server:
#    scp create-ansible-user.sh user@SERVER_IP:/tmp/
#
# 3. SSH in and run the setup:
#    ssh user@SERVER_IP
#    sudo mkdir -p /home/ansible/.ssh
#    sudo cp /tmp/id_ed25519_ansible.pub /home/ansible/.ssh/authorized_keys
#    sudo bash /tmp/create-ansible-user.sh
#
# Or run all in one command:
#    ssh user@SERVER_IP "sudo mkdir -p /home/ansible/.ssh && sudo cp /tmp/id_ed25519_ansible.pub /home/ansible/.ssh/authorized_keys && sudo bash /tmp/create-ansible-user.sh"
#
# Replace 'user' with your actual username (e.g., pbh) and SERVER_IP with target server IP

set -e

ANSIBLE_USER="ansible"
AUTHORIZED_KEYS_FILE="/home/$ANSIBLE_USER/.ssh/authorized_keys"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "[!] Run this as root: sudo $0"
  exit 1
fi

# Create ansible user if it doesn't exist
if ! id "$ANSIBLE_USER" &>/dev/null; then
  echo "[+] Creating user: $ANSIBLE_USER"
  useradd -m -s /bin/bash -G sudo "$ANSIBLE_USER"
else
  echo "[i] User '$ANSIBLE_USER' already exists"
fi

# Create SSH directory
echo "[+] Setting up SSH directory"
mkdir -p "/home/$ANSIBLE_USER/.ssh"
chmod 700 "/home/$ANSIBLE_USER/.ssh"
chown $ANSIBLE_USER:$ANSIBLE_USER "/home/$ANSIBLE_USER/.ssh"

# Check if authorized_keys exists (should be copied to /tmp beforehand)
if [ ! -f "/tmp/id_ed25519_ansible.pub" ]; then
  echo "[!] ERROR: /tmp/id_ed25519_ansible.pub not found"
  echo "[!] Copy your public key there first with:"
  echo "    scp user@192.168.10.9:~/.ssh/id_ed25519_ansible.pub /tmp/"
  exit 1
fi

# Copy the public key to ansible user's authorized_keys
echo "[+] Installing SSH public key"
cp /tmp/id_ed25519_ansible.pub "$AUTHORIZED_KEYS_FILE"

# Set correct permissions on authorized_keys
echo "[+] Setting authorized_keys permissions"
chmod 600 "$AUTHORIZED_KEYS_FILE"
chown $ANSIBLE_USER:$ANSIBLE_USER "$AUTHORIZED_KEYS_FILE"

# Enable passwordless sudo
echo "[+] Enabling passwordless sudo for $ANSIBLE_USER"
echo "$ANSIBLE_USER ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/$ANSIBLE_USER"
chmod 440 "/etc/sudoers.d/$ANSIBLE_USER"

# Clean up temporary files
echo "[+] Cleaning up temporary files"
rm -f /tmp/id_ed25519_ansible.pub /tmp/create-ansible-user.sh

echo "[✓] Ansible user setup complete"
echo "[✓] You can now SSH as: ssh ansible@$(hostname -I | awk '{print $1}')"
