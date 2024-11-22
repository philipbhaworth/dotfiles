# ====================
# My .bashrc file
# Description: Configuration file for bash shell settings including environment paths, history control, and an enhanced Git prompt.
# ====================

# ~~~~~~~~~~~~~~~ Basic Setup ~~~~~~~~~~~~~~~~~~~~~~~~
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Add user-specific paths
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/.local/opt/nvim-linux64/bin"
export PATH="$PATH:$HOME/opt"
export PATH="$HOME/dotfiles/scripts:$PATH"

# ~~~~~~~~~~~~~~~ History Control ~~~~~~~~~~~~~~~~~~~~~~~~
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# ~~~~~~~~~~~~~~~ Less Setup ~~~~~~~~~~~~~~~~~~~~~~~~
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
force_color_prompt=yes

# ~~~~~~~~~~~~~~~ Prompt Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Color codes
RED="\\[\\e[1;31m\\]"
GREEN="\\[\\e[1;32m\\]"
YELLOW="\\[\\e[1;33m\\]"
BLUE="\\[\\e[1;34m\\]"
MAGENTA="\\[\\e[1;35m\\]"
CYAN="\\[\\e[1;36m\\]"
WHITE="\\[\\e[1;37m\\]"
ENDC="\\[\\e[0m\\]"

# Set a two-line prompt. If accessing via ssh include 'ssh-session' message.
if [[ -n "$SSH_CLIENT" ]]; then ssh_message="-ssh_session"; fi
PS1="${MAGENTA}\t ${GREEN}\u ${WHITE}@ ${YELLOW}\h${RED}${ssh_message} ${WHITE}in ${BLUE}\w \n${CYAN}❯${ENDC} "


# PS1='\[\033[01;37m\][\A] \[\033[01;32m\](\u) \[\033[01;34m\]| \w \[\033[00m\]$ '

# Initialize Starship, if available
if command -v starship >/dev/null 2>&1; then
   eval "$(starship init bash)"
fi

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
# File management
#alias ls='ls -lh --color=auto'
#alias ll='ls -lah --group-directories-first --color=auto'
#alias la='ls -a --color=auto'
#alias l='ls -lbGF --color=auto'

# Use lsd for ls commands
alias ls='lsd -lh'
alias la='lsd -la'                     # List all files, including hidden ones
alias ll='lsd -lah --group-dirs=none'  # Group files before directories
alias l='lsd -lG --group-dirs=none'         # Long listing format


# Directory navigation
alias ob='cd ~/notes/digital-garden/ && ls -l --color=auto'

# System utilities
alias df='df -h'
alias du='du -h -c'
alias free='free -m'

# Network operations
# alias ping='ping -c 5'

# Misc
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'

# Enhanced navigation and file management
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias dot='cd ~/dotfiles && ll'
alias dots='cd ~/dotfiles && ll'
alias config='cd ~/.config && ll'
alias tree='tree -C'
alias h='history'
alias c='clear'
alias path='echo -e ${PATH//:/\\n}'

# Quick editing of config files
alias edbashrc='vim ~/.bashrc'
alias edvimrc='vim ~/.vimrc'
alias edalias='vim ~/dots/bash/.bash-aliases'
alias reload='source ~/.bashrc'

# System monitoring and performance
alias top='htop'
alias meminfo='free -h --si'
alias cpuinfo='lscpu'
alias disks='lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT'

# Git shortcuts
alias gf='git fetch'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'
alias gblame='git blame --show-name --show-number'
# alias gd = "!f() { git add . && git commit -m \"$1\" && git push origin main; }; f"
alias gitdone='gitdone.sh'

# Safety features
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Notification for long-running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//'\'')"'

# ~~~~~~~~~~~~~~~ Additional Configurations ~~~~~~~~~~~~~~~~~~~~~~~~
# Source additional aliases and functions (commented out)
# if [ -f ~/dotfiles/bash/.bash-aliases ]; then
#     . ~/dotfiles/bash/.bash-aliases
# fi
# if [ -f ~/dotfiles/bash/.bash-functions ]; then
#     . ~/dotfiles/bash/.bash-functions
# fi
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# ~~~~~~~~~~~~~~~ Programmable Completion ~~~~~~~~~~~~~~~~~~~~~~~~
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~
export EDITOR="nvim"
export VISUAL="nvim"

