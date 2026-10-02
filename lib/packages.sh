#!/bin/bash

_packages_read() {
    [[ -f "$1" ]] || return 0
    awk '{ sub(/#.*/, ""); for (i = 1; i <= NF; i++) print $i }' "$1"
}

_packages_not_in_repos() {
    local pkg
    for pkg in "$@"; do
        pacman -Si "$pkg" &> /dev/null || pacman -Sg "$pkg" &> /dev/null || echo "$pkg"
    done
}

packages_install_pacman() {
    local pkgs missing
    log_step "Installing pacman packages"
    mapfile -t pkgs < <(_packages_read "${REPO_PATH}/packages.pacman")
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    mapfile -t missing < <(_packages_not_in_repos "${pkgs[@]}")
    if (( ${#missing[@]} > 0 )); then
        die "Not in the official repos (move to packages.aur?): ${missing[*]}"
    fi

    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}

packages_install_yay() {
    local build_dir
    log_step "Installing yay"
    if command -v yay &> /dev/null; then
        log_info "Already installed"
        return 0
    fi

    build_dir="$(mktemp -d)"
    git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$build_dir"
    (cd "$build_dir" && makepkg -si --noconfirm)
    rm -rf "$build_dir"
    log_info "yay installed"
}

packages_install_aur() {
    local pkgs
    log_step "Installing AUR packages"
    mapfile -t pkgs < <(_packages_read "${REPO_PATH}/packages.aur")
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    yay -S --needed --noconfirm --answerclean None --answerdiff None "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}

packages_install_npm() {
    local pkgs
    log_step "Installing npm packages"
    mapfile -t pkgs < <(_packages_read "${REPO_PATH}/packages.npm")
    if (( ${#pkgs[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    command -v npm &> /dev/null || die "npm is not installed (add it to packages.pacman)."
    npm install --global --prefix "$HOME/.local" "${pkgs[@]}"
    log_info "${#pkgs[@]} packages installed"
}
