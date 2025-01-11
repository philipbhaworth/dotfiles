#!/bin/bash

# Script to disable cloud-init and configure netplan

echo "Disabling cloud-init network management..."
echo "network: {config: disabled}" | sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

echo "Fully disabling cloud-init..."
sudo touch /etc/cloud/cloud-init.disabled

echo "Checking for existing netplan configuration..."
if [ -f /etc/netplan/50-cloud-init.yaml ]; then
    echo "Moving cloud-init netplan file to manual management..."
    sudo mv /etc/netplan/50-cloud-init.yaml /etc/netplan/01-netcfg.yaml
else
    echo "No cloud-init netplan file found."
fi

echo "Applying netplan configuration..."
sudo netplan apply

echo "Done. Please verify the configuration and reboot if necessary."
