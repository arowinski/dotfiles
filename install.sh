DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ln -sfn $DIR/rgignore $HOME/.rgignore
ln -sfn $DIR/zsh $HOME/.zsh
ln -sfn $DIR/bin $HOME/.bin
ln -sfn $DIR/git/gitconfig $HOME/.gitconfig
ln -sfn $DIR/psql/psqlrc $HOME.psqlrc
ln -sfn $DIR/rspec/rspec $HOME/.rspec
ln -sfn $DIR/tmux/tmux.conf $HOME/.tmux.conf
ln -sfn $DIR/pry/pryrc $HOME/.pryrc
ln -sfn $DIR/vim $HOME/.vim
ln -sfn $DIR/ctags/ctags $HOME/.ctags.d/.ctags
ln -sfn $DIR/Brewfile $HOME/.Brewfile
ln -sfg $DIR/vim/solargraph.yml $HOME/.config/solargraph/solargraph.yml
echo 'System: symlinks created'

brew bundle --global
echo 'Brew bundled!'

if ! [ -f "/home/$USER/.vim/autoload/plug.vim" ]; then
  echo 'Vim: installing plugin manager plug.vim'
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo 'Vim: plugin manager already installed (plug.vim)'
fi

if ! [ -x "$(command -v yarn)" ]; then
  echo 'Error: YARN not installed. Install and run script again' >&2
  exit 1
else
  if ! [ -x "$(command -v npx)" ]; then
    yarn global add npx
  fi
fi

vim +PlugInstall +qall > /dev/null
echo 'Vim: plugins installed'

echo 'Done'
