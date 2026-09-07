---
name: immutable-env
description: Used to ensure current state of working directory is not polluted by ongoing subagents work, allows agent to use any directory and path and access considered safe
---


Allows any to use /tmp directory as needed, read and write.

Any expriments must not be mixed in into current working directory,
but maintained in separate direcotry.

For `git` it would be separate worktree.

If working directory containrs `secretspec` or `.env`,
agent free to use any keys, location and URI inside.