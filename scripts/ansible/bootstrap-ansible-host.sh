#!/bin/bash
# bootstrap-ansible-host.sh - Prepare a fresh system for Ansible management
#
# Usage: ./bootstrap-ansible-host.sh <hostname/IP>
#
# This script:
#   - Creates ansible user with sudo access
#   - Copies your existing id_rsa_ansible.pub key
#   - Sets up passwordless sudo
#   - Tests the connection

HOST="$1"
ANSIBLE_USER="ansible"
INITIAL_USER="pbh"
ANSIBLE_KEY="$HOME/.ssh/id_rsa_ansible"

if [[ -z "$HOST" ]]; then
  echo "Usage: $0 <hostname/IP>"
  exit 1
fi

# Check if key exists
if [[ ! -f "${ANSIBLE_KEY}.pub" ]]; then
  echo "Error: ${ANSIBLE_KEY}.pub not found!"
  exit 1
fi

echo "Bootstrapping Ansible on $HOST"
echo "Using existing key: ${ANSIBLE_KEY}"

# Create ansible user and setup
echo "Creating ansible user and configuring..."
ssh "${INITIAL_USER}@${HOST}" 'bash -s' <<'ENDSSH'
# Create ansible user
sudo useradd -m -s /bin/bash ansible 2>/dev/null || echo "User ansible already exists"

# Add to sudo group (works for Debian/Ubuntu/RHEL)
if grep -q "^sudo:" /etc/group; then
    sudo usermod -aG sudo ansible
elif grep -q "^wheel:" /etc/group; then
    sudo usermod -aG wheel ansible
fi

# Configure passwordless sudo
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
sudo chmod 440 /etc/sudoers.d/ansible

# Create .ssh directory
sudo mkdir -p /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
sudo chown ansible:ansible /home/ansible/.ssh
ENDSSH

# Copy your existing SSH key
echo "Installing SSH key..."
cat "${ANSIBLE_KEY}.pub" | ssh "${INITIAL_USER}@${HOST}" \
  'sudo tee /home/ansible/.ssh/authorized_keys && \
     sudo chmod 600 /home/ansible/.ssh/authorized_keys && \
     sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys'

# Test connection
echo "Testing ansible user connection..."
if ssh -i "$ANSIBLE_KEY" -o BatchMode=yes -o ConnectTimeout=5 \
  "${ANSIBLE_USER}@${HOST}" 'sudo -n true && echo "Ansible user working with sudo!"'; then
  echo "Host $HOST is ready for Ansible!"
  echo ""
  echo "Add to inventory.yml:"
  echo "  $HOST:"
  echo "    ansible_user: ansible"
  echo "    ansible_ssh_private_key_file: ~/.ssh/id_rsa_ansible"
else
  echo "Failed to connect as ansible user"
  exit 1
fi
