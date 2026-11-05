#!/usr/bin/env bash
#
# Install and keep dotfiles in sync across macOS, Arch and Ubuntu.
#
# The repo is split into layers. Each system applies `common` plus the layers
# for its platform, in order:
#
#   macOS   common -> macos
#   Arch    common -> linux -> arch
#   Ubuntu  common -> linux -> ubuntu
#
# Inside a layer (every part is optional):
#
#   config/<name>    linked to ~/.config/<name>
#   home/<name>      linked to ~/<name>
#   pkg.txt          packages (brew / pacman+AUR via yay / apt)
#   pkg-work.txt     extra packages, installed with --work
#   setup.sh         one-off system tweaks, run by `setup`
#
# Must stay compatible with bash 3.2, the macOS default.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$DOTFILES_DIR/lib.sh"

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DRY_RUN=0
WORK=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [options] [command...]

Commands:
  install    Packages, links and system setup. Use on a new machine.
  update     Pull the latest changes, then relink and prune stale links.
  link       Symlink configs for this system (the default).
  packages   Install missing packages from the pkg.txt lists.
  setup      Run per-layer setup.sh scripts and make zsh the login shell.
  prune      Remove dangling symlinks that point into this repo.
  status     Show the detected system, its layers and their links.

Options:
  -n, --dry-run   Print what would change without changing anything.
  -w, --work      Also install packages from pkg-work.txt lists.
  -h, --help      Show this help.

The OS is detected automatically. Override it with DOTFILES_OS=macos|arch|ubuntu.
EOF
}

# Detection
###############################################################################

detect_os() {
    if [[ -n "${DOTFILES_OS:-}" ]]; then
        echo "$DOTFILES_OS"
        return
    fi

    case "$(uname -s)" in
        Darwin) echo macos ;;
        Linux)
            local id='' id_like=''
            if [[ -r /etc/os-release ]]; then
                # shellcheck disable=SC1091
                id="$(. /etc/os-release && echo "${ID:-}")"
                # shellcheck disable=SC1091
                id_like="$(. /etc/os-release && echo "${ID_LIKE:-}")"
            fi
            case " $id $id_like " in
                *" arch "*) echo arch ;;
                *" ubuntu "* | *" debian "*) echo ubuntu ;;
                *) echo linux ;;
            esac
            ;;
        *) echo unknown ;;
    esac
}

layers_for() {
    case "$1" in
        macos)  echo "common macos" ;;
        arch)   echo "common linux arch" ;;
        ubuntu) echo "common linux ubuntu" ;;
        linux)  echo "common linux" ;;
        *)      echo "common" ;;
    esac
}

OS="$(detect_os)"
LAYERS="$(layers_for "$OS")"

# Links
###############################################################################

# Print every linkable file or directory in this system's layers.
layer_entries() {
    local layer
    # Include dotfiles in globs, and expand empty globs to nothing.
    shopt -s dotglob nullglob
    for layer in $LAYERS; do
        printf '%s\n' "$DOTFILES_DIR/$layer/"{config,home}/*
    done
    shopt -u dotglob nullglob
}

# Where a layer entry gets linked to.
dest_for() {
    local name
    name="$(basename "$1")"
    case "$(basename "$(dirname "$1")")" in
        config) echo "$CONFIG_HOME/$name" ;;
        home) echo "$HOME/$name" ;;
    esac
}

cmd_link() {
    running "Linking configs for $OS ($LAYERS)"

    local entry
    while IFS= read -r entry; do
        [[ -n "$entry" ]] && link "$entry" "$(dest_for "$entry")"
    done <<< "$(layer_entries)"
}

# Symlinks in ~ and ~/.config that point into the repo at something that no
# longer exists, e.g. after a config is renamed or moved to another layer.
dangling_links() {
    local dir l target
    for dir in "$HOME" "$CONFIG_HOME"; do
        for l in "$dir"/.* "$dir"/*; do
            [[ -L "$l" && ! -e "$l" ]] || continue
            target="$(readlink "$l")"
            [[ "$target" == "$DOTFILES_DIR/"* ]] && echo "$l"
        done
    done
}

cmd_prune() {
    running "Pruning dangling links into $(tildify "$DOTFILES_DIR")"
    local l found=0
    while IFS= read -r l; do
        [[ -n "$l" ]] || continue
        found=1
        action "Removing $(tildify "$l") -> $(readlink "$l")"
        run rm "$l"
    done <<< "$(dangling_links)"
    [[ $found == 1 ]] || ok "Nothing to prune."
}

# Packages
###############################################################################

pkg_lists() {
    local layer
    for layer in $LAYERS; do
        echo "$DOTFILES_DIR/$layer/pkg.txt"
        [[ $WORK == 1 ]] && echo "$DOTFILES_DIR/$layer/pkg-work.txt"
    done
    return 0
}

ensure_brew() {
    if ! has brew; then
        for prefix in /opt/homebrew /usr/local; do
            if [[ -x "$prefix/bin/brew" ]]; then
                eval "$("$prefix/bin/brew" shellenv)"
                return
            fi
        done
        action "Installing Homebrew"
        [[ $DRY_RUN == 1 ]] && return
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv 2> /dev/null || /usr/local/bin/brew shellenv)"
    fi
}

ensure_yay() {
    has yay && return
    action "Installing yay (AUR helper)"
    run sudo pacman -S --needed --noconfirm base-devel git
    [[ $DRY_RUN == 1 ]] && return
    local tmp
    tmp="$(mktemp -d)"
    git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
    (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"
}

# Print the packages from stdin that are not installed yet.
missing_pkgs() {
    local pkg
    case "$OS" in
        macos)
            if ! has brew; then cat; return; fi
            local installed
            installed="$(brew list -1 --formula; brew list -1 --cask)"
            while IFS= read -r pkg; do
                grep -qxF "${pkg##*/}" <<< "$installed" || echo "$pkg"
            done
            ;;
        arch)
            # `pacman -T` prints the ones that aren't satisfied.
            local all
            all="$(cat)"
            # shellcheck disable=SC2086
            [[ -n "$all" ]] && pacman -T $all || true
            ;;
        ubuntu)
            while IFS= read -r pkg; do
                dpkg-query -W -f='${Status}' "$pkg" 2> /dev/null \
                    | grep -q 'install ok installed' || echo "$pkg"
            done
            ;;
    esac
}

cmd_packages() {
    running "Installing packages for $OS"

    local lists=() f
    while IFS= read -r f; do
        [[ -f "$f" ]] && lists+=("$f")
    done <<< "$(pkg_lists)"

    if [[ ${#lists[@]} == 0 ]]; then
        warn "No package lists for $OS."
        return
    fi
    for f in "${lists[@]}"; do ok "Using $(tildify "$f")"; done

    case "$OS" in
        macos) ensure_brew ;;
        arch) ensure_yay ;;
        ubuntu) ;;
        *) warn "Don't know how to install packages on $OS."; return ;;
    esac

    local missing
    missing="$(read_pkgs "${lists[@]}" | sort -u | missing_pkgs)"
    if [[ -z "$missing" ]]; then
        ok "All packages are installed."
        return
    fi
    action "Missing: $(tr '\n' ' ' <<< "$missing")"

    local pkg failed=''
    case "$OS" in
        macos)
            # One at a time, so a renamed or removed package doesn't block the rest.
            for pkg in $missing; do
                run brew install "$pkg" || failed="$failed $pkg"
            done
            ;;
        arch)
            # shellcheck disable=SC2086
            run yay -S --needed $missing || failed="$missing"
            ;;
        ubuntu)
            run sudo apt-get update
            for pkg in $missing; do
                run sudo apt-get install -y "$pkg" || failed="$failed $pkg"
            done
            ;;
    esac

    if [[ -n "$failed" ]]; then
        warn "Failed to install:$failed"
    elif [[ $DRY_RUN == 0 ]]; then
        ok "Packages installed."
    fi
}

# Setup
###############################################################################

login_shell() {
    if [[ "$OS" == macos ]]; then
        dscl . -read "$HOME" UserShell 2> /dev/null | awk '{print $2}'
    elif has getent; then
        getent passwd "$(id -un)" | cut -d: -f7
    else
        echo "${SHELL:-}"
    fi
}

cmd_setup() {
    running "Running system setup for $OS"

    local layer script
    for layer in $LAYERS; do
        script="$DOTFILES_DIR/$layer/setup.sh"
        [[ -f "$script" ]] || continue
        action "Running $(tildify "$script")"
        if [[ -x "$script" ]]; then
            run "$script"
        else
            run bash "$script"
        fi
    done

    if has zsh; then
        local zsh
        zsh="$(command -v zsh)"
        if [[ "$(basename "$(login_shell)")" != zsh ]]; then
            action "Changing login shell to $zsh"
            if ! grep -qxF "$zsh" /etc/shells; then
                echo "$zsh" | run sudo tee -a /etc/shells > /dev/null
            fi
            run chsh -s "$zsh"
        else
            ok "Login shell is zsh."
        fi
    else
        warn "zsh isn't installed; run \`packages\` first."
    fi

}


# Update
###############################################################################

cmd_update() {
    running "Pulling latest dotfiles"
    if [[ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]]; then
        warn "Repo has local changes; pulling anyway (fast-forward only)."
    fi
    run git -C "$DOTFILES_DIR" pull --ff-only
    cmd_link
    cmd_prune
}

cmd_install() {
    cmd_packages
    cmd_link
    cmd_prune
    cmd_setup
}

# Status
###############################################################################

cmd_status() {
    echo "System:  $OS"
    echo "Layers:  $LAYERS"
    echo "Repo:    $(tildify "$DOTFILES_DIR")"
    echo "Shell:   $(login_shell)"

    local entry dest layer last=''
    while IFS= read -r entry; do
        [[ -n "$entry" ]] || continue
        layer="${entry#"$DOTFILES_DIR"/}"
        layer="${layer%%/*}"
        if [[ "$layer" != "$last" ]]; then
            running "$layer"
            last="$layer"
        fi
        dest="$(dest_for "$entry")"
        if [[ -L "$dest" && "$(readlink "$dest")" == "$entry" ]]; then
            ok "$(tildify "$dest")"
        elif [[ -e "$dest" || -L "$dest" ]]; then
            warn "$(tildify "$dest") exists but isn't linked to the repo"
        else
            error "$(tildify "$dest") not linked"
        fi
    done <<< "$(layer_entries)"

    local dangling
    dangling="$(dangling_links)"
    if [[ -n "$dangling" ]]; then
        running "Dangling links (fix with \`prune\`)"
        echo "$dangling"
    fi
}

# Main
###############################################################################

main() {
    local commands=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n | --dry-run) DRY_RUN=1 ;;
            -w | --work) WORK=1 ;;
            -h | --help) usage; exit 0 ;;
            install | update | link | packages | setup | prune | status)
                commands+=("$1") ;;
            *) usage >&2; die "Unknown argument: $1" ;;
        esac
        shift
    done
    [[ ${#commands[@]} -gt 0 ]] || commands=(link)

    [[ "$OS" != unknown ]] || die "Unsupported system: $(uname -s)"
    [[ $DRY_RUN == 0 ]] || action "Dry run: nothing will be changed."

    local cmd
    for cmd in "${commands[@]}"; do
        "cmd_$cmd"
    done
}

main "$@"
