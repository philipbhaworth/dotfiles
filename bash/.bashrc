#!/bin/bash
# shellcheck shell=bash
# ====================
# Homelab .bashrc - Optimized
# ====================

# ~~~~~~~~~~~~~~~ Core Settings ~~~~~~~~~~~~~~~~~~~~~~~~
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Add paths without recursive scanning
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~
export CLICOLOR=1
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43'
export EDITOR=vim

# ~~~~~~~~~~~~~~~ History Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend

# ~~~~~~~~~~~~~~~ Prompt Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Use Starship if available
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
else
    # Simple fallback prompt
    PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '
fi

# ~~~~~~~~~~~~~~~ Core Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
# Modern ls with lsd fallback
if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd --group-dirs first'
    alias ll='lsd -alh --group-dirs first'
    alias lt='lsd --tree -a -I ".git|__pycache__|.mypy_cache|.ipynb_checkpoints"'
else
    alias ls='ls --color=auto'
    alias ll='ls -alh --color=auto'
fi

# Navigation
alias ansi='cd ~/repos/ansible-homelab/ && ll'
alias repo='cd ~/repos/ && ll'
alias dot='cd ~/dotfiles && ll'
alias compose='cd ~/repos/ansible-homelab/files/docker-compose && ll'

# Utilities
alias c='clear'
alias grep='grep --color=auto'
alias tree='tree -C'
alias reload='source ~/.bashrc && echo "Reloaded!"'

# Git
alias gs='git status'
if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi

# Ansible shortcuts (if you use bash for ansible work)
alias ap='ansible-playbook -i inventory.yml playbooks/'
alias aping='ansible all -i inventory.yml -m ping'

# ~~~~~~~~~~~~~~~ Bash Completion ~~~~~~~~~~~~~~~~~~~~~~~~
# Load completion if available (fast check)
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
# ~~~~~~~~~~~~~~~ SSH Agent Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Robust ssh-agent setup with persistent environment for multiple sessions
start_ssh_agent() {
    SSH_ENV="$HOME/.ssh/ssh-agent-environment"
    
    # Function to start new agent
    start_new_agent() {
        ssh-agent | head -2 > "${SSH_ENV}"
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        ssh-add ~/.ssh/id_homelab_keys 2>/dev/null
        echo "SSH agent started and key added"
    }
    
    # Check if environment file exists and load it
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        
        # Test if the agent is still running
        if ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
            # Agent died, start new one
            start_new_agent
        elif ! ssh-add -l > /dev/null 2>&1; then
            # Agent running but no keys loaded
            ssh-add ~/.ssh/id_homelab_keys 2>/dev/null
        fi
    else
        # No environment file exists, start new agent
        start_new_agent
    fi
}

# Start ssh-agent for interactive shells only
start_ssh_agent
