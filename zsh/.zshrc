# ====================
# Homelab .zshrc - Management/Control Node
# Works on both macOS and Ubuntu
# ====================

# ~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# Common paths
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# macOS-specific Python path (only on Mac)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/Users/$(whoami)/Library/Python/3.13/bin:$PATH"
fi

# ~~~~~~~~~~~~~~~ Environment for Colors ~~~~~~~~~~~~~~~~~~~~~~~~
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43'
export EDITOR=vim

# ~~~~~~~~~~~~~~~ Fast History ~~~~~~~~~~~~~~~~~~~~~~~~
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# ~~~~~~~~~~~~~~~ Quick Completion ~~~~~~~~~~~~~~~~~~~~~~~~
autoload -Uz compinit && compinit -C

# ~~~~~~~~~~~~~~~ Starship Prompt ~~~~~~~~~~~~~~~~~~~~~~~~
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# ~~~~~~~~~~~~~~~ Core Aliases ~~~~~~~~~~~~~~~~~~~~~~~~
# Modern ls with lsd
if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd --group-dirs first'
    alias ll='lsd -alh --group-dirs first'
    alias lt='lsd --tree -a -I ".git|__pycache__|.mypy_cache|.ipynb_checkpoints"'
else
    alias ls='ls --color=auto'
    alias ll='ls -alh --color=auto'
fi

# Navigation
alias ansi='cd ~/git/ansible-homelab/ && ll'
alias dev='cd ~/dev/ && ll'
alias dot='cd ~/dotfiles/ && ll'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'



# macOS-specific navigation
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ob='cd ~/notes/grep-garden/ && ls'
fi

# Utilities
alias c='clear'
alias grep='grep --color=auto'
alias tree='tree -C'

# Git
if command -v lazygit >/dev/null 2>&1; then
    alias lg='lazygit'
fi

# Maintenance
alias reload='source ~/.zshrc'

# macOS-specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias brewup='brew update && brew upgrade && brew cleanup'
fi

# ~~~~~~~~~~~~~~~ Plugins (cross-platform) ~~~~~~~~~~~~~~~~~~~~~~~~

# Autosuggestions
if [[ "$OSTYPE" == "darwin"* ]]; then
    plugin_path="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
    plugin_path="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
[ -f "$plugin_path" ] && source "$plugin_path" && echo "Loaded: zsh-autosuggestions"

# Syntax Highlighting
if [[ "$OSTYPE" == "darwin"* ]]; then
    plugin_path="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    plugin_path="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
[ -f "$plugin_path" ] && source "$plugin_path" && echo "Loaded: zsh-syntax-highlighting"


# ~~~~~~~~~~~~~~~ Atuin ~~~~~~~~~~~~~~~~~~~~~~~~
if [ -f "$HOME/.atuin/bin/env" ]; then
    . "$HOME/.atuin/bin/env"
    if command -v atuin >/dev/null 2>&1; then
        eval "$(atuin init zsh)" || echo "Warning: atuin init failed"
    fi
fi

