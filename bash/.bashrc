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
# Default Ubuntu Prompt
# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Uncomment for a colored prompt if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac


# PS1='\[\033[01;37m\][\A] \[\033[01;32m\](\u) \[\033[01;34m\]| \w \[\033[00m\]$ '

# Initialize Starship, if available
if command -v starship >/dev/null 2>&1; then
   eval "$(starship init bash)"
fi

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
# File management
alias ls='ls -lh --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -a --color=auto'
alias l='ls -lbGF --color=auto'

# Directory navigation
alias ob='cd ~/notes/digital-garden/ && ls -l --color=auto'

# System utilities
alias df='df -h'
alias du='du -h -c'
alias free='free -m'

# Network operations
alias ping='ping -c 5'

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
export MICRO_TRUECOLOR=1
