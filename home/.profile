export TERMINAL="ghostty"
export EDITOR="nvim"
export VISUAL="nvim"

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$PATH:$HOME/.local/bin" ;;
esac
