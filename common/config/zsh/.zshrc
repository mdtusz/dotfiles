autoload -Uz add-zsh-hook compinit && compinit

# Match small letters to capital letters for autocompletion.
# Capital letters will only match capital letters.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select


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

  export PATH="/opt/homebrew/bin:$PATH"

  export NVM_DIR="$HOME/.config/.nvm"

  # Lazy-load nvm: defer sourcing nvm.sh until node/npm/npx/nvm is first used
  function _nvm_lazy_load {
    unfunction node npm npx nvm _nvm_lazy_load
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    load-nvmrc
  }
  function node npm npx nvm { _nvm_lazy_load; "$0" "$@" }
fi

CODE_DIR="$HOME/Code"
DOTFILES="$CODE_DIR/dotfiles"

# History Configuration
###############################################################################
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY

plugins=(git git-extras gpg-agent)

# Load aliases, paths etc
###############################################################################
source "$ZDOTDIR/minimal.zsh"

source "$ZDOTDIR/.shellvars"
source "$ZDOTDIR/.shellaliases"
source "$ZDOTDIR/.shellpaths"
source "$ZDOTDIR/.shellfn"


# Nvm stuff
###############################################################################
function load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
