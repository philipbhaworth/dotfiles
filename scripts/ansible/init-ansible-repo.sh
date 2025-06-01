#!/bin/bash
# init-ansible-repo.sh - Initialize a new Ansible project directory structure
#
# Usage: ./init-ansible-repo.sh <project-name>
#
# Creates a standard Ansible project layout with:
#   - Basic playbook (site.yml) with common role included
#   - Simple inventory file with example hosts
#   - Common role with a sample task
#   - Ansible configuration file
#   - Standard directories for files, templates, and playbooks
#   - README.md with project name
#
# Directory structure created:
#   project-name/
#   ├── ansible.cfg          # Ansible configuration
#   ├── inventory.yml        # Inventory file
#   ├── site.yml            # Main playbook
#   ├── README.md           # Project documentation
#   ├── playbooks/          # Additional playbooks
#   ├── roles/              # Ansible roles
#   │   └── common/         # Common role
#   │       └── tasks/
#   │           └── main.yml
#   ├── group_vars/         # Group variables
#   ├── host_vars/          # Host-specific variables
#   ├── files/              # Static files
#   └── templates/          # Jinja2 templates

# Check if project name was provided
REPO_NAME="$1"
if [[ -z "$REPO_NAME" ]]; then
  echo "Error: Project name required"
  echo "Usage: $0 <project-name>"
  exit 1
fi

# Check if directory already exists
if [[ -d "$REPO_NAME" ]]; then
  echo "Error: Directory '$REPO_NAME' already exists"
  exit 1
fi

# Create directory structure
echo "Creating Ansible project: $REPO_NAME"
mkdir -p "$REPO_NAME"/{playbooks,roles/common/tasks,files,templates,group_vars,host_vars}

# Create ansible.cfg
cat >"$REPO_NAME/ansible.cfg" <<'EOF'
[defaults]
inventory = inventory.yml
roles_path = ./roles
host_key_checking = False
EOF

# Create SIMPLE inventory file
cat >"$REPO_NAME/inventory.yml" <<'EOF'
all:
  hosts:
    server1:
      ansible_host: 192.168.1.10
    server2:
      ansible_host: 192.168.1.11
    server3:
      ansible_host: 192.168.1.12
EOF

# Create main playbook
cat >"$REPO_NAME/site.yml" <<EOF
---
- name: Site configuration playbook
  hosts: all
  become: true
  
  roles:
    - common
EOF

# Create common role main task
cat >"$REPO_NAME/roles/common/tasks/main.yml" <<'EOF'
---
# Common tasks for all hosts
- name: Ensure system is up to date
  apt:
    update_cache: yes
    upgrade: dist
  when: ansible_os_family == "Debian"

- name: Install basic packages
  package:
    name: 
      - vim
      - htop
      - curl
    state: present
EOF

# Create example group variables
cat >"$REPO_NAME/group_vars/all.yml" <<'EOF'
---
# Variables for all hosts
ansible_user: myuser
ansible_python_interpreter: /usr/bin/python3
EOF

# Create README
cat >"$REPO_NAME/README.md" <<EOF
# $REPO_NAME

Ansible automation project.

## Quick Start

1. Update \`inventory.yml\` with your hosts
2. Update \`group_vars/all.yml\` with your username
3. Run: \`ansible-playbook site.yml\`

## Test Connection

\`\`\`bash
ansible all -m ping
\`\`\`
EOF

echo "Successfully created Ansible project: $REPO_NAME"
echo ""
echo "Next steps:"
echo "  1. cd $REPO_NAME"
echo "  2. Edit inventory.yml with your hosts"
echo "  3. Test with: ansible all -m ping"
