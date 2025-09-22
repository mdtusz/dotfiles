# # Path to your oh-my-zsh installation.
source $ZDOTDIR/minimal.zsh

autoload -Uz compinit && compinit

# Match small letters to capital letters for autocompletion.
# Capital letters will only match capital letters.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     platform=linux;;
    Darwin*)    platform=mac;;
    *)          platform="unknown:${unameOut}"
esac

export PLATFORM="$platform"

if [[ $PLATFORM == "linux" ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ $PLATFORM == "mac" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
  
CODE_DIR="$HOME/Code"
DOTFILES="$CODE_DIR/dotfiles"

plugins=(git git-extras gpg-agent)

# # Load aliases, paths etc
source $ZDOTDIR/.shellvars
source $ZDOTDIR/.shellaliases
source $ZDOTDIR/.shellpaths
source $ZDOTDIR/.shellfn
