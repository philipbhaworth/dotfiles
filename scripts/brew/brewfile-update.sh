#!/bin/bash

BREWFILE="~/dotfiles/scripts/Brewfile"

echo "Generating new Brewfile..."
brew bundle dump --file="$BREWFILE" --force

echo "Checking for packages to cleanup..."
if brew bundle cleanup --file="$BREWFILE" --dry-run | grep -q "Would uninstall"; then
  echo "The following packages would be removed:"
  brew bundle cleanup --file="$BREWFILE" --dry-run
  read -p "Proceed with cleanup? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew bundle cleanup --file="$BREWFILE"
  else
    echo "Skipping cleanup"
  fi
else
  echo "No orphaned packages found"
fi

echo "Brewfile update complete!"
