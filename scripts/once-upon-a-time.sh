#!/usr/bin/env bash
# once-upon-a-time.sh
# Idempotent repo bootstrap: git init + AGENTS.md + TODO.md + README.md
# Shared by every coding-agent command wrapper (Claude Code / OpenCode / Codex).
set -euo pipefail

repo_name="$(basename "$(pwd)")"

# 1. git init (safe to re-run)
if [ ! -d .git ]; then
  git init
  echo "Initialized git repo."
else
  echo "git repo already exists, skipping init."
fi

# 2. AGENTS.md
if [ ! -f AGENTS.md ]; then
  cat > AGENTS.md <<EOF
# AGENTS.md

Conventions for any coding agent (Claude Code, OpenCode, Codex) working in this repo.

## Commands
- \`once upon a time\` — bootstrap the repo (this file, TODO.md, README.md, git init).
- \`the end\` — update AGENTS.md / TODO.md / README.md, then commit and push.

## Working agreements
- (fill in: language/framework, test command, lint command, deploy target)
- (fill in: branch naming, commit message style)

## Notes for agents
- Keep this file updated as conventions change; agents should read it before making assumptions.
EOF
  echo "Created AGENTS.md"
else
  echo "AGENTS.md already exists, leaving it alone."
fi

# 3. TODO.md
if [ ! -f TODO.md ]; then
  cat > TODO.md <<EOF
# TODO

## Now
- [ ] (first task)

## Next
- 

## Done
- 
EOF
  echo "Created TODO.md"
else
  echo "TODO.md already exists, leaving it alone."
fi

# 4. README.md
if [ ! -f README.md ]; then
  cat > README.md <<EOF
# ${repo_name}

(one-line description of what this project does)

## Setup
(fill in)

## Usage
(fill in)
EOF
  echo "Created README.md"
else
  echo "README.md already exists, leaving it alone."
fi

echo "Bootstrap complete."
