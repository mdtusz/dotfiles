source ~/.profile

# ZSH things
export ZSH=/Users/Miklos/.oh-my-zsh
ZSH_THEME="miloshadzic"
COMPLETION_WAITING_DOTS="true"
plugins=(git, aws, cabal, docker, npm, osx, pip)
source $ZSH/oh-my-zsh.sh
export CASE_SENSITIVE="false"
export LANG=en_US.UTF-8


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='subl -w'
fi

# History
HISTFILE=~/.history
SAVEHIST=10000
HISTSIZE=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_VERIFY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

