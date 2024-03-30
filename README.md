# Dotfiles Repository

Welcome to my dotfiles repository! This collection of configuration files and scripts is designed to simplify and automate the setup of my personal computing environment, making it as portable and efficient as possible.

## Table of Contents
- [Dotfiles Repository](#dotfiles-repository)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Repository Structure](#repository-structure)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation Steps](#installation-steps)
    - [Follow Prompts](#follow-prompts)
  - [License](#license)

## Introduction

This repository contains configuration files (dotfiles) and scripts used to customize my command-line and desktop environment across different Linux Distros. The aim here is to create a setup that supports both my academic pursuits and personal life seamlessly. By sharing these dotfiles, I hope not only to keep my own environment easily replicable across different machines but also to assist others who might find my setup useful.Feel free to explore and adapt these configurations to suit your own preferences, that is how I am learning!

## Repository Structure
The repository is organized into several directories, each containing configurations for specific tools or applications:

```
├── bash/
│   ├── .bash-aliases  # Aliases to shorten command lines and improve efficiency.
│   ├── .bash-functions  # Custom functions for the Bash shell.
│   ├── .bashrc  # Main configuration file for Bash, setting up the shell environment.
│   └── old-bash-versions/
│       └── .bash-aliases-v1  # Older version of Bash aliases for compatibility.
├── dotconfig/
│   ├── geany/  # Configuration files and themes for the Geany text editor.
│   ├── lsd/  # Configuration for LSD, the modern ls command.
│   ├── ranger/  # Configuration files for the Ranger file manager.
│   │   ├── commands_full.py  # Extended command definitions for Ranger.
│   │   ├── commands.py  # Default command definitions for Ranger.
│   │   ├── rc.conf  # Main Ranger configuration file.
│   │   ├── rifle.conf  # File association configurations for Ranger.
│   │   └── scope.sh  # Script for file preview within Ranger.
│   ├── starship.toml  # Configuration for the Starship prompt in the shell.
│   └── tilix/  # Configuration files for the Tilix terminal emulator.
│       └── schemes/  # Color schemes for Tilix.
├── .gitconfig  # Global Git configuration settings.
├── neofetch/
│   └── config.conf  # Configuration file for Neofetch, a system information tool.
├── README.md  # Documentation for the repository, including setup and configuration.
├── server-setup-scripts/
│   ├── server-bootstrap.sh  # Script for initial server setup and configurations.
│   └── ufw-config-script.sh  # Script for setting up Uncomplicated Firewall (UFW).
├── terminals/
│   └── .wezterm.lua  # Configuration for WezTerm, a GPU-accelerated terminal emulator.
├── vim-config/
│   └── .vimrc  # Configuration file for Vim, customizing the editor's behavior.
└── workstation-setup-scripts/
    ├── bootstrap-v3.sh  # Bootstrap script for setting up Fedora or Debian based systems.
    ├── debian-bootstrap.sh  # Setup script for Debian-based systems.
    ├── endeavor-bootstrap.sh  # Setup script for EndeavourOS, an Arch-based system.
    ├── fedora-bootstrap.sh  # Setup script for Fedora systems.
    ├── old-scripts/
    │   ├── bootstrap-v1.sh  # Original bootstrap script for older system setups.
    │   └── bootstrap-v2.sh  # Second version of the bootstrap script with updates.
    └── opensuse-bootstrap.sh  # Setup script for openSUSE systems.
```

## Getting Started

### Prerequisites

Before you begin, make sure you have:
- **Git**: Needed for cloning this repository.
- **Bash Shell**: Required to run the scripts.

### Installation Steps

1. **Clone the Repository**

   Start by cloning this repository into your home directory:
   ```bash
   git clone https://github.com/philipbhaworth/dotfiles.git ~/dotfiles
   ```

2. **Run the Bootstrap Script**

   Navigate to the `workstation-setup-scripts` directory and execute the bootstrap script:
   ```bash
   cd ~/dotfiles/workstation-setup-scripts/
   ./bootstrap-v3.sh
   ```

   This script will perform the following actions:
   - Link dotfiles for bash, vim, and WezTerm.
   - Update your system and install essential packages.
   - Configure Git with your user information.
   - Install selected applications via Flatpak.

### Follow Prompts

During the execution of the script, you may be prompted to:
- Enter your **sudo password** for permissions.
- Provide **Git configuration details** (user name and email).

Please follow the on-screen instructions to complete the setup process.

## License
This project is licensed under the [MIT License](LICENSE).
