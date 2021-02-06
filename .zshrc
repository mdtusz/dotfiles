# # Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

ZSH_THEME="miloshadzic"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

DOTFILES="$HOME/.dotfiles"

plugins=(git git-extras gpg-agent)

source $ZSH/oh-my-zsh.sh

# # Load aliases, paths etc
source $DOTFILES/.shellvars
source $DOTFILES/.shellaliases
source $DOTFILES/.shellpaths
source $DOTFILES/.shellfn

# # Initialize nvm and pyenv.
# source /usr/share/nvm/init-nvm.sh
# eval "$(pyenv init -)"

autoload -U compinit
compinit

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
