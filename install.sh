#!/bin/bash
set -euo pipefail

REPO_NAME="${REPO_NAME:-muen}"
REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
REPO_BRANCH="${REPO_BRANCH:-main}"
REPO_URL="https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git"
REPO_PATH="${REPO_PATH:-$HOME/.local/share/${REPO_NAME}}"
REPO_LIB="${REPO_PATH}/lib"
REPO_LOG="${REPO_LOG:-$HOME/.local/state/${REPO_NAME}/install.log}"

main() {
    sudo pacman -Syu --needed --noconfirm git

    if [[ -d "${REPO_PATH}/.git" ]]; then
        git -C "$REPO_PATH" pull --ff-only origin "$REPO_BRANCH"
    else
        git clone --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
    fi

    mkdir -p "$(dirname "$REPO_LOG")"
    source "${REPO_LIB}/init.sh"

    packages_install_pacman
    packages_install_yay
    packages_install_aur
    packages_install_npm
}

main "$@"
