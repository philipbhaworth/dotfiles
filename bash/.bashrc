# Common setup for both Fedora and Debian/Ubuntu

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Prevent ranger from loading the default rc.conf
export RANGER_LOAD_DEFAULT_RC=FALSE

# Source global definitions (Fedora specific, but harmless on Debian/Ubuntu)
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# History control (Debian/Ubuntu specific, but useful in any distro)
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# Make less more friendly for non-text input files, and setup for fancy prompt
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
force_color_prompt=yes

# Detect the distribution and apply specific settings
if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu-specific configurations
    alias update='sudo apt update && sudo apt upgrade'
    # Custom Debian/Ubuntu PATH additions
    export PATH="$HOME/scripts:$PATH"
    export PATH="$HOME/.local/opt/nvim-linux64/bin:$PATH"
    export PATH="$HOME/opt:$PATH"
elif [ -f /etc/fedora-release ]; then
    # Fedora-specific configurations
    alias update='sudo dnf update'
    # Fedora specific alias or PATH adjustments can go here
fi

# Shared aliases and functions
if [ -f ~/dotfiles/bash/.bash-aliases ]; then
    . ~/dotfiles/bash/.bash-aliases
fi
if [ -f ~/dotfiles/bash/.bash-functions ]; then
    . ~/dotfiles/bash/.bash-functions
fi
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Programmable completion features (only if not turned on globally)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Additional setup for fancy prompt, completion, etc., can be added here

PS1='\[\e[32m\]\u@\h:\[\e[34m\]\w\[\e[31m\]$(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\e[00m\] \$ '

# Ensure this is at the end of your .bashrc file
source /home/philipb/.config/broot/launcher/bash/br

