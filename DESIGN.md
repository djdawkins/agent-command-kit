# DESIGN.md

Why the kit is structured the way it is.

## Logic lives in scripts, not in prompt text

Git mechanics — init, add, commit, push — are deterministic. There's no
reason to let three different LLMs (Claude, an OpenCode-configured model,
Codex) each improvise their own git incantations and risk drift between
them. `scripts/*.sh` is the single source of truth for *behavior*. The
`.md` command files copied into each tool's commands folder are thin
wrappers that just tell the agent to run the script.

One consequence: if you ever want to change what `once-upon-a-time` or
`the-end` actually *does*, you edit one `.sh` file, re-run the installer,
and every tool's command updates in lockstep — no hunting through
per-tool copies trying to keep them in sync.

## The prompt wrappers only handle the judgment calls

The parts that genuinely need a model — writing a specific, honest commit
message; deciding what to check off in TODO.md; filling in placeholder
text in a freshly created README.md — stay in the `.md` wrapper prompts,
because that's the one part a shell script can't do well. Script for
mechanics, prompt for judgment.

## Why a diagnostic script instead of an MCP server

`check-github-setup.sh` exists because `the-end.sh`'s push step has four
distinct failure modes (git missing, identity unset, no remote, auth not
configured), and surfacing git's raw error for any of them is a poor
experience on a fresh machine. An MCP server was considered and rejected:
MCP would give the agent GitHub *API* access (issues, PRs, CI status) —
useful for other things, but irrelevant here, since `git push` auth is a
local SSH/HTTPS credential problem that has nothing to do with the GitHub
API. The script checks each gate in order and stops at the first failure
with one concrete fix, rather than dumping every possible problem at once.
It never modifies anything — diagnosis only, so it's safe to run anytime,
including as the first thing on a brand new machine before ever running
`once-upon-a-time`.

## Why global instead of project-scoped

The kit originally installed `scripts/` and the command wrappers *inside*
each project repo, so the commands travelled with the repo and a
collaborator got them just by cloning it. That had a real cost: every new
project needed the installer run again before the commands worked there.

Codex never supported that project-scoped model in the first place — it
only ever read prompts from a home-directory location. Rather than keep
two different install shapes (project-scoped for two tools, global for
one), the kit now follows Codex's original pattern everywhere: install
once per machine, available in every project from then on. The tradeoff is
explicit — a fresh clone of some other project won't have these commands
unless the kit has separately been installed on that machine, but in
exchange there's no per-project setup step at all, which matches how these
commands are actually used (personal workflow shortcuts, not something a
collaborator needs to inherit via git).

If a future need comes up for the commands to travel with a specific
repo (e.g. handing a project to someone else who doesn't have the kit
installed), the project-scoped approach is still valid — it would just be
reintroduced as an option (see git history / earlier version of this
kit), not the default.

## Scripts referenced by absolute path

Since the scripts no longer live inside the project being worked on, the
wrapper prompts call them by a fixed absolute path
(`~/.agent-kit/scripts/*.sh`) rather than a path relative to the repo. The
scripts themselves still operate on the *current working directory* (`pwd`)
for all git operations — only their own location is fixed, not the
project they act on.

## Install script over git submodule

A submodule would keep tighter git-level coupling between a project and
this kit, but submodules are a well-known source of confusion (forgetting
`--init`, detached-HEAD surprises, extra ceremony for collaborators). This
kit is small and changes rarely, so a plain copy-based installer
(`curl | bash` / `irm | iex`) that you re-run to pick up updates is less
friction for the actual use case: install once, forget about it.

## Two installers, same shape, on purpose

`install.sh` and `install.ps1` intentionally mirror each other step for
step (clone to temp dir → copy scripts to `~/.agent-kit` → copy command
wrappers to each tool's global folder → clean up temp dir). Neither tries
to be clever or to detect the other's environment — you just run whichever
matches your shell (Git Bash / WSL / macOS / Linux → `install.sh`; native
PowerShell → `install.ps1`).

Only the *installer* needed a PowerShell version. The scripts it installs
(`scripts/*.sh`) stay bash — they're invoked by the coding agent's own
shell tool at runtime, not by a person, so as long as that environment can
reach `bash` (Git Bash on PATH, WSL, or macOS/Linux natively) no `.ps1`
twin of the scripts themselves is needed. If an environment only has
native PowerShell with no bash available at all, that's the point where
`once-upon-a-time.ps1` / `the-end.ps1` script twins — not just installer
twins — would become necessary.
