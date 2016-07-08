#!/usr/bin/env bash

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_YELLOW=$ESC_SEQ"33;01m"

function ok() {
  echo -e "$COL_GREEN[ok]:$COL_RESET $1"
}

function running() {
  echo -e "\n$COL_BLUE[run]:$COL_RESET $1"
}

function action() {
  echo -e "$COL_YELLOW[action]:$COL_RESET $1"
}

function error() {
  echo -e "$COL_RED[error]:$COL_RESET $1"
}

function symifne() {
  action "Linking $1."
  
  if [[ -L $1 ]]; then
    ok "Symlink exists."
    return
  fi

  ln -s ~/.dotfiles/$1 $1
  ok "Linked $1."; 
}

npmi() {
  npm list -g | grep $1 > /dev/null 2>&1
  
  if [[ $? != 0 ]]; then
    action "NPM installing $1."
    npm install -g $1
    
    if [[ $? != 0 ]]; then
      error "Failed to install $1!"
      exit -1
    else
      ok "Installed $1 successfully."
    fi
  fi
}

function pipi() {
  pip3 show $1 > /dev/null 2>&1
  
  if [[ $? != 0 ]]; then
    action "Pip installing $1."
    sudo pip3 install $1
    
    if [[ $? != 0 ]]; then
      error "Failed to install $1!"
      exit -1
    else
      ok "Installed $1 successfully."
    fi
  fi
}

function brewi() {
  brew list $1 > /dev/null 2>&1

  if [[ $? != 0 ]]; then
    action "Brew installing $1."
    brew install $1
    
    if [[ $? != 0 ]]; then
      error "Failed to install $1!"
      exit -1
    else
      ok "Installed $1 successfully."
    fi
  fi
}

function caski() {
  brew cask list $1 > /dev/null 2>&1
  
  if [[ $? != 0 ]]; then
    action "Cask installing $1."
    brew cask install $1
    
    if [[ $? != 0 ]]; then
      error "Failed to install $1!"
      exit -1
    else
      ok "Installed $1 successfully."
    fi
  fi
}
 
function gemi() {
  gem list --local | grep $1 | head -1 | cut -d' ' -f1 > /dev/null 2>&1
  
  if [[ $? != $1 ]]; then
    action "Gem installing $1."
    gem install $1
    
    if [[ $? != 0 ]]; then
      error "Failed to install $1!"
      exit -1
    else
      ok "Installed $1 successfully."
    fi
  fi
}
