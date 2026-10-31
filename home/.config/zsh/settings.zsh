# History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
if [[ ! -d "${HISTFILE:h}" ]]; then
    mkdir -p "${HISTFILE:h}"
fi
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups hist_ignore_space share_history

# Options
setopt interactive_comments

# Completion
autoload -Uz compinit
if [[ ! -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]]; then
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
fi
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# Vi mode
bindkey -v
KEYTIMEOUT=5
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^U' backward-kill-line
