# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History control
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and update LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Fancy prompt setup
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
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
    PS1="\[\e]0;${debian_chroot:+($debian chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Color support for ls and handy aliases, if available
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Custom bin directories added to PATH
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/opt/nvim-linux64/bin:$PATH"
export PATH="$HOME/opt:$PATH"

# Source .bash-aliases if it exists
if [ -f ~/dotfiles/bash/.bash-aliases ]; then
    . ~/dotfiles/bash/.bash-aliases
fi

# Source .bash-functions if it exists
if [ -f ~/dotfiles/bash/.bash-functions ]; then
    . ~/dotfiles/bash/.bash-functions
fi

# Programmable completion features (only if not turned on globally)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source /home/philipb/.config/broot/launcher/bash/br

