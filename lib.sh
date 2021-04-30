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
    SRC=$1
    DEST=$1

    if [[ -z "$2" ]]; then
        DEST=$2
    fi

    action "Creating symlink from $DEST to $SRC."
    read -rp "Continue? [Y/n]: " yn

    case $yn in
        [Nn]* ) return;;
    esac

    if [[ -L "$DEST" ]]; then
        ok "Symlink destination already exists."
        return
    fi

    ln -s "$HOME/.dotfiles/$SRC" "$DEST"
    ok "Linked $DEST.";
}
