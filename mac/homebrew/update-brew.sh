#!/bin/bash

# Homebrew Update Script
# This script updates Homebrew, upgrades installed formulas and casks, and then cleans up old versions.

# Update Homebrew to get the latest list of available formulas and casks
echo "Updating Homebrew..."
brew update

# Upgrade any installed formulas and casks to their latest versions
echo "Upgrading installed formulas..."
brew upgrade

echo "Upgrading installed casks..."
brew upgrade --cask

# Clean up old versions of formulas and casks
echo "Cleaning up old versions..."
brew cleanup

# List outdated casks (if any) for information
echo "Listing outdated casks (if any)..."
brew outdated --cask

echo "Homebrew update and cleanup completed."
