source "$ZDOTDIR/settings.zsh"
source "$ZDOTDIR/prompt.zsh"

for file in "$ZDOTDIR"/aliases/*.zsh(N); do
    source "$file"
done
unset file

# zsh-syntax-highlighting must come after every other widget
source "$ZDOTDIR/plugins.zsh"
