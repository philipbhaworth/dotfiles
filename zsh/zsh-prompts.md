# Simple Prompt

PROMPT='
%F{magenta}%n@%m %F{yellow}%~ %F{cyan}${vcs_info_msg_0_}%f
%F{magenta}❯%f '

---
# Prompt with lines and brackets

PROMPT='
%F{magenta}┌─[%f%n@%m%F{magenta}]─[%F{yellow}%~%F{magenta}]─[%F{cyan}${vcs_info_msg_0_}%f%F{magenta}]─┐
%F{magenta}└─❯%f '

---
# Prompt with just lines

PROMPT='
%F{magenta}┌─[%f%n@%m %F{yellow}%~ %F{cyan}${vcs_info_msg_0_}%f%F{magenta}]
%F{magenta}└─❯%f '

---
# Prompt with 3 simple git status indicators - current

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
    if [[ $(git diff --cached --quiet HEAD 2>/dev/null; echo $?) == 1 ]]; then
      vcs_info_msg_0_="${vcs_info_msg_0_} ${stagedstr}"
    fi
    if [[ $(git diff-files --quiet 2>/dev/null; echo $?) == 1 ]]; then
      vcs_info_msg_0_="${vcs_info_msg_0_} ${unstagedstr}"
    fi
  fi
}

setopt PROMPT_SUBST

PROMPT='%F{magenta}┌─[%f%n@%m %F{yellow}%~ %F{cyan}${vcs_info_msg_0_}%f%F{magenta}]
%F{magenta}└─❯%f '


---
The symbols in your prompt are indicators of the status of your Git repository. Here's what each symbol represents:

- **Green Check Mark (✔)**: This symbol appears when you have changes that have been added to the staging area (i.e., after running `git add`). These changes are ready to be committed.

- **Red Cross (✗)**: This symbol appears when you have changes in your working directory that have not been staged yet (i.e., changes that have not been added using `git add`).

- **Blue Arrow (⇡)**: This symbol appears when your local branch is ahead of the remote branch, indicating that you have commits that need to be pushed to the remote repository.

These symbols provide a quick visual summary of the state of your Git repository directly in your shell prompt, allowing you to see at a glance what actions might be needed (commit, push, etc.). I hope this helps! 😊

----
# Prompt with updated Git Status

# Load version control information utility
autoload -Uz vcs_info

# Define function to fetch and format git status symbols
custom_git_symbols() {
  local symbols=""
  local git_status=$(git status --porcelain)

  # Check various git status conditions
  [[ $git_status =~ \+\+ ]] && symbols+="%F{yellow}&*%f"  # Diverged
  [[ $git_status =~ ^##.*\[behind.*\] ]] && symbols+="%F{red}&%f"  # Behind
  [[ $git_status =~ ^##.*\[ahead.*\] ]] && symbols+="%F{blue}*%f"  # Ahead
  [[ $git_status =~ ^\?\? ]] && symbols+="%F{cyan}?%f"  # Untracked files
  [[ $git_status =~ ^A  ]] && symbols+="%F{green}+%f"  # New files
  [[ $git_status =~ ^M  ]] && symbols+="%F{magenta}!%f"  # Modified files
  [[ $git_status =~ ^D  ]] && symbols+="%F{red}x%f"  # Deleted files
  [[ $git_status =~ ^R  ]] && symbols+="%F{blue}>%f"  # Renamed files
  [[ $(git stash list) ]] && symbols+="%F{green}$%f"  # Stashed changes

  echo $symbols
}

# Set the format for general usage
zstyle ':vcs_info:git:*' formats '%F{yellow}%s %F{cyan}%r/%S %F{magenta}%b $(custom_git_symbols)%f'

# Set the precmd function to update vcs info before each prompt
precmd() {
  vcs_info
}

# Enable prompt substitution
setopt PROMPT_SUBST

# Define the prompt with version control info
PROMPT='
%F{magenta}┌─[%f%n@%m %F{yellow}%~ %F{cyan}${vcs_info_msg_0_}%f%F{magenta}]
%F{magenta}└─❯%f '

---

# Current 05/03/2024

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
    if [[ $(git diff --cached --quiet HEAD 2>/dev/null; echo $?) == 1 ]]; then
      vcs_info_msg_0_="${vcs_info_msg_0_} ${stagedstr}"
    fi
    if [[ $(git diff-files --quiet 2>/dev/null; echo $?) == 1 ]]; then
      vcs_info_msg_0_="${vcs_info_msg_0_} ${unstagedstr}"
    fi
  fi
}

setopt PROMPT_SUBST

# Set colors for username and hostname
USERNAME_COLOR="%F{blue}"
HOSTNAME_COLOR="%F{green}"
RESET_COLOR="%f"
PROMPT_COLOR="%F{magenta}"  # Main color for other parts of the prompt
INFO_COLOR="%F{yellow}"    # Color for the directory path
VCS_COLOR="%F{cyan}"       # Color for version control system info

# Update the PROMPT variable
PROMPT="${PROMPT_COLOR}┌─[${USERNAME_COLOR}%n${RESET_COLOR}@${HOSTNAME_COLOR}%m ${INFO_COLOR}%~ ${VCS_COLOR}${vcs_info_msg_0_}${RESET_COLOR}${PROMPT_COLOR}]
${PROMPT_COLOR}└─❯${RESET_COLOR} "
RPROMPT="${PROMPT_COLOR}[%@]${RESET_COLOR}" # Display the current time in 12-hour format with AM/PM




