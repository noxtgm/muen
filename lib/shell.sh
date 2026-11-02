shell_set_default() {
    log_step 'Setting default shell'

    local zsh_path='/usr/bin/zsh'

    if [[ "$(getent passwd "$(id -un)" | cut -d: -f7)" == "$zsh_path" ]]; then
        log_info 'zsh is already the default shell'
        return 0
    fi

    if [[ ! -x "$zsh_path" ]] || ! grep -qxF "$zsh_path" <(chsh -l); then
        die "${zsh_path} is not installed or not listed in /etc/shells"
    fi

    sudo chsh -s "$zsh_path" "$(id -un)"

    log_info 'Default shell set to zsh, log in again to use it'
}
