# Agent command kit — install notes

## One install per machine, not per project

Unlike the earlier project-scoped version of this kit, everything now
installs to home-directory locations, so `once upon a time` and `the end`
work in every project automatically once installed:

```
scripts       → ~/.agent-kit/scripts/
Claude Code   → ~/.claude/commands/
OpenCode      → ~/.config/opencode/command/
Codex         → ~/.codex/prompts/  (or $CODEX_HOME/prompts)
```

Run the installer once, on each machine you use these tools from. Cloning
or working in a new project needs no setup — the commands are already
there.

## Updating

Re-run the same install command:

```
curl -sL https://raw.githubusercontent.com/djdawkins/agent-command-kit/main/install.sh | bash
```

or on Windows:

```
irm https://raw.githubusercontent.com/djdawkins/agent-command-kit/main/install.ps1 | iex
```

It overwrites the previous global install with the latest version.

## Codex specifics

Codex has always read custom prompts from a home-directory location only
(`~/.codex/prompts` or `$CODEX_HOME/prompts`) — it never supported a
repo-scoped equivalent. This is actually the pattern the whole kit is now
built around, so Codex needed no special-casing this time; Claude Code and
OpenCode just adopted the same global model Codex already used.

## Multiple machines

The installer needs to be re-run on each machine separately (your Mac, the
ODS Windows box, etc.) — a global, home-directory install on one machine
doesn't propagate to another. Same install command works on both; pick
`install.sh` or `install.ps1` to match the shell.

## Why it's structured this way

See [DESIGN.md](./DESIGN.md) for the full rationale.
