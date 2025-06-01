#!/bin/bash

# Function to remove and create symbolic links for dotfiles
setup_dotfiles() {
    printf "Setting up dotfiles...\n"
    
    # Backup and link .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        mv "$HOME/.bashrc" "$HOME/.bashrc.bak" || { echo "Failed to back up .bashrc. Exiting."; exit 1; }
    fi
    ln -s "$HOME/dotfiles/.bashrc" "$HOME/.bashrc" || { echo "Failed to create symbolic link for .bashrc. Exiting."; exit 1; }
    
    # Link other dotfiles
    ln -s "$HOME/dotfiles/.vimrc" "$HOME/.vimrc" || { echo "Failed to create symbolic link for .vimrc. Exiting."; exit 1; }
    ln -s "$HOME/dotfiles/.tmux.conf" "$HOME/.tmux.conf" || { echo "Failed to create symbolic link for .tmux.conf. Exiting."; exit 1; }
    
    printf "Dotfiles setup complete.\n"
}

# Main function
main() {
    setup_dotfiles
    printf "Setup complete. The wheel is yours!\n"
}

# Execute the main function
main