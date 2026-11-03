packages_install() {
    log_step 'Upgrading the system and installing packages'

    sudo pacman -Syu --needed --noconfirm - < "${REPO_PATH}/packages"

    log_info 'Packages up to date'
}
