---
name: plan-apply-minimal-surface
description: Use when planning or implementing a code change where the safest path is to keep the edit surface small, pass only relevant context to patching or apply steps, and avoid unrelated refactors.
---

# Plan Apply Minimal Surface

Plan and apply the smallest coherent change that satisfies the request.

## Workflow

1. Identify the requested behavior and the files directly responsible for it.
2. Gather only the context needed to edit those files safely.
3. Keep the patch focused on the requested behavior.
4. Avoid broad cleanup, formatting churn, dependency changes, or unrelated API reshaping.
5. When applying a patch, include only relevant hunks and preserve surrounding user edits.
6. Verify the touched behavior with the narrowest meaningful checks.

## Ask First

Ask for clarification when the request is broad enough that multiple incompatible minimal surfaces are plausible.
