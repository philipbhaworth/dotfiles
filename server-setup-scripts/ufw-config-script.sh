#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check if UFW is installed
if ! command -v ufw &> /dev/null; then
    echo "UFW is not installed. Please install UFW and try again."
    exit 1
fi

# Set default policies
echo "Setting default policies: Deny incoming, Allow outgoing."
ufw default deny incoming
ufw default allow outgoing

# Allow SSH connections
echo "Allowing SSH connections..."
ufw allow ssh

# Optionally, allow HTTP and HTTPS
echo "Optionally allowing HTTP and HTTPS..."
ufw allow http
ufw allow https

# Automatically answer yes to enable UFW
echo "Enabling UFW..."
echo "y" | ufw enable

echo "UFW setup completed."
