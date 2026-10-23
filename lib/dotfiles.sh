#!/bin/bash

_dotfiles_hash() {
    local hash
    hash="$(sha256sum < "$1")" || return
    echo "${hash%% *}"
}

_dotfiles_backup() {
    local rel="$1" backup_dir="$2"
    mkdir -p "$(dirname "${backup_dir}/${rel}")"
    mv "${HOME}/${rel}" "${backup_dir}/${rel}"
    log_warn "Backed up ~/${rel} to ${backup_dir}/${rel}"
}

# Removes the directories a deleted config leaves empty, stopping at the first non-empty one
_dotfiles_prune() {
    local dir
    dir="$(dirname "$1")"
    while [[ "$dir" != . ]] && rmdir -- "${HOME}/${dir}" 2>/dev/null; do
        dir="$(dirname "$dir")"
    done
}

# Prints the part of a config's path that exists but is not a directory, if any
_dotfiles_blocker() {
    local dir
    dir="$(dirname "$1")"
    while [[ "$dir" != . ]]; do
        if [[ ( -e "${HOME}/${dir}" || -L "${HOME}/${dir}" ) && ! -d "${HOME}/${dir}" ]]; then
            printf '%s' "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
}

dotfiles_update() {
    local src="${REPO_PATH}/home"
    local backup_dir
    backup_dir="${REPO_BACKUPS}/$(date '+%Y%m%d-%H%M%S')"
    local -A recorded=() deployed=() in_repo=()
    local -a files=() conflicts=()
    local rel hash target tmp local_hash repo_hash reason blocker
    local installed=0 kept=0 deleted=0

    log_step "Applying configs"
    if [[ -d "$src" ]]; then
        mapfile -t files < <(find "$src" -type f -printf '%P\n' | sort)
    fi
    if [[ -f "$REPO_DEPLOYED" ]]; then
        while read -r hash rel; do
            recorded["$rel"]="$hash"
        done < "$REPO_DEPLOYED"
    fi
    if (( ${#files[@]} == 0 && ${#recorded[@]} == 0 )); then
        log_info "Nothing to install"
        return 0
    fi

    for rel in "${files[@]}"; do
        in_repo["$rel"]=1
    done

    # Files removed from home/ since the last update, removed first so a new config can take their place
    for rel in "${!recorded[@]}"; do
        [[ -n "${in_repo[$rel]:-}" ]] && continue
        target="${HOME}/${rel}"

        if [[ ! -e "$target" && ! -L "$target" ]]; then
            continue
        elif [[ -f "$target" && ! -L "$target" && "$(_dotfiles_hash "$target")" == "${recorded[$rel]}" ]]; then
            rm -f "$target"
            _dotfiles_prune "$rel"
            (( ++deleted ))
        elif [[ "$REPO_FORCE" == 1 ]]; then
            _dotfiles_backup "$rel" "$backup_dir"
            _dotfiles_prune "$rel"
            (( ++deleted ))
        elif [[ -L "$target" || ! -f "$target" ]]; then
            conflicts+=("~/${rel}: not a regular file, removed from repo")
            deployed["$rel"]="${recorded[$rel]}"
        else
            conflicts+=("~/${rel}: edited locally, removed from repo")
            deployed["$rel"]="${recorded[$rel]}"
        fi
    done

    for rel in "${files[@]}"; do
        target="${HOME}/${rel}"
        repo_hash="$(_dotfiles_hash "${src}/${rel}")"
        reason=""
        blocker="$(_dotfiles_blocker "$rel")"

        if [[ -n "$blocker" ]]; then
            reason="~/${blocker} is not a directory"
        elif [[ -L "$target" || ( -e "$target" && ! -f "$target" ) ]]; then
            reason="not a regular file"
        elif [[ -f "$target" ]]; then
            local_hash="$(_dotfiles_hash "$target")"
            if [[ "$local_hash" == "$repo_hash" ]]; then
                deployed["$rel"]="$repo_hash"
                continue
            elif [[ -z "${recorded[$rel]:-}" ]]; then
                reason="not managed by muen"
            elif [[ "$local_hash" == "${recorded[$rel]}" ]]; then
                :
            elif [[ "$repo_hash" == "${recorded[$rel]}" ]]; then
                log_info "Keeping local changes to ~/${rel}"
                deployed["$rel"]="${recorded[$rel]}"
                (( ++kept ))
                continue
            else
                reason="edited locally"
            fi
        fi

        if [[ -n "$reason" ]]; then
            if [[ "$REPO_FORCE" != 1 ]]; then
                conflicts+=("~/${rel}: ${reason}")
                if [[ -n "${recorded[$rel]:-}" ]]; then
                    deployed["$rel"]="${recorded[$rel]}"
                fi
                continue
            fi
            _dotfiles_backup "${blocker:-$rel}" "$backup_dir"
        fi

        # Replaced through a rename so programs reading it live never see it missing or half written
        mkdir -p "$(dirname "$target")"
        tmp="$(mktemp "${target}.XXXXXX")"
        if ! { cp "${src}/${rel}" "$tmp" \
            && chmod --reference="${src}/${rel}" "$tmp" \
            && mv -f "$tmp" "$target"; }; then
            rm -f "$tmp"
            die "Failed to install ~/${rel}"
        fi
        deployed["$rel"]="$repo_hash"
        (( ++installed ))
    done

    for rel in "${!deployed[@]}"; do
        printf '%s  %s\n' "${deployed[$rel]}" "$rel"
    done | sort -k2 > "${REPO_DEPLOYED}.tmp"
    mv "${REPO_DEPLOYED}.tmp" "$REPO_DEPLOYED"

    log_info "${installed} installed, ${kept} kept, ${deleted} deleted"

    if (( ${#conflicts[@]} > 0 )); then
        for reason in "${conflicts[@]}"; do
            log_error "$reason"
        done
        die "${#conflicts[@]} conflicting configs were skipped and left untouched, remove them or run \`muen update --force\` to back them up to ${REPO_BACKUPS}/ and overwrite them"
    fi
}
