update_steps() {
    packages_install
    boot_configure
    shell_set_default

    log_step 'Rebooting'
    systemctl reboot
}
