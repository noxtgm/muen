# muen

Dotfiles and setup script for a fresh Arch Linux install.

## Requirements

- A minimal Arch Linux install done with `archinstall`
- A regular user with sudo access
- A network connection

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/noxtgm/muen/main/install.sh | bash
```

To skip the reboot:

```sh
curl -fsSL https://raw.githubusercontent.com/noxtgm/muen/main/install.sh | bash -s -- --no-reboot
```

From a local checkout, run `./install.sh` (or `./install.sh --no-reboot`) to install from that checkout instead of cloning.

## Layout

| Path | Contents |
|---|---|
| `install.sh` | Entry point |
| `lib/` | Helpers sourced by `install.sh` |
| `home/` | Configs, mirrored into `~` |
| `packages.pacman` | Official packages |
| `packages.aur` | AUR packages |
| `packages.npm` | npm packages |
