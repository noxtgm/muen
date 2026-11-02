packages_install() {
    local list="${REPO_PATH}/packages"

    log_step 'Installing pacman packages'

    if [[ ! -f "$list" ]]; then
        die "${list} not found"
    fi

    if ! grep -q '[^[:space:]]' "$list"; then
        log_info 'Nothing to install'
        return 0
    fi

    sudo pacman -Syu --needed --noconfirm - < "$list"

    log_info 'Packages up to date'
}
