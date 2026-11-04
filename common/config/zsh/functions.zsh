# Shell functions.

autoload -Uz add-zsh-hook

# Git
###############################################################################

# If `git checkout <branch>` / `git switch <branch>` targets a branch that is
# already checked out in another worktree, cd there instead of erroring.
git() {
  if [[ ( "$1" == checkout || "$1" == switch ) && $# -eq 2 && "$2" != -* ]]; then
    local wt
    wt=$(command git worktree list --porcelain 2>/dev/null | awk -v ref="refs/heads/$2" '
      /^worktree / { path = substr($0, 10) }
      $0 == "branch " ref { print path; exit }')
    if [[ -n "$wt" && "$wt" != "$(command git rev-parse --show-toplevel 2>/dev/null)" ]]; then
      echo "'$2' is checked out in $wt; changing directory"
      cd "$wt"
      return
    fi
  fi
  command git "$@"
}

# Show git branch info with description.
branch-info() {
    active=" "

    for branch in $(git branch); do
        if [[ "$branch" == "*" ]]; then
            active="*"
            continue
        fi

        # `+` marks a branch checked out in another worktree.
        if [[ "$branch" == "+" ]]; then
            continue
        fi

        description=$(git config "branch.$branch.description")

        printf '%s \e[33m%s\e[0m\t%s\n' "$active" "$branch" "$description"

        if [[ "$active" == "*" ]]; then
            active=" "
        fi
    done
}

# Delete local branches whose commits are all already in BASE.
cleanup() {
    BASE=$1
    BRANCHES=$(git for-each-ref refs/heads --format="%(refname:short)" | grep -vE "(develop|master|rc-v\d+\.\d+\.\d+)")

    while IFS= read -r branch; do
        if ! git cherry "$BASE" "$branch" | grep -q "^+"; then
            git branch -D "$branch"
        fi
    done < <(echo "$BRANCHES")
}

# Terminal and kitty
###############################################################################

# Warn once if stderr stops pointing at the terminal (e.g. a sourced `exec 2>`)
_stderr_watch() {
  if [[ ! -t 2 && -z $_stderr_warned ]]; then
    _stderr_warned=1
    local target=$(lsof -a -p $$ -d 2 -Fn 2>/dev/null | sed -n 's/^n//p')
    print -u1 "⚠ stderr redirected to '$target' after: $(fc -ln -1)"
  fi
}

add-zsh-hook precmd _stderr_watch

# Cycle through kitty color schemes every second, starting at index NUM.
colorscheme() {
    NUM=$1

    SCHEMES=($(ls -1 "$HOME/.config/kitty/themes/themes"))

    while true
    do
        # zsh arrays are 1-indexed.
        SCHEME="${SCHEMES[$((NUM % ${#SCHEMES[@]} + 1))]}"
        kitty @ set-colors --all --configured "$HOME/.config/kitty/themes/themes/$SCHEME"
        echo "Colorscheme set to $SCHEME. ($NUM)"
        NUM=$((NUM + 1))
        sleep 1
    done
}

# Clear displayed images.
iclear() {
    SLEEP=${1:-0}
    sleep "$SLEEP"
    kitty +kitten icat --clear
}

# Display an image inline in the terminal.
icat() {
    kitty +kitten icat --align left "$1"
}

# Show the current Spotify track with its album art.
spinfo() {
    ALBUM_ART=$(playerctl metadata mpris:artUrl | sed 's/open.spotify.com/i.scdn.co/')
    ARTIST=$(playerctl metadata xesam:artist)
    ALBUM=$(playerctl metadata xesam:album)
    TITLE=$(playerctl metadata xesam:title)
    icat "$ALBUM_ART"
    echo "$TITLE"
    echo "$ALBUM"
    echo "$ARTIST"
}

# Weather
###############################################################################

# Display the weather. Optionally, provide a location argument.
weather() {
  curl "wttr.in/$1"
}

# Display more detailed wind and cloud weather for a location.
meteogram() {
  finger "$1@graph.no"
}
