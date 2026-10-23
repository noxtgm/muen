#!/bin/bash

files_write_root() {
    local file="$1" content="$2" mode="${3-644}" tmp

    tmp="$(sudo mktemp "${file}.XXXXXX")" || die "Failed to write ${file}"
    if ! { printf '%s\n' "$content" | sudo tee "$tmp" > /dev/null \
        && { [[ -z "$mode" ]] || sudo chmod "$mode" "$tmp"; } \
        && sudo sync "$tmp" \
        && sudo mv -f "$tmp" "$file" \
        && sudo sync --file-system "$file"; }; then
        sudo rm -f "$tmp"
        die "Failed to write ${file}"
    fi
}
