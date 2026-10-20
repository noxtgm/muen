#!/bin/bash

_read_packages() {
    local file="$1"
    local -n _read_packages_out="$2"

    if [[ ! -f "$file" ]]; then
        die "${file} not found"
    fi
    mapfile -t _read_packages_out < <(awk '{ for (i = 1; i <= NF; i++) print $i }' "$file")
}

packages_install_pacman() {
    local pkgs
    log_step "Installing pacman packages"
    _read_packages "${REPO_PATH}/packages.pacman" pkgs
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    sudo pacman -Syu --needed --noconfirm "${pkgs[@]}"
    log_info "${#pkgs[@]} packages up to date"
}

_packages_install_yay() {
    log_info "Installing yay"
    (
        build_dir="$(mktemp -d)"
        trap 'rm -rf "$build_dir"' EXIT
        git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$build_dir"
        cd "$build_dir" || exit
        makepkg -sri --noconfirm
    )
    log_info "yay installed"
}

packages_install_aur() {
    local pkgs
    log_step "Installing AUR packages"
    _read_packages "${REPO_PATH}/packages.aur" pkgs
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    if ! command -v yay > /dev/null; then
        _packages_install_yay
    fi

    yay -S --needed --noconfirm --answerclean None --answerdiff None "${pkgs[@]}"
    log_info "${#pkgs[@]} packages up to date"
}

packages_install_npm() {
    local pkgs
    log_step "Installing npm packages"
    _read_packages "${REPO_PATH}/packages.npm" pkgs
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
    export PATH="${PNPM_HOME}/bin:${PATH}"
    pnpm add --global --config.minimumReleaseAge=1440 --config.minimumReleaseAgeStrict=true "${pkgs[@]/#/--allow-build=}" "${pkgs[@]}"
    log_info "${#pkgs[@]} packages up to date"
}
