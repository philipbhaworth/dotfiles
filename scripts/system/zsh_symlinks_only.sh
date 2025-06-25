#!/bin/bash

# Function to remove and create symbolic links for dotfiles
setup_dotfiles() {
    printf "Setting up dotfiles...\n"

    # Backup and link .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak" || { echo "Failed to back up .zshrc. Exiting."; exit 1; }
    fi
    ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc" || { echo "Failed to create symbolic link for .zshrc. Exiting."; exit 1; }

    # Link other dotfiles
    ln -sf "$HOME/dotfiles/.vimrc" "$HOME/.vimrc" || { echo "Failed to create symbolic link for .vimrc. Exiting."; exit 1; }
    ln -sf "$HOME/dotfiles/.tmux.conf" "$HOME/.tmux.conf" || { echo "Failed to create symbolic link for .tmux.conf. Exiting."; exit 1; }

    printf "Dotfiles setup complete.\n"
}

# Main function
main() {
    setup_dotfiles
    printf "Setup complete. The wheel is yours!\n"
}

# Execute the main function
main

