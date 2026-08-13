---
description: Close out the session — sync docs, then commit and push
argument-hint: [optional commit message]
---

Before running anything, update these files in the current project to reflect this session's work:

1. **TODO.md** — check off completed items, add anything newly discovered, move stale items out.
2. **README.md** — update only if the setup/usage/behavior actually changed this session.
3. **AGENTS.md** — update only if working conventions changed (new commands, new constraints).

Then run, from the project's root directory:

```
bash ~/.agent-kit/scripts/the-end.sh "$ARGUMENTS"
```

If no argument was given, write a concise, specific commit message yourself (what changed and why) instead of relying on the script's default, and pass that instead. Report what was committed and whether the push succeeded.
