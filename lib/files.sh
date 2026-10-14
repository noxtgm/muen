#!/bin/bash

# Replaces a root owned file through a rename so an interrupted write never leaves it empty or truncated
files_write_root() {
    local file="$1" content="$2" tmp
    tmp="$(sudo mktemp "${file}.XXXXXX")"
    printf '%s\n' "$content" | sudo tee "$tmp" > /dev/null
    sudo chmod 644 "$tmp"
    sudo mv -f "$tmp" "$file"
}
