# --- History ---

# See https://wiki.archlinux.org/title/Zsh#History and the zsh entry of https://wiki.archlinux.org/title/XDG_Base_Directory
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=1000
SAVEHIST=1000

# See https://wiki.archlinux.org/title/Zsh#History_search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# --- Options ---

# See zshoptions(1)
setopt HIST_IGNORE_SPACE HIST_IGNORE_DUPS SHARE_HISTORY
setopt INTERACTIVE_COMMENTS

# --- Key bindings ---

# See https://wiki.archlinux.org/title/Zsh#Key_bindings
bindkey -e
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

[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -- "${key[Insert]}"        overwrite-mode
[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"     backward-delete-char
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-history
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-history
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-beginning-search
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-beginning-search
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"          backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"         forward-char
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}"     ]] && bindkey -- "${key[Shift-Tab]}"     reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# --- Completion ---

# See https://wiki.archlinux.org/title/Zsh#Command_completion and the zsh entry of https://wiki.archlinux.org/title/XDG_Base_Directory
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' rehash true

# --- Prompt ---

# TODO: Create a prompt that matches the MUEN theme
# See https://wiki.archlinux.org/title/Zsh#Example
PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{blue}%B%~%b%f %# '
RPROMPT='[%F{yellow}%?%f]'

# --- Aliases ---

alias lsx='eza -l --no-user --group-directories-first --icons=auto --time-style=+"%Y-%m-%d %H:%M"'
alias lsxa='lsx -a'
alias lsax='lsx -a'
alias ls='lsx --no-permissions --no-filesize'
alias lsa='ls -a'

alias treex='lsx --tree --level=2'
alias treexa='treex -a'
alias treeax='treex -a'
alias tree='treex --no-permissions --no-filesize'
alias treea='tree -a'

alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'

# --- Functions ---

# Opens a file picked with fzf in nvim
ff() {
    local file
    file="$(fzf --preview='cat -- {}')"
    if [[ -n "$file" ]]; then
        nvim -- "$file"
    fi
}

# Opens nvim at a line picked with fzf among every line ripgrep finds
fgr() {
    local selection file line
    selection="$(rg --color=always --line-number --no-heading . | fzf --ansi --delimiter=: --preview='cat -n -- {1}' --preview-window='+{2}/2')"
    if [[ -n "$selection" ]]; then
        file="${selection%%:*}"
        line="${selection#*:}"
        line="${line%%:*}"
        nvim "+${line}" -- "$file"
    fi
}

if [[ -t 0 ]]; then
    source <(fzf --zsh)
fi

eval "$(zoxide init zsh --cmd cd)"

cd() {
    if (( $# == 1 )) && [[ "$1" =~ '^(\.{3,})(/.*)?$' ]]; then
        local target=''
        repeat $(( ${#match[1]} - 1 )) target+='../'
        __zoxide_z "${target}${match[2]#/}"
    else
        __zoxide_z "$@"
    fi
}

# --- Plugins ---

# See https://wiki.archlinux.org/title/Zsh#Fish-like_syntax_highlighting_and_autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
