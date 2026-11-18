# See https://wiki.archlinux.org/title/XDG_Base_Directory#Specification and https://wiki.archlinux.org/title/Environment_variables#Using_shell_initialization_files
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# See https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files and the zsh entry of https://wiki.archlinux.org/title/XDG_Base_Directory
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

# See https://wiki.archlinux.org/title/Zsh#Configuring_$PATH
typeset -U path PATH
path=($path ~/.local/bin)
export PATH

# See https://wiki.archlinux.org/title/Environment_variables#Default_programs
export EDITOR=nvim
export VISUAL=nvim
