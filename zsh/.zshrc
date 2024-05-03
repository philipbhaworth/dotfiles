# ====================
# My .zshrc file
# Description: Configuration file for zsh shell settings including environment paths, 
# LS colors, man page colors, and an enhanced Git prompt.
# ====================

# Path Configuration
export PATH="/Users/hawrth/Library/Python/3.12/bin:$PATH"
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# LS Colors
export LS_COLORS='di=34:ln=36:so=35:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=30;43'

# Man Page Colors
export LESS='-R'
export MANPAGER='less -s'
export LESS_TERMCAP_mb=$(printf '\e[01;31m')
export LESS_TERMCAP_md=$(printf '\e[01;38;5;74m')
export LESS_TERMCAP_me=$(printf '\e[0m')
export LESS_TERMCAP_se=$(printf '\e[0m')
export LESS_TERMCAP_so=$(printf '\e[38;5;246m')
export LESS_TERMCAP_ue=$(printf '\e[0m')
export LESS_TERMCAP_us=$(printf '\e[04;38;5;146m')

# Prompt Customization with Git Enhancements
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}✔%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}✗%f'
zstyle ':vcs_info:git:*' formats '%b %c%u'
zstyle ':vcs_info:git:*' actionformats '%b %p|%F{blue}⇡%f %c%u'

precmd() {
  vcs_info
  if [[ -n ${vcs_info_msg_0_} ]]; then
    [[ $(git diff --cached --quiet HEAD 2>/dev/null; echo $?) == 1 ]] && vcs_info_msg_0_+="${stagedstr}"
    [[ $(git diff-files --quiet 2>/dev/null; echo $?) == 1 ]] && vcs_info_msg_0_+="${unstagedstr}"
  fi
}

setopt PROMPT_SUBST

# Set colors for the prompt elements
USERNAME_COLOR="%F{blue}"
HOSTNAME_COLOR="%F{green}"
RESET_COLOR="%f"
PROMPT_COLOR="%F{magenta}"
INFO_COLOR="%F{yellow}"
VCS_COLOR="%F{cyan}"

# Update the PROMPT variable
PROMPT="${PROMPT_COLOR}┌─[${USERNAME_COLOR}%n${RESET_COLOR}@${HOSTNAME_COLOR}%m ${INFO_COLOR}%~ ${VCS_COLOR}${vcs_info_msg_0_}${RESET_COLOR}${PROMPT_COLOR}]
${PROMPT_COLOR}└─❯${RESET_COLOR} "
RPROMPT="${PROMPT_COLOR}[%@]${RESET_COLOR}"

# Aliases & Environment Variables
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ob='cd ~/github/md-vaults/uiowa-it-vault/ && ls -l'

# Load Additional Configurations
if [[ -f ~/dotfiles/zsh/.zsh-aliases ]]; then
    source ~/dotfiles/zsh/.zsh-aliases
fi
if [[ -d ~/.zshrc.d ]]; then
    for rc_file in ~/.zshrc.d/*; do
        [[ -f "$rc_file" ]] && source "$rc_file"
    done
fi

# Useful Tools
eval $(thefuck --alias fuck)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
