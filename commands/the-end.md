---
description: Close out the session — sync docs, then commit and push
argument-hint: [optional commit message]
---

Before running anything, update these files,if necessary, in the current project to reflect this session's work:

1. **TODO.md**
2. **README.md**
3. **AGENTS.md** 

Then run, from the project's root directory:

```
bash ~/.agent-kit/scripts/the-end.sh "$ARGUMENTS"
```

If no argument was given, write a bullet point capturing the high level changes and pass that instead. 
Report what was committed and whether the push succeeded.
