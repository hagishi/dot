#!/bin/bash

CURDIR=$(
  cd $(dirname $0)
  pwd
)

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# add symlink
ln -sf $CURDIR/.vimrc $HOME/.vimrc
ln -sf $CURDIR/.tmux.conf $HOME/.tmux.conf
