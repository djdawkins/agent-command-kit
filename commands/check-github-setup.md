---
description: Diagnose whether git/GitHub is set up correctly for commit + push
---

Run this shell script from the current project's root directory:

```
bash ~/.agent-kit/scripts/check-github-setup.sh
```

It checks git installation, git identity, the `origin` remote, and push authentication, in that order, stopping at the first failure with a specific fix. Report the result plainly — if it passed, say so briefly; if it failed a check, show me exactly the fix it printed rather than paraphrasing it, since the commands need to be run verbatim.
