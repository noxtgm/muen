for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ -f "/usr/share/zsh/plugins/${plugin}/${plugin}.zsh" ]]; then
        source "/usr/share/zsh/plugins/${plugin}/${plugin}.zsh"
    fi
done
unset plugin
