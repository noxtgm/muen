update_steps() {
    packages_install
    configs_deploy
    boot_configure
    shell_set_default
    boot_images_rebuild

    log_step 'Rebooting'
    systemctl reboot
}
