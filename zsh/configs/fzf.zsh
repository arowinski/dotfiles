source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='rg --hidden --files'
export FZF_DEFAULT_OPTS='--bind ctrl-space:abort --layout=reverse --bind ctrl-l:accept'

alias fzf="
  fzf \
  --preview 'cat {} 2> /dev/null' \
  --preview-window top:60% \
  --bind alt-j:preview-down,alt-k:preview-up,ctrl-k:up,ctrl-j:down"
