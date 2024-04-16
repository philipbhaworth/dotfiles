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

# Prompt Customization
autoload -Uz vcs_info
precmd() { vcs_info }
setopt PROMPT_SUBST

# Direct color codes
PROMPT='%F{magenta}%n@%m %F{yellow}%~ %F{cyan}${vcs_info_msg_0_}%f %F{magenta}❯%f '

# Aliases & Environment Variables
# Enables color formatting in 'ls' and specifies color schemes
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias lsl='ls -laGFh'  # 'ls' command with color, file type indicator, and human-readable sizes
alias ll='ls -laG'
alias c='clear'
alias ob='cd ~/github/md-vaults/uiowa-it-vault/ && ls -l'

# Shared aliases
if [[ -f ~/dotfiles/zsh/.zsh-aliases ]]; then
    source ~/dotfiles/zsh/.zsh-aliases
fi

# Include other zsh-specific configurations if you have them
# If you plan to organize zsh scripts similar to .bashrc.d, you can use:
# if [[ -d ~/.zshrc.d ]]; then
#     for rc_file in ~/.zshrc.d/*; do
#         if [[ -f "$rc_file" ]]; then
#             source "$rc_file"
#         fi
#     done
# fi
# unset rc_file


# You can use whatever you want as an alias, like for Mondays:
eval $(thefuck --alias fuck)

# Load fzf if available
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

