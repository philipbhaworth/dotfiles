#!/bin/bash

# Homebrew Update Script
# This script updates Homebrew, upgrades installed formulas, and then cleans up old versions.

# Update Homebrew to get the latest list of available formulas
echo "Updating Homebrew..."
brew update

# Upgrade any installed formulas to their latest versions
echo "Upgrading installed formulas..."
brew upgrade

# Clean up old versions of formulas
echo "Cleaning up old versions..."
brew cleanup

echo "Homebrew update and cleanup completed."
