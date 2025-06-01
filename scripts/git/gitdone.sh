#!/bin/sh

# Script for Git process: ./gitdone.sh "commit message here"

# Check if a commit message was provided
if [ -z "$1" ]; then
    echo "Error: Commit message is required."
    echo "Usage: ./gitdone.sh \"commit message here\""
    exit 1
fi

# Get the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Stage all changes
echo "Adding all changes..."
git add . || { echo "Error: Failed to add changes."; exit 1; }

# Commit with the provided message
echo "Committing changes..."
git commit -m "$1" || { echo "Error: Failed to commit changes."; exit 1; }

# Push to the current branch
echo "Pushing to the current branch '$current_branch'..."
git push origin "$current_branch" || { echo "Error: Failed to push changes."; exit 1; }

echo "Git process complete on branch '$current_branch'!"
