export EDITOR="nvim"
export VISUAL="nvim"
export PNPM_HOME="$HOME/.local/share/pnpm"

typeset -U path
path=("$PNPM_HOME/bin" "$HOME/.local/bin" $path)
