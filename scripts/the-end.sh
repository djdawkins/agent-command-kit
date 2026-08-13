#!/usr/bin/env bash
# the-end.sh
# Git mechanics only: stage, commit, push.
# The agent is expected to have already updated AGENTS.md / TODO.md / README.md
# by hand (that part needs judgment, not a script) before calling this.
set -euo pipefail

msg="${1:-session update: sync AGENTS.md, TODO.md, README.md}"

if [ ! -d .git ]; then
  echo "No git repo found. Run once-upon-a-time first." >&2
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

git commit -m "$msg"

# Push only if a remote exists
if git remote get-url origin >/dev/null 2>&1; then
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git push origin "$current_branch"
  echo "Pushed to origin/$current_branch."
else
  echo "No 'origin' remote configured, skipping push."
fi
