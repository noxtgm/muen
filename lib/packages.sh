#!/bin/bash

_NPM_NAME_RE='^(@[a-z0-9~][a-z0-9._~-]*/)?[a-z0-9~][a-z0-9._~-]*$'

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
    log_info "${#pkgs[@]} package(s) up to date"
}

_pnpm() {
    PATH="${PATH}:${PNPM_HOME}/bin" pnpm "$@" < /dev/null
}

packages_install_npm() {
    local pkgs pkg listing global_dir
    local -a names=() builds=() stale=()
    local -A listed=()
    log_step "Installing npm packages"
    _read_packages "${REPO_PATH}/packages.npm" pkgs

    for pkg in "${pkgs[@]}"; do
        if [[ "$pkg" == *+ ]]; then
            pkg="${pkg%+}"
            builds+=("--allow-build=${pkg}")
        fi
        if [[ ! "$pkg" =~ $_NPM_NAME_RE ]]; then
            die "Invalid npm package name: ${pkg}"
        fi
        names+=("$pkg")
        listed["$pkg"]=1
    done

    export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"

    listing="$(_pnpm ls --global --depth=0 --parseable)"
    while IFS= read -r pkg; do
        if [[ "$pkg" == */node_modules/* ]]; then
            pkg="${pkg##*/node_modules/}"
            if [[ -z "${listed[$pkg]:-}" ]]; then
                stale+=("$pkg")
            fi
        fi
    done <<< "$listing"

    if (( ${#stale[@]} > 0 )); then
        _pnpm remove --global "${stale[@]}"
        log_info "Removed ${#stale[@]} unlisted package(s)"
    fi

    global_dir="$(_pnpm root --global)"
    if [[ "$global_dir" != /* ]]; then
        die "Unexpected pnpm global directory: ${global_dir}"
    fi
    rm -f "${global_dir}/pnpm-workspace.yaml"

    if (( ${#names[@]} == 0 )); then
        log_info "Nothing to install"
    else
        _pnpm add --global --config.minimumReleaseAge=1440 --config.minimumReleaseAgeStrict=true "${builds[@]}" "${names[@]}"
        log_info "${#names[@]} package(s) up to date"
    fi

    _pnpm store prune
}
