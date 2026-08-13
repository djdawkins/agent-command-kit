#!/usr/bin/env bash
# install.sh — installs agent-command-kit globally.
# Run once per machine. Not per project — the commands work in every
# project afterward since they're installed to home-directory locations.
set -euo pipefail

KIT_REPO="https://github.com/djdawkins/agent-command-kit.git"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Fetching agent-command-kit..."
git clone --depth 1 "$KIT_REPO" "$TMP_DIR" >/dev/null 2>&1

# 1. Scripts — the actual git-mechanics logic, installed once, invoked by
#    absolute path from whatever project you're in.
SCRIPTS_DEST="$HOME/.agent-kit/scripts"
mkdir -p "$SCRIPTS_DEST"
cp "$TMP_DIR/scripts/"*.sh "$SCRIPTS_DEST/"
chmod +x "$SCRIPTS_DEST/"*.sh
echo "Installed scripts to $SCRIPTS_DEST"

# 2. Claude Code — global commands
mkdir -p "$HOME/.claude/commands"
cp "$TMP_DIR/commands/"*.md "$HOME/.claude/commands/"
echo "Installed Claude Code commands to $HOME/.claude/commands"

# 3. OpenCode — global commands
mkdir -p "$HOME/.config/opencode/command"
cp "$TMP_DIR/commands/"*.md "$HOME/.config/opencode/command/"
echo "Installed OpenCode commands to $HOME/.config/opencode/command"

# 4. Codex — global prompts
CODEX_PROMPTS_DIR="${CODEX_HOME:-$HOME/.codex}/prompts"
mkdir -p "$CODEX_PROMPTS_DIR"
cp "$TMP_DIR/commands/"*.md "$CODEX_PROMPTS_DIR/"
echo "Installed Codex prompts to $CODEX_PROMPTS_DIR"

echo ""
echo "Done. once-upon-a-time and the-end are now available in every project."
echo "Restart Claude Code, OpenCode, and Codex (or start new sessions) to pick them up."
