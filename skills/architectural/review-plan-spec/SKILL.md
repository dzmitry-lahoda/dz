---
name: review-plan-spec
description: Review a specification or plan by running implementation planning and branching at underspecified decisions instead of silently assuming defaults.
---

# Review plan and spec via decision forking

Substantial logic—especially multi-step, path-dependent state machines—cannot be generated or patched reliably from an incomplete plan; post-hoc fixes to a broken state machine degrade into hacks.

## Procedure

1. Start implementation planning (`plancode`) from the spec or plan. Do not write production code or silently guess missing rules.
2. At each ambiguous design or state-transition decision, split into the 2–3 dominant solution forks covering the main solution space.
3. Expand forks up to depth 2, capped at 10 total forks.
4. At every fork, record what the spec/plan lacks (missing invariants, undefined transitions, path dependencies, or boundary cases).
5. Stop before code generation and report the fork tree and all unresolved gaps.
