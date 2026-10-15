---
name: allow-all-readonly
description: Use when Codex needs permission guidance for local code work in this repository. Allows read-only, search, inspection, and immutable commands without asking when they stay inside the repository and do not access ignored files or private external state.
---

# Allow All Read-Only

Treat read-only repository inspection as pre-approved.

## Guidance

- Run local read-only commands such as `rg`, `find`, `cat`, `sed`, `git status`, and non-mutating `git log` without asking first.
- Keep reads inside the current repository unless the user explicitly points elsewhere.
- Do not read ignored, secret, or private external files unless the user explicitly asks.
- Ask before running commands that write files, install packages, change global state, contact external services, or mutate version control state.
- Prefer gathering enough context before making implementation decisions.
