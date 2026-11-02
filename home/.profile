export TERMINAL="ghostty"
export EDITOR="nvim"
export VISUAL="nvim"

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$PATH:$HOME/.local/bin" ;;
esac

# Pass the session environment to systemd user services and D-Bus activated apps
if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
    dbus-update-activation-environment --systemd TERMINAL EDITOR VISUAL PATH
fi
