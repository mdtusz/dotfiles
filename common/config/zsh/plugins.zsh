# Plugins. Sourced last: they wrap the line-editor widgets defined before them,
# and zsh-syntax-highlighting must come after every other plugin.

if [[ $OSTYPE == darwin* ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ $OSTYPE == linux* ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
