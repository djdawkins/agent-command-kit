#!/usr/bin/env bash
# the-end.sh
# Git mechanics only: stage, commit, push.
# The agent is expected to have already updated AGENTS.md / TODO.md / README.md
# by hand (that part needs judgment, not a script) before calling this.
set -uo pipefail
# Note: not using -e here on purpose — several steps below need to inspect
# a command's exit code and print a specific, actionable message instead of
# just dying with git's raw output.

msg="${1:-session update: sync AGENTS.md, TODO.md, README.md}"

if [ ! -d .git ]; then
  echo "No git repo found. Run once-upon-a-time first." >&2
  exit 1
fi

# --- Pre-flight: git identity -------------------------------------------
# A fresh machine / fresh user often has no user.name or user.email set at
# all (global or local), which makes `git commit` fail outright. Catch it
# early with a clear fix instead of surfacing git's generic error.
if [ -z "$(git config user.name 2>/dev/null)" ] || [ -z "$(git config user.email 2>/dev/null)" ]; then
  cat >&2 << 'MSG_EOF'
Git identity isn't set, so a commit would fail.

Set it once for this machine:
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"

Then re-run this command.
MSG_EOF
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

if ! git commit -m "$msg"; then
  echo "git commit failed. See the error above." >&2
  exit 1
fi

# --- Push, with a friendlier message on auth failure ---------------------
if git remote get-url origin >/dev/null 2>&1; then
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  push_output="$(git push origin "$current_branch" 2>&1)"
  push_exit=$?

  if [ "$push_exit" -eq 0 ]; then
    echo "Pushed to origin/$current_branch."
  else
    echo "$push_output" >&2
    cat >&2 << 'MSG_EOF'

Commit succeeded locally, but the push failed — most likely GitHub auth
isn't set up on this machine yet. Run this to diagnose exactly what's
missing and get a specific fix:
  bash ~/.agent-kit/scripts/check-github-setup.sh

Your work is safely committed locally either way — re-run this command
(or just 'git push') once auth is sorted to send it up.
MSG_EOF
    exit 1
  fi
else
  echo "No 'origin' remote configured, skipping push."
  echo "Commit is saved locally. Add a remote with:"
  echo "  git remote add origin <url>"
fi
