# Path to your oh-my-zsh installation.
export ZSH=/Users/miklos/.oh-my-zsh

ZSH_THEME="miloshadzic"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export EDITOR='vim'

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

# Load aliases, paths etc
source ${HOME}/.shellaliases
source ${HOME}/.shellpaths
source ${HOME}/.shellfn

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
