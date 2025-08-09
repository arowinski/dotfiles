#!/bin/sh

alias gc="git commit"
alias gcan="git commit --amend --no-edit"

alias gph="git push"
alias gphf="git push --force-with-lease"
alias gpl="git pull"

alias gco="git checkout"

alias gu="git reset"
alias gres="git reset --soft HEAD^"

alias gl="git log --pretty=format:\"%C(yellow)%h %C(magenta)%ad%Cred%d %Creset%s%Cblue [%an]\" --decorate --date=short -20"
alias glf="git log --pretty=format:\"%C(yellow)%h %C(magenta)%ad%Cred%d %Creset%s%Cblue [%an]\" --decorate --date=short"
alias glg='git log -E -i --grep'
alias gls='git log -S'

alias gs="git stash"
alias gsu="git stash -u"
alias gsg="git stash -u --keep-index"
alias gss="git stash save"
alias gsp="git stash pop"
alias gsl="git stash list"

alias gb="git branch"

alias gd="git diff --color=always"
alias gdc="git diff --cached --color=always"

alias gcp='git cherry-pick'

alias grb="git rebase"

alias gcon='git continue'
alias gabort='git abort'
alias gcl="git clean -fi ."
alias gwa="git worktree add"
alias gwr="git worktree remove"

compdef g=git
g() {
  if [[ $# -eq 0 ]] ; then
    git status -s -b
  else
    git $@
  fi
}
