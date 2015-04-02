# Set to this to use case-sensitive completion
export CASE_SENSITIVE="false"

autoload -U compinit promptinit zsh-mime-setup colors
colors
compinit
promptinit
zsh-mime-setup

# Options
setopt AUTO_CD
setopt MULTIOS
setopt CORRECT
setopt AUTO_NAME_DIRS
setopt GLOB_COMPLETE
setopt PUSHD_MINUS
setopt NO_HUP

export EDITOR="subl -w"
export PATH=$PATH:/usr/local/bin:/usr/bin
export LANG=en_US

# History
HISTFILE=~/.history
SAVEHIST=10000
HISTSIZE=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
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

host_color=cyan
history_color=yellow
user_color=green
root_color=red
directory_color=magenta
error_color=red
jobs_color=green

host_prompt="%{$fg_bold[$host_color]%}%m%{$reset_color%}"
jobs_prompt1="%{$fg_bold[$jobs_color]%}(%{$reset_color%}"
jobs_prompt2="%{$fg[$jobs_color]%}%j%{$reset_color%}"
jobs_prompt3="%{$fg_bold[$jobs_color]%})%{$reset_color%}"
jobs_total="%(1j.${jobs_prompt1}${jobs_prompt2}${jobs_prompt3} .)"
history_prompt1="%{$fg_bold[$history_color]%}[%{$reset_color%}"
history_prompt2="%{$fg[$history_color]%}%h%{$reset_color%}"
history_prompt3="%{$fg_bold[$history_color]%}]%{$reset_color%}"
history_total="${history_prompt1}${history_prompt2}${history_prompt3}"
error_prompt1="%{$fg_bold[$error_color]%}<%{$reset_color%}"
error_prompt2="%{$fg[$error_color]%}%?%{$reset_color%}"
error_prompt3="%{$fg_bold[$error_color]%}>%{$reset_color%}"
error_total="%(?..${error_prompt1}${error_prompt2}${error_prompt3} )"

case "$TERM" in
  (screen)
    function precmd() { print -Pn "\033]0;S $TTY:t{%100<...<%~%<<}\007" }
  ;;
  (xterm)
    directory_prompt=""
  ;;
  (*)
    directory_prompt="%{$fg[$directory_color]%}%~%{$reset_color%} "
  ;;
esac

if [[ $USER == root ]]; then
    post_prompt="%{$fg_bold[$root_color]%}%#%{$reset_color%}"
else
    post_prompt="%{$fg_bold[$user_color]%}%#%{$reset_color%}"
fi

PS1="${host_prompt} ${jobs_total}${history_total} ${directory_prompt}${error_total}${post_prompt} "
