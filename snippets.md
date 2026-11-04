### Git snippets for unfamiliar codebases

```sh
# What changes the most?
git log --format=format: --name-only --since="1 year ago" | sort | uniq -c | sort -nr | head -20

# Who built this?
git shortlog -sn --no-merges


# Where are the bugs
git log -i -E --grep="fix|bug|broken" --name-only --format='' | sort | uniq -c | sort -nr | head -20

# Is the project dying?
git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c

# How often are there fires?
git log --oneline --since="1 year ago" | grep -iE 'revert|hotfix|emergency|rollback'
````
