if (( $+commands[eza] )); then
    alias lsx='eza -l --no-user --group-directories-first --icons=always --time-style=+"%Y-%m-%d %H:%M"'
    alias lsxa='lsx -a'
    alias ls='lsx --no-permissions --no-filesize'
    alias lsa='ls -a'

    alias treex='eza -l --no-user --group-directories-first --icons=always --time-style=+"%Y-%m-%d %H:%M" --tree --level=2'
    alias treexa='treex -a'
    alias tree='treex --no-permissions --no-filesize'
    alias treea='tree -a'
fi
