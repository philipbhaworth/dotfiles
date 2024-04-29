# Simple Prompt

PROMPT='
%F{magenta}%n@%m %F{yellow}%~ %F{cyan}${vcs_info_msg_0_}%f
%F{magenta}❯%f '


# Prompt with lines and brackets

PROMPT='
%F{magenta}┌─[%f%n@%m%F{magenta}]─[%F{yellow}%~%F{magenta}]─[%F{cyan}${vcs_info_msg_0_}%f%F{magenta}]─┐
%F{magenta}└─❯%f '

# Prompt with just lines

PROMPT='
%F{magenta}┌─[%f%n@%m %F{yellow}%~ %F{cyan}${vcs_info_msg_0_}%f%F{magenta}]
%F{magenta}└─❯%f '
