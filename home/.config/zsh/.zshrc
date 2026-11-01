source "$ZDOTDIR/settings.zsh"

for file in "$ZDOTDIR"/aliases/*.zsh(N); do
    source "$file"
done
unset file

# Must stay last zsh-syntax-highlighting has to load after every widget, compinit and zle hook
source "$ZDOTDIR/plugins.zsh"
