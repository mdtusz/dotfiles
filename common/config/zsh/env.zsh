# General environment variables. Toolchain variables live in `toolchains.zsh`.

export LANG="en_US.UTF-8"
export EDITOR=hx
export SSH_KEY_PATH="$HOME/.ssh/id_rsa"

CODE_DIR="$HOME/Code"
# Wherever the repo is cloned: `ZDOTDIR` links to <repo>/common/config/zsh.
DOTFILES="${ZDOTDIR:A:h:h:h}"
