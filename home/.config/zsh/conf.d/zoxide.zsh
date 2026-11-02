if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh --cmd cd)"

    cd() {
        if (( $# == 1 )) && [[ $1 =~ '^(\.{3,})(/.*)?$' ]]; then
            local target=
            repeat $(( ${#match[1]} - 1 )) target+=../
            __zoxide_z "${target}${match[2]#/}"
        else
            __zoxide_z "$@"
        fi
    }
fi
