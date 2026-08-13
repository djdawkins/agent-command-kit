# agent-command-kit

Two slash commands — `once upon a time` and `the end` — for Claude Code,
OpenCode, and Codex, installed **globally** so they're available in every
project on a machine, with no per-project setup.

- **`once upon a time`** — bootstraps a repo: `git init` (if needed) plus
  starter `AGENTS.md`, `TODO.md`, and `README.md`.
- **`the end`** — updates `AGENTS.md` / `TODO.md` / `README.md` to reflect
  the session, then commits and pushes.
- **`check github setup`** — diagnoses whether git/GitHub is ready for
  commit + push on this machine (git installed, identity set, remote
  configured, push auth working) and prints the specific fix for whichever
  check fails first.

## Install (once per machine)

**macOS / Linux / Git Bash / WSL:**
```
curl -sL https://raw.githubusercontent.com/djdawkins/agent-command-kit/main/install.sh | bash
```

**Native PowerShell:**
```
irm https://raw.githubusercontent.com/djdawkins/agent-command-kit/main/install.ps1 | iex
```

That's it — no per-project install. Both commands are now available in
every project, in Claude Code, OpenCode, and Codex. Restart each tool (or
start a new session) so it picks up the new commands.

Re-run the same install command any time to pull updates — it overwrites
the previous global install.

## Where things land

| Tool | Commands location |
|---|---|
| Claude Code | `~/.claude/commands/` |
| OpenCode | `~/.config/opencode/command/` |
| Codex | `~/.codex/prompts/` (or `$CODEX_HOME/prompts`) |
| Shared scripts | `~/.agent-kit/scripts/` |

All three tools' command files are identical in content — they just tell
the agent to run the shared script at `~/.agent-kit/scripts/*.sh`, from
whatever project you're currently in.

## Repo layout

```
agent-command-kit/
├── DESIGN.md          # why it's built this way
├── AGENT-COMMANDS-SETUP.md  # detailed install / update notes
├── install.sh          # installer: mac / Linux / Git Bash / WSL
├── install.ps1         # installer: native PowerShell
├── scripts/
│   ├── once-upon-a-time.sh    # git init + AGENTS.md/TODO.md/README.md
│   ├── the-end.sh             # git add, commit, push
│   └── check-github-setup.sh  # diagnose git/GitHub setup, no side effects
└── commands/                  # source wrapper prompts, copied to all three tools
    ├── once-upon-a-time.md
    ├── the-end.md
    └── check-github-setup.md
```

## Requirements

- `git`, `bash`, and `curl` (or PowerShell + `git` on Windows)
- The coding agent's shell tool must be able to reach `bash` at runtime to
  actually *run* `~/.agent-kit/scripts/*.sh` — Git Bash on PATH or WSL on
  Windows, native on macOS/Linux.

## Docs

- [AGENT-COMMANDS-SETUP.md](./AGENT-COMMANDS-SETUP.md) — install and update walkthrough, Codex caveat in detail
- [DESIGN.md](./DESIGN.md) — rationale behind the script/prompt split and going global
