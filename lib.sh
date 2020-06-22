#!/usr/bin/env bash

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_YELLOW=$ESC_SEQ"33;01m"

function ok() {
  echo -e "${COL_GREEN}[ok]:${COL_RESET} $1"
}

function running() {
  echo -e "\n${COL_BLUE}[run]:${COL_RESET} $1"
}

function action() {
  echo -e "${COL_YELLOW}[action]:${COL_RESET} $1"
}

function error() {
  echo -e "${COL_RED}[error]:${COL_RESET} $1"
}

function symifne() {
  action "Linking $1."

  if [[ -L $1 ]]; then
    ok "Symlink exists."
    return
  fi

  ln -s "$HOME/.dotfiles/$1" "$1"
  ok "Linked $1.";
}
