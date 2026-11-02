# Context

This project contains dotfiles and deployment scripts specifically configured and tuned to be deployed on the latest version of Arch Linux freshly installed using `archinstall`. It is to be used with a single SSD drive machine.

# Security considerations

- Security comes before convenience. When a choice trades one for the other (autologin, skipping a password, looser permissions, fewer prompts), default to the secure option and present the convenient one only with its security cost spelled out.
- Before implementing anything that changes how the user authenticates or what can capture input or the screen, audit it (verify claims in source and docs, test failure modes) and get explicit approval. Prefer designs whose failure modes end at a password prompt, never at an open shell or an unlocked session.

# Design choices

- Follow the official documentation (upstream manual, Arch Wiki, man pages) of the latest version of each tool. Check which version is the latest with web tools first; never assume it.
- Any choice that departs from the officially recommended setup must be presented first, saying how and why it departs, and applied only after approval.

# Testing instructions

- Verify behaviour by testing in a Docker `archlinux:latest` container, not by reasoning alone.
- The image's `/etc/pacman.conf` has `NoExtract` lines that drop docs and man pages: remove them (`sed -i '/NoExtract/d' /etc/pacman.conf`) before installing packages whose docs are needed.
- Test interactive behaviour (key bindings, completion, widgets) in a real terminal, e.g. a sized tmux session (`tmux new-session -d -x 120 -y 30`, then `send-keys` and `capture-pane`).
- Test systemd units with systemd as PID 1: run the container with `--privileged --cgroupns=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw` and `/usr/lib/systemd/systemd` as the command.
- Remove any containers and images created for testing when done.

# Configuration

Each H2 below is a menu of the official `archinstall` installer, checked against archinstall 4.5 (ISO 2026.11.01).

## Archinstall language

- Default

## Locales

- Default

## Mirrors and repositories

- Default

## Disk configuration

### Partitioning

- Use a best-effort default partition layout
- `ext4` main filesystem
- No separate partition for /home

### LVM

- None

### Disk encryption

- `LUKS` encryption type
- Root partition selected
- Default iteration time
- Default HSM (none)

## Swap

- Use swap on zram
- `zstd` zram compression algorithm

## Bootloader

- `Systemd-boot` bootloader
- Enabled unified kernel images
- Enabled Plymouth

## Kernels

- `linux` kernel

## Additional firmware

- None

## Hostname

- Default

## Authentication

### Root password

- None (root account stays locked)

### User account

- User account with superuser (sudo) access

### U2F login setup

- None

## Profile

- `Minimal` profile type

## Applications

### Bluetooth

- Enabled bluetooth configuration

### Audio

- `pipewire` audio configuration

### Print service

- Disabled print service configuration

### Power management

- `tuned` power management

### Firewall

- `ufw` firewall

### Additional fonts

- noto-fonts

## Network configuration

- Use Network Manager (default backend)

## Pacman

- Default

## Additional packages

- None

## Timezone

- Selected

## Automatic time sync (NTP)

- Default
