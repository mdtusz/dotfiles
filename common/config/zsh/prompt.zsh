# Prompt, based on the "minimal" theme (https://github.com/subnixr/minimal),
# trimmed to the parts in use.
#
#   Left:  [ssh hostname, on a dark orange badge] user char (red after an error,
#          bold with background jobs), then the vi keymap char
#   Right: last two directories, git branch (⚡ when the tree is dirty)

autoload -Uz add-zsh-hook

mtzc_ok_color=2
mtzc_err_color=1
mtzc_war_color=3
mtzc_ssh_bg_color=94  # 256-color dark orange (#875f00)
mtzc_ssh_fg_color=15  # theme foreground; color 0 is grey in kitty theme

mtzc_user_char="μτ"
mtzc_insert_char="›"
mtzc_normal_char="·"
mtzc_ellipsis_char=".."
mtzc_bgjob_mode=4

# Components shown on each side, in order. Each is a function (with optional
# arguments) whose output is joined with spaces.
mtzc_prompt=(mtzc_ssh mtzc_status mtzc_keymap)
mtzc_rprompt=('mtzc_cwd 2 0' mtzc_git)


# Components
###############################################################################

function mtzc_ssh {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        printf '%b' "%{\e[48;5;${mtzc_ssh_bg_color};38;5;${mtzc_ssh_fg_color}m%} $(hostname -s) %{\e[0m%}"
    fi
}

function mtzc_status {
    local okc="$mtzc_ok_color"
    local errc="$mtzc_err_color"
    local uchar="$mtzc_user_char"

    local job_ansi="0"
    if [ -n "$(jobs | sed -n '$=')" ]; then
        job_ansi="$mtzc_bgjob_mode"
    fi

    local err_ansi="$mtzc_ok_color"
    if [ "$mtzc_last_err" != "0" ]; then
        err_ansi="$mtzc_err_color"
    fi

    printf '%b' "%{\e[$job_ansi;3${err_ansi}m%}%(!.#.$uchar)%{\e[0m%}"
}

function mtzc_keymap {
    local kmstat="$mtzc_insert_char"
    [ "$KEYMAP" = 'vicmd' ] && kmstat="$mtzc_normal_char"
    printf '%b' "$kmstat"
}

function mtzc_cwd {
    local echar="$mtzc_ellipsis_char"
    local segments="${1:-2}"
    local seg_len="${2:-0}"

    local _w="%{\e[0m%}"
    local _g="%{\e[38;5;244m%}"

    if [ "$segments" -le 0 ]; then
        segments=0
    fi
    if [ "$seg_len" -gt 0 ] && [ "$seg_len" -lt 4 ]; then
        seg_len=4
    fi
    local seg_hlen=$((seg_len / 2 - 1))

    local cwd="%${segments}~"
    cwd="${(%)cwd}"
    cwd=("${(@s:/:)cwd}")

    local pi=""
    for i in {1..${#cwd}}; do
        pi="$cwd[$i]"
        if [ "$seg_len" -gt 0 ] && [ "${#pi}" -gt "$seg_len" ]; then
            cwd[$i]="${pi:0:$seg_hlen}$_w$echar$_g${pi: -$seg_hlen}"
        fi
    done

    printf '%b' "$_g${(j:/:)cwd//\//$_w/$_g}$_w"
}


# Git branch, computed in the background so a slow `git status` doesn't delay
# the prompt. `_mtzc_git_precmd` starts a worker before each prompt, and
# `_mtzc_git_async_done` redraws the prompt when the worker's output arrives.
###############################################################################

typeset -g _mtzc_git_info=""
typeset -g _mtzc_git_fd=""

function mtzc_git {
    printf '%b' "$_mtzc_git_info"
}

function _mtzc_git_async_worker {
    local statc="%{\e[0;3${mtzc_ok_color}m%}" # assume clean
    local bname="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

    if [ -n "$bname" ]; then
        if [ -n "$(git status --porcelain 2> /dev/null)" ]; then
            statc="%{\e[0;3${mtzc_war_color}m%} 󱐋 "
        fi
        printf '%s' "$statc%{\e[0;3${mtzc_err_color}m%}$bname%{\e[0m%}"
    fi
}

function _mtzc_git_async_done {
    local fd=$1
    zle -F $fd
    local result=""
    read -r result <&$fd
    exec {fd}<&-
    _mtzc_git_fd=""
    if [[ "$result" != "$_mtzc_git_info" ]]; then
        _mtzc_git_info="$result"
        zle && zle reset-prompt
    fi
}

function _mtzc_git_precmd {
    if [[ -n "$_mtzc_git_fd" ]]; then
        zle -F $_mtzc_git_fd 2>/dev/null
        { exec {_mtzc_git_fd}<&- } 2>/dev/null
        _mtzc_git_fd=""
    fi

    exec {_mtzc_git_fd} < <(_mtzc_git_async_worker)
    zle -F $_mtzc_git_fd _mtzc_git_async_done
}


# Wiring
###############################################################################

# Join the output of the components named in the array $1.
function _mtzc_wrap {
    local -a arr
    arr=()
    local cmd_out=""
    local cmd
    for cmd in ${(P)1}; do
        cmd_out="$(eval "$cmd")"
        if [ -n "$cmd_out" ]; then
            arr+="$cmd_out"
        fi
    done

    printf '%b' "${(j: :)arr}"
}

# Capture exit status and reset prompt.
function _mtzc_zle-line-init {
    mtzc_last_err="$?" # I need to capture this ASAP
    zle reset-prompt
}

# Redraw prompt on keymap select.
function _mtzc_zle-keymap-select {
    zle reset-prompt
}

# Bind the widgets above, chaining to any existing user widget of the same name.
# See: https://github.com/zsh-users/zsh-syntax-highlighting/blob/1f1e629290773bd6f9673f364303219d6da11129/zsh-syntax-highlighting.zsh#L292-L356
function _mtzc_bind_widgets() {
    zmodload zsh/zleparameter

    local -a to_bind
    to_bind=(zle-line-init zle-keymap-select)

    typeset -F SECONDS
    local zle_wprefix=s$SECONDS-r$RANDOM

    local cur_widget
    for cur_widget in $to_bind; do
        case "${widgets[$cur_widget]:-""}" in
            user:_mtzc_*);;
            user:*)
                zle -N $zle_wprefix-$cur_widget ${widgets[$cur_widget]#*:}
                eval "_mtzc_ww_${(q)zle_wprefix}-${(q)cur_widget}() { _mtzc_${(q)cur_widget}; zle ${(q)zle_wprefix}-${(q)cur_widget} }"
                zle -N $cur_widget _mtzc_ww_$zle_wprefix-$cur_widget
                ;;
            *)
                zle -N $cur_widget _mtzc_$cur_widget
                ;;
        esac
    done
}

setopt prompt_subst

PROMPT='$(_mtzc_wrap mtzc_prompt) '
RPROMPT='$(_mtzc_wrap mtzc_rprompt)'

_mtzc_bind_widgets

add-zsh-hook precmd _mtzc_git_precmd
