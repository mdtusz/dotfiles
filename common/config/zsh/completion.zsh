# Tab completion.

# All `fpath` additions must come before the single `compinit` call, so that
# the cached `.zcompdump` stays valid instead of being rebuilt on every startup.
fpath=("$HOME/.docker/completions" $fpath)
autoload -Uz compinit && compinit

# Match small letters to capital letters for autocompletion.
# Capital letters will only match capital letters.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
