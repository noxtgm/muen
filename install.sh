#!/bin/bash
set -euo pipefail

REPO_NAME="${REPO_NAME:-muen}"
REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
REPO_URL="${REPO_URL:-https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git}"
REPO_PATH="${REPO_PATH:-${XDG_DATA_HOME:-${HOME}/.local/share}/${REPO_NAME}}"

export GIT_TERMINAL_PROMPT=0

main() {
    if (( EUID == 0 )); then
        printf 'Run the installer as your regular user, not as root\n' >&2
        exit 1
    fi

    sudo pacman -Syu --needed --noconfirm git

    if [[ ! -e "$REPO_PATH" ]]; then
        git clone -- "$REPO_URL" "$REPO_PATH"
    elif ! git -C "$REPO_PATH" rev-parse --quiet --verify HEAD &>/dev/null; then
        printf '%s is not a complete download of muen: delete it and run the installer again\n' "$REPO_PATH" >&2
        exit 1
    fi

    mkdir -p "${HOME}/.local/bin"
    ln -sf "${REPO_PATH}/bin/muen" "${HOME}/.local/bin/muen"
    "${REPO_PATH}/bin/muen" update "$@"
}

main "$@"
