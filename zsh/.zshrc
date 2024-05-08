# ====================
# My .zshrc file
# Description: Configuration file for zsh shell settings including environment paths, 
# LS colors, man page colors, and an enhanced Git prompt.
# ====================

# Path Configuration
# Adds Python 3.12 binaries to PATH for easy access to Python scripts and tools
export PATH="/Users/hawrth/Library/Python/3.12/bin:$PATH"

# This command appends the WezTerm path to your existing PATH variable and then exports PATH so the change is recognized
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH

# LS Colors
# Customize directory and file color codes for the 'ls' command to enhance visibility
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43'

# Man Page Colors
# Configures 'less' and 'man' page colors for better readability
export LESS='-R'
export MANPAGER='less -s'
export LESS_TERMCAP_mb=$(printf '\e[01;31m')       # Begin blinking
export LESS_TERMCAP_md=$(printf '\e[01;38;5;74m')  # Begin bold
export LESS_TERMCAP_me=$(printf '\e[0m')           # End mode
export LESS_TERMCAP_se=$(printf '\e[0m')           # End standout-mode
export LESS_TERMCAP_so=$(printf '\e[38;5;246m')    # Begin standout-mode (info box)
export LESS_TERMCAP_ue=$(printf '\e[0m')           # End underline
export LESS_TERMCAP_us=$(printf '\e[04;38;5;146m') # Begin underline

# Load Starship, if available
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    # Source the git-prompt.sh for Git repository status in the prompt
    # https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
    source /usr/share/git-core/contrib/completion/git-prompt.sh

    # Define a fallback prompt if Starship is not installed
    export PS1="%{$fg_bold[magenta]%}%n@%m%{$reset_color%} %{$fg_bold[yellow]%}%~%{$reset_color%} %{$fg_bold[cyan]%}\$(__git_ps1 '(%s)')%{$reset_color%} %{$fg_bold[magenta]%}❯%{$reset_color%} "
fi

# Aliases & Environment Variables
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
#alias lsl='ls -laGFh'
#alias ll='ls -laG'
#alias c='clear'
alias ob='cd ~/github/md-vaults/digital-garden/ && ls -l'

# Load Additional Configurations
if [[ -f ~/dotfiles/zsh/.zsh-aliases ]]; then
    source ~/dotfiles/zsh/.zsh-aliases
fi
if [[ -d ~/.zshrc.d ]]; then
    for rc_file in ~/.zshrc.d/*; do
        if [[ -f "$rc_file" ]]; then
            source "$rc_file"
        fi
    done
fi
unset rc_file

# Useful Tools
eval $(thefuck --alias fuck)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
