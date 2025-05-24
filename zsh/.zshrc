# ====================
# My .zshrc file - Optimized
# Description: Configuration file for zsh shell settings
# ====================

# ~~~~~~~~~~~~~~~ Core Settings ~~~~~~~~~~~~~~~~~~~~~~~~
# -- Path Configuration --
# Add paths in single statement for better performance
export PATH="/Users/hawrth/Library/Python/3.12/bin:/Applications/WezTerm.app/Contents/MacOS:$PATH"

# -- Set environment variables --
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43'

# -- History Configuration --
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# ~~~~~~~~~~~~~~~ Completion System ~~~~~~~~~~~~~~~~~~~~~~~~
# Load completion only if needed (improved performance)
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ~~~~~~~~~~~~~~~ Prompt Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Load Starship with fallback
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Simplified Prompt Setup with optimized color definitions
  setopt PROMPT_SUBST

  # Define colors once
  typeset -A colors
  colors[username]="%F{green}"
  colors[hostname]="%F{yellow}"
  colors[reset]="%f"
  colors[prompt]="%F{white}"
  colors[info]="%F{blue}"
  colors[vcs]="%F{red}"

  # SSH detection
  [[ -n "$SSH_CLIENT" ]] && ssh_message="-ssh_session" || ssh_message=""

  # Set prompt
  PROMPT="
  ${colors[prompt]}${colors[username]}%n ${colors[reset]}@ ${colors[hostname]}%m ${colors[vcs]}${ssh_message} ${colors[prompt]}in ${colors[info]}%~ ${colors[reset]}
  ${colors[prompt]}❯${colors[reset]} "
  RPROMPT="${colors[prompt]}[%@]${colors[reset]}"
fi

# ~~~~~~~~~~~~~~~ Man Page Colors ~~~~~~~~~~~~~~~~~~~~~~~~
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

# ~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~
# Navigation helper - replaces multiple cd aliases
up() {
  cd $(printf "%0.0s../" $(seq 1 ${1:-1}))
}

# Reload configuration - using a different name to avoid conflict with alias
zsh_reload() {
  source ~/.zshrc
  echo "ZSH config reloaded!"
}

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
# File listing (using lsd for enhanced output)
alias ls='lsd -lh'
alias la='lsd -la'
alias ll='lsd -lah --group-dirs=none'
alias l='lsd -lG --group-dirs=none'

# Navigation shortcuts
alias ob='cd ~/notes/digital-garden/ && ls'
alias dow='cd ~/Downloads && ll'
alias dot='cd ~/repos/dotfiles && ll'
alias config='cd ~/.config && ll'
alias repo='cd ~/repos/ && ll'
alias ansi='cd ~/repos/ansible/ && ll'


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
alias reload='source ~/.zshrc'

# Config editing
alias edzsh='vim ~/git/dotfiles/.zshrc'
alias edvim='vim ~/git/dotfiles/.vimrc'
alias edtmu='vim ~/git/dotfiles/.tmux.conf'

# Git shortcuts
alias lg='lazygit'
alias gs='git status'

# Notification for long commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//'\'')"'

# ~~~~~~~~~~~~~~~ Plugins ~~~~~~~~~~~~~~~~~~~~~~~~
# Check for Homebrew before loading plugins
if command -v brew >/dev/null 2>&1; then
  # Load autosuggestions
  if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi

  # Load syntax highlighting - load last for best performance
  if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$(brew --prefix)/share/zsh-syntax-highlighting/highlighters"
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
fi

# ~~~~~~~~~~~~~~~ End of .zshrc ~~~~~~~~~~~~~~~~~~~~~~~~
