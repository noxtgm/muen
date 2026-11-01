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
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

# Vi mode
bindkey -v
KEYTIMEOUT=5
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^U' backward-kill-line

# Keys from terminfo, see https://wiki.archlinux.org/title/Zsh#Key_bindings
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -- "${key[Insert]}"        overwrite-mode
[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"     backward-delete-char
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-beginning-search
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-beginning-search
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"          backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"         forward-char
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}"     ]] && bindkey -- "${key[Shift-Tab]}"     reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# The same keys in normal mode, where they would otherwise run unrelated vi commands or plain history
[[ -n "${key[Home]}"          ]] && bindkey -M vicmd -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -M vicmd -- "${key[End]}"           end-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -M vicmd -- "${key[Insert]}"        vi-insert
[[ -n "${key[Delete]}"        ]] && bindkey -M vicmd -- "${key[Delete]}"        delete-char
[[ -n "${key[Up]}"            ]] && bindkey -M vicmd -- "${key[Up]}"            up-line-or-beginning-search
[[ -n "${key[Down]}"          ]] && bindkey -M vicmd -- "${key[Down]}"          down-line-or-beginning-search
[[ -n "${key[PageUp]}"        ]] && bindkey -M vicmd -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -M vicmd -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[Control-Left]}"  ]] && bindkey -M vicmd -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -M vicmd -- "${key[Control-Right]}" forward-word

# Make sure the terminal is in application mode while zle is active, only then are the values from $terminfo valid
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
