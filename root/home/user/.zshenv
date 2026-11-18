# See https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files and the zsh entry of https://wiki.archlinux.org/title/XDG_Base_Directory
export ZDOTDIR="${XDG_CONFIG_HOME:-${HOME}/.config}/zsh"

# See https://wiki.archlinux.org/title/Zsh#Configuring_$PATH
typeset -U path PATH
path=($path ~/.local/bin)
export PATH

# See https://wiki.archlinux.org/title/Environment_variables#Default_programs
export EDITOR=nvim
export VISUAL=nvim
