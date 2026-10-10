#!/bin/bash

_dotfiles_hash() {
    local hash
    hash="$(sha256sum < "$1")"
    echo "${hash%% *}"
}

_dotfiles_backup() {
    local rel="$1" backup_dir="$2"
    mkdir -p "$(dirname "${backup_dir}/${rel}")"
    mv "${HOME}/${rel}" "${backup_dir}/${rel}"
    log_warn "Backed up ~/${rel} to ${backup_dir}/${rel}"
}

dotfiles_update() {
    local src="${REPO_PATH}/home"
    local backup_dir
    backup_dir="${REPO_BACKUPS}/$(date '+%Y%m%d-%H%M%S')"
    local -A recorded=() deployed=() in_repo=()
    local -a files=() conflicts=()
    local rel hash target local_hash repo_hash reason
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
        target="${HOME}/${rel}"
        repo_hash="$(_dotfiles_hash "${src}/${rel}")"
        reason=""

        if [[ -L "$target" || ( -e "$target" && ! -f "$target" ) ]]; then
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
            _dotfiles_backup "$rel" "$backup_dir"
        fi

        mkdir -p "$(dirname "$target")"
        cp --remove-destination "${src}/${rel}" "$target"
        deployed["$rel"]="$repo_hash"
        (( ++installed ))
    done

    # Files removed from home/ since the last update
    for rel in "${!recorded[@]}"; do
        [[ -n "${in_repo[$rel]:-}" ]] && continue
        target="${HOME}/${rel}"

        if [[ ! -e "$target" && ! -L "$target" ]]; then
            continue
        elif [[ -f "$target" && ! -L "$target" && "$(_dotfiles_hash "$target")" == "${recorded[$rel]}" ]]; then
            rm -f "$target"
            (( ++deleted ))
        elif [[ "$REPO_FORCE" == 1 ]]; then
            _dotfiles_backup "$rel" "$backup_dir"
            (( ++deleted ))
        else
            conflicts+=("~/${rel}: edited locally, removed from repo")
            deployed["$rel"]="${recorded[$rel]}"
        fi
    done

    mkdir -p "$(dirname "$REPO_DEPLOYED")"
    for rel in "${!deployed[@]}"; do
        printf '%s  %s\n' "${deployed[$rel]}" "$rel"
    done | sort -k2 > "${REPO_DEPLOYED}.tmp"
    mv "${REPO_DEPLOYED}.tmp" "$REPO_DEPLOYED"

    log_info "${installed} installed, ${kept} kept, ${deleted} deleted"

    if (( ${#conflicts[@]} > 0 )); then
        for reason in "${conflicts[@]}"; do
            log_error "$reason"
        done
        log_error "${#conflicts[@]} conflicting configs were skipped and left untouched, remove them or run \`muen update --force\` to back them up to ${REPO_BACKUPS}/ and overwrite them"
        return 1
    fi
}
