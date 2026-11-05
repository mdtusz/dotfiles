# General PATH entries. Language toolchains add theirs in `toolchains.zsh`.

# Keep PATH free of duplicates, so nested shells don't keep growing it.
typeset -U path

# Add a directory to the front/back of PATH, skipping it if it doesn't exist.
path_prepend() { if [[ -d $1 ]]; then path=("$1" $path); fi }
path_append() { if [[ -d $1 ]]; then path+=("$1"); fi }

if [[ $OSTYPE == darwin* ]]; then
  path_prepend /opt/homebrew/bin
fi

# Scripts from the repo's `<layer>/bin` folders, linked by `dotfiles.sh link`.
path_prepend "$HOME/.local/bin"

path_prepend "$HOME/.node_modules/bin"

# Docker Desktop CLI tools. Docker Desktop adds this to `~/.zprofile`, which
# zsh never reads because `ZDOTDIR` points elsewhere.
path_append "$HOME/.docker/bin"
