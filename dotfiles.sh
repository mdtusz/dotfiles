#!/usr/bin/env bash

source ./lib.sh

# Dotfiles and such
pushd $HOME > /dev/null 2>&1

running "Creating symlinks for dotfiles."

symifne .zshrc "$HOME/.zshrc"
symifne .vimrc "$HOME/.vimrc"
symifne .gitconfig "$HOME/.gitconfig"

# X configuration
symifne .Xresources "$HOME/.Xresources"
symifne .Xmodmap "$HOME/.Xmodmap"

popd > /dev/null 2>&1


# Configs
pushd $HOME/.config > /dev/null 2>&1
running "Creating symlinks for config directories and files."

symifne config/dunst "$HOME/.config/dunst"
symifne config/flameshot "$HOME/.config/flameshot"
symifne config/i3 "$HOME/.config/i3"
symifne config/kitty "$HOME/.config/kitty"
symifne config/polybar "$HOME/.config/polybar"
symifne config/qutebrowser "$HOME/.config/qutebrowser"
symifne config/rofi "$HOME/.config/rofi"

popd > /dev/null 2>&1
