#!/bin/bash

_LINKS_CONTAINERS=(.config .local .local/share .local/bin)

_links_is_container() {
    local container
    for container in "${_LINKS_CONTAINERS[@]}"; do
        [[ "$1" == "$container" ]] && return 0
    done
    return 1
}

_links_link() {
    local src="$1" target="$2"
    if [[ -L "$target" && "$(readlink "$target")" == "$src" ]]; then
        return 0
    fi

    rm -rf "$target"
    ln -s "$src" "$target"
    log_info "Linked ${target/#$HOME/\~}"
}

_links_walk() {
    local rel="$1" entry name child target
    while IFS= read -r -d '' entry; do
        name="${entry##*/}"
        [[ "$name" == .gitkeep ]] && continue
        child="${rel:+$rel/}$name"
        target="$HOME/$child"

        if [[ -d "$entry" && ! -L "$entry" ]] && _links_is_container "$child"; then
            if [[ -L "$target" || ! -d "$target" ]]; then
                rm -rf "$target"
                mkdir -p "$target"
            fi
            _links_walk "$child"
        else
            _links_link "$entry" "$target"
        fi
    done < <(find "${REPO_PATH}/home${rel:+/$rel}" -mindepth 1 -maxdepth 1 -print0)
}

links_apply() {
    log_step "Linking configs"
    [[ -d "${REPO_PATH}/home" ]] || die "Missing ${REPO_PATH}/home directory."
    _links_walk ""
    log_info "Configs linked"
}
