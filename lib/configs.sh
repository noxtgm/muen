_configs_display() {
    printf '%s' "${1/#"${HOME}"/\~}"
}

_configs_kind() {
    if [[ -L "$1" ]]; then
        printf 'symlink to %s' "$(readlink -- "$1")"
    elif [[ -d "$1" ]]; then
        printf 'directory'
    else
        printf 'file'
    fi
}

# Removes the directories a pruned link leaves empty, stopping below the target directory
_configs_prune_dirs() {
    local dir="$1" target="$2"

    while [[ "$dir" != "$target" ]] && rmdir -- "$dir" 2> /dev/null; do
        log_info "Removed empty directory $(_configs_display "$dir")"
        dir="$(dirname -- "$dir")"
    done
}

configs_deploy() {
    local source="${REPO_PATH}/configs"
    local target
    local -a symlinks=() missing=() conflicts=() stale=() parts
    local -A seen=()
    local file rel link dir parent part blocked kind

    # The XDG Base Directory spec says a relative XDG_CONFIG_HOME is invalid and must be ignored
    if [[ "${XDG_CONFIG_HOME:-}" == /* ]]; then
        target="${XDG_CONFIG_HOME%/}"
    else
        target="${HOME}/.config"
    fi

    log_step 'Deploying configs'

    # Symlinks are refused rather than skipped silently, the scan below only deploys regular files
    while IFS= read -r -d '' file; do
        symlinks+=("$file")
    done < <(trap - ERR; find "$source" -type l -print0 | sort -z)
    wait "$!" || die 'Listing the repository configs failed'

    if (( ${#symlinks[@]} )); then
        for file in "${symlinks[@]}"; do
            log_warn "Unsupported symlink: ${file#"${REPO_PATH}/"} -> $(readlink -- "$file")"
        done

        die "${#symlinks[@]} symlinks found in configs/, replace them with regular files"
    fi

    # Scan: nothing is changed until every file has been checked
    while IFS= read -r -d '' file; do
        rel="${file#"${source}/"}"
        link="${target}/${rel}"
        blocked=0

        # Walk the ancestors from the top and stop at the first one that is not
        # a real directory, so nothing below a foreign symlink is ever touched
        dir="$(dirname -- "$rel")"
        parent="$target"

        if [[ "$dir" != '.' ]]; then
            IFS='/' read -r -a parts <<< "$dir"

            for part in "${parts[@]}"; do
                parent="${parent}/${part}"

                if [[ -L "$parent" || ( -e "$parent" && ! -d "$parent" ) ]]; then
                    blocked=1

                    if [[ -z "${seen[$parent]:-}" ]]; then
                        seen[$parent]=1
                        conflicts+=("$parent")
                    fi

                    break
                fi
            done
        fi

        if (( blocked )); then
            missing+=("$file")
        elif [[ -L "$link" && "$(readlink -- "$link")" == "$file" ]]; then
            continue
        elif [[ -e "$link" || -L "$link" ]]; then
            conflicts+=("$link")
            missing+=("$file")
        else
            missing+=("$file")
        fi
    done < <(trap - ERR; find "$source" -type f -print0 | sort -z)
    wait "$!" || die 'Listing the repository configs failed'

    # Decide: list every conflict and stop, or overwrite them all
    if (( ${#conflicts[@]} )); then
        for link in "${conflicts[@]}"; do
            kind="$(_configs_kind "$link")"

            if (( FORCE )); then
                rm -rf -- "$link"
                log_info "Overwrote $(_configs_display "$link") (${kind})"
            else
                log_warn "Conflict: $(_configs_display "$link") (${kind})"
            fi
        done

        if (( ! FORCE )); then
            die "${#conflicts[@]} conflicting configs found, port them over to the repository then run 'muen update --force' to overwrite them"
        fi
    fi

    # Prune: dangling links into the repository and the directories they leave empty,
    # other links are never touched. The scan completes before anything is removed
    mkdir -p -- "$target"

    while IFS= read -r -d '' link; do
        [[ "$(readlink -- "$link")" == "${source}/"* ]] || continue
        stale+=("$link")
    done < <(trap - ERR; find -H "$target" -xtype l -print0)
    wait "$!" || die "Scanning $(_configs_display "$target") for stale links failed"

    for link in "${stale[@]}"; do
        rm -- "$link"
        log_info "Removed stale link $(_configs_display "$link")"
        _configs_prune_dirs "$(dirname -- "$link")" "$target"
    done

    # Link
    for file in "${missing[@]}"; do
        rel="${file#"${source}/"}"
        link="${target}/${rel}"

        mkdir -p -- "$(dirname -- "$link")"
        ln -s -- "$file" "$link"
        log_info "Linked $(_configs_display "$link")"
    done

    if (( ! ${#missing[@]} )); then
        log_info 'Configs up to date'
    fi
}
