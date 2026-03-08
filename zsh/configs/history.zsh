if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=50000
SAVEHIST=50000

alias history='fc -l 1'

setopt extended_history
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
setopt no_beep
