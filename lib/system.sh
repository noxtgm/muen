#!/bin/bash

_backup_file() {
    local dest="${REPO_STATE}/backups$1"
    [[ -e "$dest" ]] && return 0
    mkdir -p "${dest%/*}"
    sudo cat "$1" > "$dest"
}

system_read() {
    sudo cat "$1"
}

system_write() {
    local file="$1" content="$2"
    if sudo test -e "$file"; then
        if [[ "$(system_read "$file")" == "$content" ]]; then
            log_info "Unchanged ${file}"
            return 0
        fi
        _backup_file "$file"
    fi

    printf '%s\n' "$content" | sudo tee "$file" > /dev/null
    log_info "Updated ${file}"
}
