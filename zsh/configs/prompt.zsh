#!/bin/sh

setopt PROMPT_SUBST

git_changes() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    if [ -n "$(git status --porcelain)" ]; then
      echo "%F{yellow}"
    else
      echo "%F{green}"
    fi
  fi
}

PROMPT='%F{28}%2~ $(git_changes)❱%f '
