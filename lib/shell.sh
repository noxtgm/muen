#!/bin/bash

shell_set_default() {
    local user zsh_path="/usr/bin/zsh"
    log_step "Setting default shell"
    user="$(id -un)"
    if [[ "$(getent passwd "$user" | cut -d: -f7)" == "$zsh_path" ]]; then
        log_info "zsh is already the default shell"
        return 0
    fi

    sudo chsh -s "$zsh_path" "$user"
    log_info "Default shell set to zsh, log in again to use it"
}
