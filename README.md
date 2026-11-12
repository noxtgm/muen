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
├── bin/        # Update command-line entry point
├── configs/    # Configs linked over to ~/.config/
├── lib/        # Sourced shared helpers and logic
├── system/     # System-level configs copied over
├── widgets/    # Styled widgets following a shared theme
├── install.sh  # Fresh install entry point
└── packages    # List of installed official packages
```
