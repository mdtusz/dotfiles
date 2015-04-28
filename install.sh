#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# Inspired/forked from Adam Eivy
###########################


# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

bot "Hi. I'm going to make your OSX system the way it should be :)"

read -r -p "What is your first name? " firstname
read -r -p "What is your last name? " lastname
read -r -p "What is your email? " email
read -r -p "What is your github.com username? " githubuser
fullname="$firstname $lastname"

bot "Great $fullname, let's roll..."

echo $0 | grep zsh > /dev/null 2>&1 | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
	running "changing your login shell to zsh"
	chsh -s $(which zsh);ok
else
	bot "Looks like you are already using zsh. woot!"
fi

running "let's install oh-my-zsh now"
if [[ -e ~/.oh-my-zsh ]]; then
  echo 'Looks like you already have oh-my-zsh too!';ok
else
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh;ok
fi

pushd ~ > /dev/null 2>&1

function symlinkifne {
    running "$1"

    if [[ -L $1 ]]; then
        # it's already a simlink (could have come from this project)
        echo -en '\tsymlink exists, skipped\t';ok
        return
    fi
    # create the link
    ln -s ~/.dotfiles/$1 $1
    echo -en 'linked';ok
}

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

# Install vundle for Vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

./osx.sh

bot "Woot! All done."
