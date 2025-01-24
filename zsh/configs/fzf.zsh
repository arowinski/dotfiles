#!/bin/sh

source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='rg --hidden --files -g ""'
export FZF_DEFAULT_OPTS='--bind ctrl-space:abort --layout=reverse --bind ctrl-l:accept'

alias fzf="
  fzf \
  --reverse \
  --preview '(bat --color=always --style=header,grid --line-range :300 {} || \
      cat {}) 2> /dev/null' \
  --preview-window top:60% \
  --bind alt-j:preview-down,alt-k:preview-up,ctrl-k:up,ctrl-j:down"
