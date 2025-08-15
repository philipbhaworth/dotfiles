#!/bin/bash

BREWFILE="~/dotfiles/Brewfile"

echo "Generating new Brewfile..."
brew bundle dump --file="$BREWFILE" --force

echo "Checking for packages to cleanup..."
# Use brew bundle cleanup without --dry-run (it shows what would be removed by default)
if brew bundle cleanup --file="$BREWFILE" 2>&1 | grep -q "Would uninstall"; then
  echo "The following packages would be removed:"
  brew bundle cleanup --file="$BREWFILE"
  read -p "Proceed with cleanup? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew bundle cleanup --file="$BREWFILE" --force
  else
    echo "Skipping cleanup"
  fi
else
  echo "No orphaned packages found"
fi

echo "Brewfile update complete!"