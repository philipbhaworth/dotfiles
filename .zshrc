# ====================
# My .zshrc file
# Description: Configuration file for zsh shell settings including environment paths, LS colors, man page colors, and an enhanced Git prompt.
# ====================

# ~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~
export PATH="/Users/hawrth/Library/Python/3.12/bin:$PATH"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH="/opt/puppetlabs/bin:$PATH"

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
    else
        ssh_message=""
    fi

    PROMPT="
    ${PROMPT_COLOR}${USERNAME_COLOR}%n ${RESET_COLOR}@ ${HOSTNAME_COLOR}%m ${VCS_COLOR}${ssh_message} ${PROMPT_COLOR}in ${INFO_COLOR}%~ ${RESET_COLOR}
    ${PROMPT_COLOR}❯${RESET_COLOR} "
    RPROMPT="${PROMPT_COLOR}[%@]${RESET_COLOR}"  # Display the current time in 12-hour format with AM/PM
fi

# ~~~~~~~~~~~~~~~ Aliases & Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# File management aliases
alias ls='ls --color=auto -lh'
alias ll='ls --color=auto -lah'
alias la='ls --color=auto -a'
alias l='ls --color=auto -lbGF'

# Directory navigation aliases
alias ob='cd ~/notes/digital-garden/ && ls -lh'
alias od='cd "/Users/hawrth/Library/CloudStorage/OneDrive-UniversityofIowa" && ls -lh'
alias rep='cd ~/repos/ && ls -lah'
alias repo='cd ~/repos/ && ls -lah'
alias repos='cd ~/repos/ && ls -lah'
alias my-vm='cd ~/repos/puppet_rs_vms/ && ls -lah'
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# SSH aliases
alias argon='ssh argon-itf-head.hpc.uiowa.edu' 
alias endor='ssh endor.hpc.uiowa.edu'

# System utilities
alias df='df -h'
alias du='du -h -c'
alias free='free -m'

# Network operations
alias ping='ping -c 5'

# Misc aliases
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias reload='source ~/.zshrc'

# Quick access to documentation
alias man='man -P "less -s"'

# System monitoring and performance
alias top='htop'
alias meminfo='free -h --si'
alias cpuinfo='lscpu'
alias disks='lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT'

# Git shortcuts
alias lg='lazygit'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'
alias gblame='git blame --show-name --show-number'

# Puppet Aliases
alias pedeploy='puppet-code deploy'
alias pelogin='puppet-access login --lifetime=4h hawrth'

# Safety features
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Notification for long-running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]+\s*//;s/[;&|]\s*alert$//'\'')"'

# ~~~~~~~~~~~~~~~ Load Additional Configurations ~~~~~~~~~~~~~~~~~~~~~~~~
eval $(thefuck --alias)

# Load zsh autosuggestions and syntax highlighting
if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
