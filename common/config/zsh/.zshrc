# Interactive zsh setup. Each file holds one topic and is loaded in order.
# `ZDOTDIR` (this directory) is set in `.zshenv`.

source "$ZDOTDIR/env.zsh"         # General environment variables
source "$ZDOTDIR/path.zsh"        # General PATH entries (needs `env.zsh`)
source "$ZDOTDIR/toolchains.zsh"  # Language toolchains: Rust, Go, Python, Node
source "$ZDOTDIR/options.zsh"     # Shell options and history
source "$ZDOTDIR/completion.zsh"  # Tab completion
source "$ZDOTDIR/prompt.zsh"      # Prompt
source "$ZDOTDIR/aliases.zsh"     # Aliases
source "$ZDOTDIR/functions.zsh"   # Shell functions
source "$ZDOTDIR/plugins.zsh"     # Must be last: plugins wrap the widgets defined above
