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
  sudo chsh -s $(which zsh);
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


# Homebrew
which brew > /dev/null 2>&1
if [[ $? != 0 ]]; then
  action "Installing Homebrew."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Add casks
  brew tap caskroom/versions
  brew tap caskroom/fonts

  ok "Homebrew successfully installed."
else
  ok "Homebrew already installed."
fi


# Update packages
action "Updating homebrew and upgrading packages."
brew update
brew upgrade
ok "Homebrew packages upgraded."


# Install section
action "Installing software from manifests."

while read line; do
  caski $line
done < cask.txt

while read line; do
  brewi $line
done < brew.txt

while read line; do
  npmi $line
done < npm.txt

while read line; do
  pipi $line
done < pip.txt

ok "Software installation complete."





