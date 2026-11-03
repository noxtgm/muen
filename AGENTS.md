# Context

This project contains dotfiles and deployment scripts specifically configured and tuned to be deployed on the latest version of Arch Linux freshly installed using `archinstall`. It targets one machine with a single SSD.

# Scope

- muen has a single user, who is also its only maintainer and runs it by hand. Don't add handling for concurrent runs, duplicate entries in package lists, or comments in list files.
- Until muen is complete and stable, target a fresh `archinstall` plus the current muen only: no migration or cleanup code for machines set up with an earlier version, and no notes on how an existing machine would pick up a change. Every step must still be safe to re-run on the same install.

# Security considerations

- Security comes before convenience. When a choice trades one for the other (autologin, skipping a password, looser permissions, fewer prompts), default to the secure option and present the convenient one only with its security cost spelled out.
- Before implementing anything that changes how the user authenticates or what can capture input or the screen, audit it (verify claims in source AND docs, test failure modes) and get explicit approval. Prefer designs whose failure modes end at a password prompt, NEVER at an open shell or an unlocked session.

# Design choices

- Follow the official documentation (upstream manual, Arch Wiki, man pages) of the latest version of each tool, and cite the doc and version a change follows. Check which version is the latest with web tools first; NEVER assume it or outright trust deprecated findings.
- Any choice that departs from the officially recommended setup must be presented first, saying how and why it departs, and applied only after approval.
- Check against how tools behave in their current versions. Don't flag or guard against possible future upstream changes.

# Documentation access

- wiki.archlinux.org answers automated fetches with a bot check. Read Arch Wiki pages from the `arch-wiki-docs` package in a container instead (it is a snapshot: compare its date with the live page when recency matters), or ask the user to save the live page.
- For man pages and package docs, install the package plus `man-db` in a container; READMEs often ship in `/usr/share/doc/<pkg>/`.
- Other docs (upstream sites, GitHub, freedesktop specs) can be fetched directly. Docs sites get reorganised, so find the current URL rather than guessing.

# Testing instructions

- Verify behaviour by testing in a Docker `archlinux:latest` container, NOT by reasoning alone.
- The image's `/etc/pacman.conf` has `NoExtract` lines that drop docs and man pages: remove them (`sed -i '/NoExtract/d' /etc/pacman.conf`) before installing packages whose docs are needed.
- The image lacks `diff`, `cmp` and `python3`: install `diffutils` or `python` when needed.
- Test interactive behaviour (key bindings, completion, widgets) in a real terminal.
- Containers share the Docker VM's kernel. Never boot systemd in a privileged container, apply kernel settings (sysctl) or load kernel modules: the change hits the shared kernel, not just the container. If it happens anyway, tell the user; restarting the Docker VM (`wsl --shutdown` on this Windows host) resets it.
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
- Encryption password set
- Default iteration time
- Root partition selected
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

- Disabled bluetooth configuration

### Audio

- `pipewire` audio configuration

### Print service

- Disabled print service configuration

### Power management

- `power-profiles-daemon` power management

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

- Local timezone selected (not the UTC default)

## Automatic time sync (NTP)

- Default
