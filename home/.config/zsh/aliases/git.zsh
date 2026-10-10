if (( $+commands[git] )); then
    alias gaa='git add -A'
    alias gcm='git commit -m'
    alias gca='git commit --amend'
    alias gcan='git commit --amend --no-edit'
    alias gph='git push'
    alias gpl='git pull'
    alias gplr='git pull --rebase'
    alias gr='git rebase'
    alias gf='git fetch'
fi
