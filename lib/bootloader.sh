#!/bin/bash

BOOT_PARAMS=(quiet splash loglevel=3 rd.udev.log_level=3 systemd.show_status=false rd.systemd.show_status=false vt.global_cursor_default=0)
KERNEL_CMDLINE="${KERNEL_CMDLINE:-/etc/kernel/cmdline}"

_boot_path() {
    sudo bootctl is-installed &> /dev/null || die "systemd-boot is not installed."
    sudo bootctl --print-boot-path
}

_boot_entries() {
    sudo find "$1/loader/entries" -maxdepth 1 -name '*.conf' ! -name '*fallback*' 2> /dev/null || true
}

_add_params() {
    awk -v re="$1" -v start="$2" -v params="${BOOT_PARAMS[*]}" '
        { lines[NR] = $0 }
        $0 ~ re {
            if (!first) first = NR
            for (i = start; i <= NF; i++) { split($i, kv, "="); seen[kv[1]] = 1 }
        }
        END {
            if (!first) exit 2
            n = split(params, p, " ")
            for (i = 1; i <= n; i++) { split(p[i], kv, "="); if (!(kv[1] in seen)) add = add " " p[i] }
            for (i = 1; i <= NR; i++) print lines[i] (i == first ? add : "")
        }'
}

_set_params() {
    local content
    content="$(system_read "$1" | _add_params "$2" "$3")" || die "No kernel options found in $1."
    system_write "$1" "$content"
}

bootloader_hide_menu() {
    local conf content
    log_step "Hiding boot menu"
    conf="$(_boot_path)/loader/loader.conf"
    content="$(system_read "$conf" 2> /dev/null || true)"
    if grep -q '^timeout' <<< "$content"; then
        content="$(sed 's/^timeout.*/timeout 0/' <<< "$content")"
    else
        content="${content:+$content$'\n'}timeout 0"
    fi
    system_write "$conf" "$content"
}

bootloader_set_cmdline() {
    local boot entries entry
    log_step "Configuring silent boot"
    boot="$(_boot_path)"
    mapfile -t entries < <(_boot_entries "$boot")

    if (( ${#entries[@]} > 0 )); then
        for entry in "${entries[@]}"; do
            _set_params "$entry" '^options[ \t]' 2
        done
    elif sudo test -f "$KERNEL_CMDLINE"; then
        _set_params "$KERNEL_CMDLINE" '[^ \t]' 1
    else
        die "No boot entries in ${boot}/loader/entries and no ${KERNEL_CMDLINE}."
    fi
}
