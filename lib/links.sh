#!/bin/bash

_walk_home() {
    local rel="$1" entry child target
    while IFS= read -r -d '' entry; do
        child="${rel:+$rel/}${entry##*/}"
        target="$HOME/$child"

        case "$child" in
            .config|.local|.local/share|.local/bin)
                mkdir -p "$target"
                _walk_home "$child"
                ;;
            *)
                rm -rf "$target"
                ln -s "$entry" "$target"
                log_info "Linked ${target/#$HOME/\~}"
                ;;
        esac
    done < <(find "${REPO_PATH}/home${rel:+/$rel}" -mindepth 1 -maxdepth 1 -print0)
}

links_apply() {
    log_step "Linking configs"
    _walk_home ""
    log_info "Configs linked"
}
