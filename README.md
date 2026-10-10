# muen

Dotfiles and setup script for a fresh Arch Linux install.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/noxtgm/muen/main/install.sh | bash
```

This is the only supported way of installing muen.

## Layout

| Path | Contents |
|---|---|
| `install.sh` | Entry point |
| `lib/` | Helpers sourced by `install.sh` |
| `home/` | Configs, mirrored into `~` |
| `packages.pacman` | Official packages |
| `packages.aur` | AUR packages |
| `packages.npm` | npm packages |
