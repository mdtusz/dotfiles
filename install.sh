#!/usr/bin/env bash

source ./lib.sh

# Start, and maintain sudo
running "Installing all the things. Enter your password."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Change shell
# echo $SHELL | grep "zsh" > /dev/null 2>&1
if [[ $? == '' ]]; then
  action "Changing your shell to zsh."
  sudo chsh -s "$(which zsh)";
  ok "New shell is zsh."
else
  ok "Shell is already zsh."
fi


# Oh My Zsh
if [[ -e ~/.oh-my-zsh ]]; then
  ok "Oh My Zsh already installed."
else
  action "Installing Oh My Zsh."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  ok "Oh My Zsh successfully installed."
fi


# Vim
if [[ -e ~/.vim/autoload/plug.vim ]]; then
  ok "Vim Plug already installed."
else
  action "Installing Vim Plug."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ok "Vim Plug installed."
fi
