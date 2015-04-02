#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# Inspired/forked from Adam Eivy
###########################


# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

# make a backup directory for overwritten dotfiles
if [[ ! -e ~/.dotfiles_backup ]]; then
    mkdir ~/.dotfiles_backup
fi

bot "Hi. I'm going to make your OSX system the way it should be :)"

fullname=`osascript -e "long user name of (system info)"`
me=`dscl . -read /Users/$(whoami)`

lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
email=`dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`

if [[ ! "$firstname" ]];then
  response='n'
else
  echo -e "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
  read -r -p "Is this correct? [Y|n] " response
fi

if [[ $response =~ ^(no|n|N) ]];then
	read -r -p "What is your first name? " firstname
	read -r -p "What is your last name? " lastname
fi
fullname="$firstname $lastname"

bot "Great $fullname, "

if [[ ! $email ]];then
  response='n'
else
  echo -e "The best I can make out, your email address is $COL_YELLOW$email$COL_RESET"
  read -r -p "Is this correct? [Y|n] " response
fi

if [[ $response =~ ^(no|n|N) ]];then
	read -r -p "What is your email? " email
fi

read -r -p "What is your github.com username? " githubuser

running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"

# test if gnu-sed or osx sed

sed -i 's/Miklós Tuz/'$firstname' '$lastname'/' .gitconfig > /dev/null 2>&1 | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
  echo
  running "looks like you are using OSX sed rather than gnu-sed, accommodating"
  sed -i '' 's/Miklós Tusz/'$firstname' '$lastname'/' .gitconfig;
  sed -i '' 's/mdtusz@gmail.com/'$email'/' .gitconfig;
  sed -i '' 's/mdtusz/'$githubuser'/' .gitconfig;
  sed -i '' 's/miklos/'$(whoami)'/g' .zshrc;ok
else
  echo
  bot "looks like you are already using gnu-sed. woot!"
  sed -i 's/mdtusz@gmail.com/'$email'/' .gitconfig;
  sed -i 's/mdtusz/'$githubuser'/' .gitconfig;
  sed -i 's/miklos/'$(whoami)'/g' .zshrc;ok
fi

# read -r -p "OK? [Y/n] " response
#  if [[ ! $response =~ ^(yes|y|Y| ) ]];then
#     exit 1
#  fi

# bot "awesome. let's roll..."

echo $0 | grep zsh > /dev/null 2>&1 | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
	running "changing your login shell to zsh"
	chsh -s $(which zsh);ok
else
	bot "looks like you are already using zsh. woot!"
fi

pushd ~ > /dev/null 2>&1

function symlinkifne {
    running "$1"

    if [[ -e $1 ]]; then
        # file exists
        if [[ -L $1 ]]; then
            # it's already a simlink (could have come from this project)
            echo -en '\tsimlink exists, skipped\t';ok
            return
        fi
        # backup file does not exist yet
        if [[ ! -e ~/.dotfiles_backup/$1 ]];then
            mv $1 ~/.dotfiles_backup/
            echo -en 'backed up saved...';
        fi
    fi
    # create the link
    ln -s ~/.dotfiles/$1 $1
    echo -en 'linked';ok
}

bot "creating symlinks for project dotfiles..."

symlinkifne .crontab
symlinkifne .gitconfig
symlinkifne .gitignore
symlinkifne .profile
symlinkifne .shellaliases
symlinkifne .shellfn
symlinkifne .shellvars
symlinkifne .shellpaths
symlinkifne .zshrc

popd > /dev/null 2>&1

./osx.sh

bot "Woot! All done."