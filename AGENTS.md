# Context

This project contains dotfiles and deployment scripts specifically configured and tuned to be deployed on the latest version of Arch Linux freshly installed using `archinstall`. It targets a single machine with a single SSD.

# Scope

- This project is tailored for a single user, who is also its only maintainer and runs it by hand; don't add handling for concurrent runs, duplicate entries in package lists, or comments in list files
- Until the project is complete and stable, target a fresh `archinstall` plus the current version only: no migration or cleanup code for machines set up with an earlier version, and no notes on how an existing machine would pick up a change

# Security considerations

- Security ALWAYS comes before convenience; when a choice trades one for the other (e.g. autologin, skipping a password, looser permissions, fewer prompts), default to the most secure option and present the convenient option with its security cost explained only
- Before implementing anything that changes how the user authenticates or what can capture input or the screen, audit it (verify claims in source AND documentation, test failure modes) and get explicit approval; prefer designs whose failure modes end at a password prompt, NEVER at an open shell or an unlocked session

# Design choices

- Follow the official documentation (upstream manual, Arch Wiki, man pages) of the latest version of each tool, and cite the doc and version a change follows; check which version is the latest with web tools first, NEVER assume it or outright trust potentially deprecated findings
- Any choice that departs from the officially recommended setup must be presented first, saying how and why it departs, and applied only after explicit approval from the user
- Check against how tools behave in their current versions

# Documentation access

- wiki.archlinux.org answers automated fetches with a bot check; instead read Arch Wiki pages from the `arch-wiki-docs` package in a container (it is a snapshot: compare its date with the live page), or ask the user to save the live page you require
- Other docs (upstream sites, GitHub, freedesktop specs) can be fetched directly; docs sites get reorganised often so find the current URL rather than guessing it

# Testing instructions

- Verify behavior by testing in a Docker `archlinux:latest` container, NEVER by reasoning alone
- Test interactive behavior (key bindings, completion, widgets, etc) in a real terminal
- Remove any containers and images created for testing when done with the tasks given

# archinstall configuration

Below is the selected configuration of the official `archinstall` installer, each H2 being a top-level menu of the installer etc.

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
