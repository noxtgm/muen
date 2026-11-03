log_step() {
    printf '\n%s==>%s %s%s%s\n' "$BLUE" "$OFF" "$BOLD" "$1" "$OFF"
}

log_info() {
    printf '  %s->%s %s\n' "$GREEN" "$OFF" "$1"
}

log_warn() {
    printf '%sWARNING:%s %s\n' "$YELLOW" "$OFF" "$1" >&2
}

log_error() {
    printf '%sERROR:%s %s\n' "$RED" "$OFF" "$1" >&2
}

log_failure() {
    local status="$1" command="$2" source="$3" line="$4"
    source="$(readlink -f -- "$source" || printf '%s' "$source")"
    log_error "Command failed with exit code ${status} at ${source#"${REPO_PATH}/"}:${line}: ${command}"
}

die() {
    log_error "$1"
    exit 1
}
