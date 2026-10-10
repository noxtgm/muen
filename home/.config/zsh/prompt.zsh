autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %b'
zstyle ':vcs_info:git:*' actionformats ' %b|%a'
add-zsh-hook precmd vcs_info

setopt prompt_subst
PROMPT='%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f
%(?.%F{green}.%F{red})❯%f '
