#!/bin/bash
# bootstrap-multiple.sh - Setup ansible on multiple hosts
#
# Usage: ./bootstrap-multiple.sh 192.168.1.100 192.168.1.101 192.168.1.102

# Properly handle arguments as an array
HOSTS=("$@")
[[ ${#HOSTS[@]} -eq 0 ]] && {
  echo "Usage: $0 host1 host2 host3 ..."
  exit 1
}

# Process each host
for host in "${HOSTS[@]}"; do
  echo "=== Setting up $host ==="
  ./bootstrap-ansible-host.sh "$host"
  echo ""
done

# Generate inventory output
echo "All done! Here's your inventory:"
echo "---"
echo "all:"
echo "  hosts:"
for host in "${HOSTS[@]}"; do
  echo "    $host:"
  echo "      ansible_user: ansible"
  echo "      ansible_ssh_private_key_file: ~/.ssh/id_rsa_ansible"
done
