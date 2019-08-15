#!/bin/bash

## peco install
wget https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_amd64.tar.gz
tar xvfz peco_linux_amd64.tar.gz
cd peco_linux_amd64
chmod 755 peco
sudo mv peco /usr/local/bin/
cd .. && rm -r peco_linux_amd64 peco_linux_amd64.tar.gz

## rg
wget https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep-11.0.1-x86_64-unknown-linux-musl.tar.gz
tar xvfz ripgrep-11.0.1-x86_64-unknown-linux-musl.tar.gz
cd ripgrep-11.0.1-x86_64-unknown-linux-musl/
chmod 755 rg
sudo mv rg /usr/local/bin/
cd .. && rm -r ripgrep-11.0.1-x86_64-unknown-linux-musl ripgrep-11.0.1-x86_64-unknown-linux-musl.tar.gz

CURDIR=$(
  cd $(dirname $0)
  pwd
)

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# add symlink
ln -sf $CURDIR/.vimrc $HOME/.vimrc
ln -sf $CURDIR/.tmux.conf $HOME/.tmux.conf
