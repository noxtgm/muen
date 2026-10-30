# Session environment, sourced by greetd and by zsh login shells through .zprofile
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="ghostty"

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$PATH:$HOME/.local/bin" ;;
esac
