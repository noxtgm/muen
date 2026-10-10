if (( $+commands[fzf] )); then
    ff() {
        local file
        file=$(fzf --preview="cat {}")
        if [[ -n "$file" ]]; then
            nvim -- "$file"
        fi
    }

    fgr() {
        local selection
        selection=$(rg --color=always --line-number --no-heading . | fzf --ansi --delimiter=: --preview="cat -n {1}" --preview-window=+{2}-/2)
        if [[ -n "$selection" ]]; then
            local file="${selection%%:*}"
            local line="${selection#*:}"
            line="${line%%:*}"
            nvim "+$line" "$file"
        fi
    }
fi
