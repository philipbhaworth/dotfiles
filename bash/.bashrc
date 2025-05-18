# ====================
# My .bashrc file - Optimized
# Description: Configuration file for bash shell settings
# ====================

# ~~~~~~~~~~~~~~~ Core Settings ~~~~~~~~~~~~~~~~~~~~~~~~
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# -- Path Configuration --
# Add paths in single statement for better performance
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/scripts:$HOME/.local/opt/nvim-linux64/bin:$HOME/opt:$PATH"

# -- Set environment variables --
export CLICOLOR=1
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43'

# -- History Configuration --
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
shopt -s checkwinsize

# ~~~~~~~~~~~~~~~ Less Setup ~~~~~~~~~~~~~~~~~~~~~~~~
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Less settings for man pages
export LESS='-R'
export MANPAGER='less -s'
export LESS_TERMCAP_mb=$(printf '\e[01;31m')
export LESS_TERMCAP_md=$(printf '\e[01;38;5;74m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[38;5;246m')
export LESS_TERMCAP_ue=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[04;38;5;146m')

# ~~~~~~~~~~~~~~~ Prompt Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Load Starship with fallback
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  # Define colors once
  RED="\\[\\e[1;31m\\]"
  GREEN="\\[\\e[1;32m\\]"
  YELLOW="\\[\\e[1;33m\\]"
  BLUE="\\[\\e[1;34m\\]"
  CYAN="\\[\\e[1;36m\\]"
  WHITE="\\[\\e[1;37m\\]"
  ENDC="\\[\\e[0m\\]"

  # SSH detection
  [[ -n "$SSH_CLIENT" ]] && ssh_message="-ssh_session" || ssh_message=""

  # Set prompt
  PS1="
${GREEN}\u ${ENDC}@ ${YELLOW}\h ${RED}${ssh_message} ${WHITE}in ${BLUE}\w ${ENDC}
${CYAN}❯${ENDC} "

  # Terminal title
  case "$TERM" in
  xterm* | rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
  esac
fi

# ~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~
# Navigation helper - replaces multiple cd aliases
up() {
  cd $(printf "%0.0s../" $(seq 1 ${1:-1}))
}

# Reload configuration
bash_reload() {
  source ~/.bashrc
  echo "Bash config reloaded!"
}

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
# File listing (try using lsd if available)
if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd -lh'
  alias la='lsd -la'
  alias ll='lsd -lah --group-dirs=none'
  alias l='lsd -lG --group-dirs=none'
else
  alias ls='ls -lh --color=auto'
  alias la='ls -a --color=auto'
  alias ll='ls -lah --color=auto'
  alias l='ls -lbGF --color=auto'
  alias lld='ls -lah --color=auto --group-directories-first'
fi

# Navigation shortcuts
alias ob='cd ~/notes/digital-garden/ && ls'
alias dow='cd ~/Downloads && ll'
alias dot='cd ~/git/dotfiles && ll'
alias config='cd ~/.config && ll'
alias repo='cd ~/git && ll'

# Safety features
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Utilities
alias grep='grep --color=auto'
alias tree='tree -C'
alias h='history'
alias c='clear'
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.bashrc'

# Config editing
alias edbash='vim ~/git/dotfiles/.bashrc'
alias edvim='vim ~/git/dotfiles/.vimrc'
alias edtmu='vim ~/git/dotfiles/.tmux.conf'

# Git shortcuts
alias lg='lazygit'
alias gs='git status'

# Notification for long commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//'\'')"'

# ~~~~~~~~~~~~~~~ Additional Configurations ~~~~~~~~~~~~~~~~~~~~~~~~
# Source all configuration files in .bashrc.d directory
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

# ~~~~~~~~~~~~~~~ End of .bashrc ~~~~~~~~~~~~~~~~~~~~~~~~
