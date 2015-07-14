#!/usr/bin/env bash

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
    echo -e "$COL_GREEN[ok]$COL_RESET "$1
}

function bot() {
    echo -e "\n$COL_GREEN(^ㅇㅅㅇ^)$COL_RESET - "$1
}

function running() {
    echo -en "$COL_YELLOW ⇒ $COL_RESET"$1": "
}

function action() {
    echo -e "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ $1..."
}

function warn() {
    echo -e "$COL_YELLOW[warning]$COL_RESET "$1
}

function error() {
    echo -e "$COL_RED[error]$COL_RESET "$1
}

function require_cask() {
    running "brew cask $1"
    brew cask list $1 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        action "brew cask install $1"
        brew cask install $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            exit -1
        fi
    fi
    ok
}

function require_brew() {
    running "brew $1"
    brew list $1 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        action "brew install $1"
        brew install $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            exit -1
        fi
    fi
    ok
}

function require_gem() {
    running "gem $1"
    if [[ $(gem list --local | grep $1 | head -1 | cut -d' ' -f1) != $1 ]]; then
        action "gem install $1"
        gem install $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            exit -1
        fi
    fi
    ok
}

function require_npm() {
    running "npm $1"
    npm list -g | grep $1 > /dev/null
    if [[ $? != 0 ]]; then
        action "npm install -g $1"
        npm install -g $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            exit -1
        fi
    fi
    ok
}

function require_pip() {
    running "pip $1"
    pip show $1
    if [[ $? != 0 ]]; then
        action "pip install $1"
        sudo pip install $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            exit -1
        fi
    fi
    ok
}

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