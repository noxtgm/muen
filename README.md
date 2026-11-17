# dots

Deployment and setup logic of opinionated dotfiles on a fresh Arch Linux install.

# Install

```sh
curl -fsSL https://raw.githubusercontent.com/<author>/<repo>/<branch>/install.sh | bash
```

# Usage

```sh
muen update          # Update the clone from the remote and deploy its configs
muen update --force  # Same logic but discards local changes in the clone and overwrites conflicting files in ~/.config
```

# Structure

```
.
├── bin/              # Update command-line entry point
├── lib/              # Sourced shared helpers and logic
├── root/             # Deployed files, laid out as on the end machine
│   ├── boot/         # System configs copied over to /boot/
│   ├── etc/          # System configs copied over to /etc/
│   └── home/user/    # User files deployed to the home directory of the user running muen
│       └── .config/  # User configs deployed to ~/.config/
├── widgets/          # Styled widgets matching a shared theme
├── install.sh        # Fresh install entry point
└── packages          # List of installed official packages
```
