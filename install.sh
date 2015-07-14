#!/usr/bin/env bash

# Miklós Tusz' dotfiles for OSX.
# Mega sweet super awesome setup

# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

bot "Dotfile cat is gonna make your new machine all sparkly and awesome. But first:"

read -r -p "What is your first name? " firstname
read -r -p "What is your last name? " lastname
read -r -p "What is your email? " email
read -r -p "What is your github.com username? " githubuser
fullname="$firstname $lastname"

bot "Let's get started, $firstname."

# Change shell to zsh
echo $0 | grep zsh > /dev/null 2>&1 | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
  running "Changing your login shell to zsh"
  chsh -s $(which zsh);ok
else
  bot "Looks like you are already using zsh. Perfect."
fi

running "install oh-my-zsh"
if [[ -e ~/.oh-my-zsh ]]; then
  echo 'oh-my-zsh already installed';ok
else
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh;ok
fi

pushd ~ > /dev/null 2>&1


bot "Creating symlinks for project dotfiles..."

symlinkifne .crontab
symlinkifne .gitconfig
symlinkifne .gitignore
symlinkifne .shellaliases
symlinkifne .shellfn
symlinkifne .shellvars
symlinkifne .shellpaths
symlinkifne .profile
symlinkifne .zshrc
symlinkifne .vimrc

popd > /dev/null 2>&1

./osx.sh

bot "Setup complete!"
