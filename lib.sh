#!/usr/bin/env bash
# Helpers for dotfiles.sh. Must stay compatible with bash 3.2 (macOS default).

if [[ -t 1 ]]; then
    COL_RESET=$'\033[0m'
    COL_RED=$'\033[1;31m'
    COL_GREEN=$'\033[1;32m'
    COL_BLUE=$'\033[1;34m'
    COL_YELLOW=$'\033[1;33m'
    COL_DIM=$'\033[2m'
else
    COL_RESET='' COL_RED='' COL_GREEN='' COL_BLUE='' COL_YELLOW='' COL_DIM=''
fi

running() { printf '\n%s==>%s %s\n' "$COL_BLUE" "$COL_RESET" "$*"; }
ok()      { printf '%s[ok]%s %s\n' "$COL_GREEN" "$COL_RESET" "$*"; }
action()  { printf '%s[action]%s %s\n' "$COL_YELLOW" "$COL_RESET" "$*"; }
warn()    { printf '%s[warn]%s %s\n' "$COL_YELLOW" "$COL_RESET" "$*" >&2; }
error()   { printf '%s[error]%s %s\n' "$COL_RED" "$COL_RESET" "$*" >&2; }
die()     { error "$*"; exit 1; }

# Run a command, or only print it when DRY_RUN=1.
run() {
    if [[ "${DRY_RUN:-0}" == 1 ]]; then
        printf '%s[dry-run]%s %s\n' "$COL_DIM" "$COL_RESET" "$*"
    else
        "$@"
    fi
}

has() { command -v "$1" > /dev/null 2>&1; }


# Pretty-print a path with $HOME shortened to ~.
tildify() { printf '%s' "${1/#$HOME/~}"; }

# Symlink $2 -> $1, idempotently.
#  - Already pointing at $1: nothing to do.
#  - A symlink pointing elsewhere: replaced.
#  - A real file or directory: moved aside to $2.backup-<timestamp> first.
link() {
    local src=$1 dest=$2

    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        ok "$(tildify "$dest")"
        return
    fi

    [[ -d "$(dirname "$dest")" ]] || run mkdir -p "$(dirname "$dest")"

    if [[ -L "$dest" ]]; then
        action "$(tildify "$dest") was -> $(readlink "$dest"), relinking"
        run rm "$dest"
    elif [[ -e "$dest" ]]; then
        local backup
        backup="$dest.backup-$(date +%Y%m%d%H%M%S)"
        action "$(tildify "$dest") exists, moving it to $(tildify "$backup")"
        run mv "$dest" "$backup"
    fi

    run ln -s "$src" "$dest"
    ok "$(tildify "$dest") -> $(tildify "$src")"
}

# Print package names from list files, skipping blank lines and # comments.
read_pkgs() {
    local f
    for f in "$@"; do
        [[ -f "$f" ]] || continue
        sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^[[:space:]]*$/d' "$f"
    done
}
