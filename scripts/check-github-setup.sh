#!/usr/bin/env bash
# check-github-setup.sh
# Diagnostic-only: walks the gates the-end.sh depends on (git installed,
# identity set, origin remote present, push auth works) and stops at the
# first failure with one specific fix. Never modifies anything.
set -uo pipefail

fail() {
  echo ""
  echo "✗ $1"
  echo ""
  echo "$2"
  echo ""
  exit 1
}

pass() {
  echo "✓ $1"
}

# --- Gate 1: git installed -----------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  fail "git is not installed" "Install it:
  macOS:   xcode-select --install   (or: brew install git)
  Linux:   sudo apt install git     (or your distro's package manager)
  Windows: https://git-scm.com/download/win"
fi
pass "git is installed ($(git --version))"

# --- Gate 2: git identity set --------------------------------------------
git_name="$(git config user.name 2>/dev/null || true)"
git_email="$(git config user.email 2>/dev/null || true)"
if [ -z "$git_name" ] || [ -z "$git_email" ]; then
  fail "git identity isn't set" "Set it once for this machine:
  git config --global user.name \"Your Name\"
  git config --global user.email \"you@example.com\""
fi
pass "git identity is set ($git_name <$git_email>)"

# --- Gate 3: inside a repo with an origin remote --------------------------
if [ ! -d .git ]; then
  fail "not inside a git repo" "Run once-upon-a-time first to initialize one,
or cd into an existing project before running this check."
fi
pass "inside a git repo"

if ! git remote get-url origin >/dev/null 2>&1; then
  fail "no 'origin' remote configured" "Add one:
  git remote add origin <url>

<url> is your repo's GitHub URL, e.g.:
  https://github.com/you/your-repo.git   (HTTPS)
  git@github.com:you/your-repo.git       (SSH)"
fi
origin_url="$(git remote get-url origin)"
pass "origin remote is set ($origin_url)"

# --- Gate 4: push auth actually works -------------------------------------
# git push --dry-run talks to the remote and authenticates, but doesn't
# push anything — safe to run even with uncommitted or no changes.
current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")"
push_check="$(git push --dry-run origin "$current_branch" 2>&1)"
push_check_exit=$?

if [ "$push_check_exit" -ne 0 ]; then
  echo "$push_check" >&2
  if [[ "$origin_url" == git@* ]]; then
    fail "push auth failed (SSH remote)" "Add an SSH key to your GitHub account, then test it:
  ssh -T git@github.com

If you don't have a key yet:
  ssh-keygen -t ed25519 -C \"you@example.com\"
  cat ~/.ssh/id_ed25519.pub
Then add that key at: https://github.com/settings/keys"
  else
    fail "push auth failed (HTTPS remote)" "Authenticate once with the GitHub CLI:
  gh auth login

Don't have gh installed? https://cli.github.com
Or use a Personal Access Token as the password next time git prompts you:
  https://github.com/settings/tokens"
  fi
fi
pass "push auth works"

echo ""
echo "All checks passed. the-end.sh can commit and push from this machine."
