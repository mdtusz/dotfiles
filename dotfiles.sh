#!/usr/bin/env bash

source ./lib.sh

pushd ~ > /dev/null 2>&1

running "Creating symlinks for dotfiles."

symifne .shellaliases
symifne .shellfn
symifne .shellpaths
symifne .profile

symifne .zshrc
symifne .vimrc

symifne .ghci
symifne .gitconfig

popd > /dev/null 2>&1



