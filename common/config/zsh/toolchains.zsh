# Language toolchains and version managers: their environment variables,
# PATH entries and shell hooks. Uses `path_prepend` from `path.zsh`.

autoload -Uz add-zsh-hook

# Rust
###############################################################################
# `.zshenv` also sources `~/.cargo/env`, which adds this for non-interactive
# shells.
path_prepend "$HOME/.cargo/bin"

# Go
###############################################################################
export GOPATH="$HOME/code/go"
path_prepend "$GOPATH/bin"

# Python
###############################################################################
export PYENV_ROOT="$HOME/.pyenv"
path_prepend "$PYENV_ROOT/bin"

# Node
###############################################################################
# export NPM_CONFIG_PREFIX="$HOME/.node_modules"
unset NPM_CONFIG_PREFIX

# Switch to the version in the nearest `.nvmrc` when changing directory, or
# back to the default version when leaving a directory that had one.
# Does nothing until nvm has been loaded.
function load-nvmrc() {
  (( $+functions[nvm_find_nvmrc] )) || return
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

if [[ $OSTYPE == darwin* ]]; then
  export NVM_DIR="$HOME/.config/.nvm"

  # Lazy-load nvm: defer sourcing nvm.sh until node/npm/npx/nvm is first used.
  # Until then, scripts that run `node` directly get Homebrew's version.
  function _nvm_lazy_load {
    unfunction node npm npx nvm _nvm_lazy_load
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    load-nvmrc
  }
  function node npm npx nvm { _nvm_lazy_load; "$0" "$@" }
fi
