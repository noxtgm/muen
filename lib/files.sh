#!/bin/bash

# Replaces a root owned file through a rename so an interrupted write never leaves it empty or truncated
files_write_root() {
    local file="$1" content="$2" mode="${3-644}" tmp

    tmp="$(sudo mktemp "${file}.XXXXXX")" || die "Failed to write ${file}"
    if ! { printf '%s\n' "$content" | sudo tee "$tmp" > /dev/null \
        && { [[ -z "$mode" ]] || sudo chmod "$mode" "$tmp"; } \
        && sudo mv -f "$tmp" "$file"; }; then
        sudo rm -f "$tmp"
        die "Failed to write ${file}"
    fi
}
