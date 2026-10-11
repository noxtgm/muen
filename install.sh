#!/bin/bash
set -euo pipefail

REPO_NAME="${REPO_NAME:-muen}"
REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
REPO_BRANCH="${REPO_BRANCH:-main}"
REPO_URL="https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git"
REPO_PATH="${REPO_PATH:-$HOME/.local/share/${REPO_NAME}}"

reboot_countdown() {
    local i
    for (( i = 10; i > 0; i-- )); do
        printf '\rRebooting in %2d seconds, press Ctrl-C to cancel' "$i"
        sleep 1
    done
    printf '\n'
    sudo systemctl reboot
}

main() {
    local first_install=0

    if (( EUID == 0 )); then
        printf 'Run the installer as your user, not as root\n' >&2
        exit 1
    fi

    sudo pacman -Syu --needed --noconfirm git

    if [[ ! -d "${REPO_PATH}/.git" ]]; then
        git clone --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
        first_install=1
    fi

    mkdir -p "$HOME/.local/bin"
    ln -sf "${REPO_PATH}/bin/muen" "$HOME/.local/bin/muen"
    "${REPO_PATH}/bin/muen" update "$@"

    if (( first_install )); then
        reboot_countdown
    fi
}

main "$@"
