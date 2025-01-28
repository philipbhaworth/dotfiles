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
alias ob='cd ~/notes/digital-garden/ && ls -lh'
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# Misc
alias grep='grep --color=auto'

# Reload the .zshrc file
alias reload='source ~/.zshrc'

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
alias edzsh='vim ~/dotfiles/.zshrc'
alias edvim='vim ~/dotfiles/.vimrc'
alias edtmu='vim ~/dotfiles/.tmux.conf'

# Git shortcuts
alias lg='lazygit'
alias gs='git status'

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
