# MUEN

Deployment and setup logic of opinionated dotfiles on a fresh Arch Linux install.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/<author>/<repo>/<branch>/install.sh | bash
```

## Usage

```sh
muen update
```

## Layout

| Path | Contents |
|---|---|
| `install.sh` | First install entry point |
| `packages` | Official packages list |
| `bin/` | Command line interface bin command  |
| `config/` | Configs copied over to `.config` |
| `lib/` | Sourced shared helpers |
| `system/` | System configs copied over |
| `widget/` | Styled widgets |
