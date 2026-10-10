#!/bin/bash

shell_set_default() {
    local user zsh_path
    log_step "Setting default shell"
    user="$(id -un)"
    zsh_path="$(command -v zsh)"
    if [[ "$(getent passwd "$user" | cut -d: -f7)" == "$zsh_path" ]]; then
        log_info "zsh is already the default shell"
        return 0
    fi

    sudo chsh -s "$zsh_path" "$user"
    log_info "Default shell set to zsh, log in again to use it"
}
