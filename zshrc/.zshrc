# ====================
# My .zshrc file
# Description: Configuration file for zsh shell settings including environment paths, LS colors, man page colors, and an enhanced Git prompt.
# ====================

# ~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
export PATH="/Users/hawrth/Library/Python/3.12/bin:$PATH"
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH




# ~~~~~~~~~~~~~~~ LS Colors ~~~~~~~~~~~~~~~~~~~~~~~~
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43'

# ~~~~~~~~~~~~~~~ Man Page Colors ~~~~~~~~~~~~~~~~~~~~~~~~
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
# Load Starship, if available
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Simplified Prompt Setup for Fallback using specified colors
  setopt PROMPT_SUBST

  # Colors for various parts of the prompt
  USERNAME_COLOR="%F{green}"        # Green for username
  HOSTNAME_COLOR="%F{yellow}"       # Yellow for hostname
  RESET_COLOR="%f"                  # Reset formatting
  PROMPT_COLOR="%F{white}"          # White for main parts of the prompt
  INFO_COLOR="%F{blue}"             # Blue for directory path
  VCS_COLOR="%F{red}"               # Red for version control system info

  # Set a two-line prompt. If accessing via ssh, include 'ssh-session' message.
  if [[ -n "$SSH_CLIENT" ]]; then
      ssh_message="-ssh_session"
  fi
  PROMPT="
  ${PROMPT_COLOR}${USERNAME_COLOR}%n ${RESET_COLOR}@ ${HOSTNAME_COLOR}%m ${VCS_COLOR}${ssh_message} ${PROMPT_COLOR}in ${INFO_COLOR}%~ ${RESET_COLOR}
  ${PROMPT_COLOR}❯${RESET_COLOR} "
  RPROMPT="${PROMPT_COLOR}[%@]${RESET_COLOR}"  # Display the current time in 12-hour format with AM/PM

  # No heavy Git status in fallback to improve performance
fi


# ~~~~~~~~~~~~~~~ fzf Configuration ~~~~~~~~~~~~~~~~~~~~~~~~

# Enable fzf keybindings
source <(fzf --zsh)

# Environment variables for fzf (ignoring .git directories)
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/.git/*'"

# fzf Aliases and Functions
# Fuzzy File Finder with preview (ignoring .git directories)
#alias ff="fzf --preview 'bat --style=numbers --color=always {} || cat {}'"
alias ff="fzf --preview 'bat --style=numbers --color=always {} || cat {}' --bind 'enter:execute(vim {})'"

# Fuzzy Directory Navigation (ignoring .git directories)
alias fd="cd \$(find . -type d -not -path '*/.git/*' | fzf)"

# Git Branch Checkout
alias fgb="git checkout \$(git branch --all | fzf)"

# Git File Diff Viewer
alias gf="git diff --name-only | fzf | xargs -o vim"

# Search Git log
alias gl="git log --oneline | fzf | awk '{print \$1}' | xargs git show"

# Command History Search
alias fh="history | fzf | awk '{print \$2}' | xargs zsh -c"

# Process Killer
alias fkill="ps -ef | fzf | awk '{print \$2}' | xargs kill -9"

# Directory Bookmarks
alias mark="pwd >> ~/.fzf-bookmarks"
alias j="cat ~/.fzf-bookmarks | fzf | xargs cd"

# Open files in Finder (macOS, ignoring .git directories)
alias ffinder="open \$(find . -type f -not -path '*/.git/*' | fzf)"

# SSH Connection Manager
alias fssh="cat ~/.ssh/config | grep 'Host ' | awk '{print \$2}' | fzf | xargs ssh"


# ~~~~~~~~~~~~~~~ Other Aliases & Configurations ~~~~~~~~~~~~~~~~~~~~~~~~

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# File management
#alias ls='ls -lh'
#alias ll='ls -lah'
#alias la='ls -a'
#alias l='ls -lbGF'

# Use lsd for ls commands
alias ls='lsd -lh'
alias la='lsd -la'                     # List all files, including hidden ones
alias ll='lsd -lah --group-dirs=none'  # Group files before directories
alias l='lsd -lG --group-dirs=none'         # Long listing format


# Directory navigation
alias ob='cd ~/Documents/digital-garden/ && ls -lh'
#alias od='cd /Users/hawrth/Library/CloudStorage/OneDrive\-UniversityofIowa && ls -lh'
#alias rep='cd ~/repos/ && ls -lah'
#alias repo='cd ~/repos/ && ls -lah'
#alias repos='cd ~/repos/ && ls -lah'
#alias my-vm='cd ~/repos/puppet_rs_vms/ && ls -lah'
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# SSH aliases
#alias argon='ssh argon-itf-head.hpc.uiowa.edu'
#alias endor='ssh endor.hpc.uiowa.edu'

# System utilities
alias df='df -h'
alias du='du -h -c'
alias free='free -m'

# Network operations
#alias ping='ping -c 5'

# Misc
alias grep='grep --color=auto'
#alias mkdir='mkdir -pv'

# Reload the .zshrc file
alias reload='source ~/.config/zshrc/.zshrc'

# Enhanced navigation and file management
alias dow='cd ~/Downloads && ll'
alias down='cd ~/Downloads && ll'
alias dot='cd ~/dotfiles && ll'
alias dots='cd ~/dotfiles && ll'
alias config='cd ~/.config && ll'
alias tree='tree -C'
alias h='history'
alias c='clear'
alias path='echo -e ${PATH//:/\\n}'

# Quick editing of config files
alias edzsh='vim ~/dotfiles/zshrc/.zshrc'
alias edvim='vim ~/dotfiles/.vimrc'
alias edtmu='vim ~/dotfiles/.tmux.conf'

# System monitoring and performance
alias meminfo='free -h --si'
alias cpuinfo='lscpu'
alias disks='lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT'

# Git shortcuts
alias lg='lazygit'
alias gs='git status'
alias ga='git add'
#alias gc='git commit -m'
#alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'
alias gblame='git blame --show-name --show-number'

# Puppet Aliases
# add repo name --wait to this command
alias pedeploy='puppet-code deploy'
alias pelogin='puppet-access login --lifetime=4h hawrth'

# Safety features
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Quick access to documentation
alias man='man -P "less -s"'

# Notification for long-running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//'\'')"'

# zsh-autosuggestions - https://github.com/zsh-users/zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting - https://github.com/zsh-users/zsh-syntax-highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
