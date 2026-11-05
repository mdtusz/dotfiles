# Plugins. Sourced last: they wrap the line-editor widgets defined before them,
# and zsh-syntax-highlighting must come after every other plugin.

# Source the first file that exists: Homebrew, Arch, then Debian/Ubuntu paths.
source_first() {
  local f
  for f in "$@"; do
    if [[ -r $f ]]; then source "$f"; return; fi
  done
}

source_first \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source_first \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unfunction source_first
