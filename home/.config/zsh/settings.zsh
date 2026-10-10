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
KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^U' backward-kill-line

# Beam cursor while typing and block cursor in normal mode
_vi_cursor_shape() {
    if [[ "$KEYMAP" == vicmd ]]; then
        printf '\e[2 q'
    else
        printf '\e[6 q'
    fi
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget keymap-select _vi_cursor_shape
add-zle-hook-widget line-init _vi_cursor_shape
