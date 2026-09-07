---
name: lazy-binding-evaluation
description: Use when evaluating whether references, identifiers, documentation links, tags, generated anchors, or cross-file bindings should be resolved late rather than hard-coded early, especially during refactors or code topology work.
---

# Lazy Binding Evaluation

Prefer bindings that survive refactors when exact targets may move.

## Guidance

- Use stable semantic references over brittle file-and-line references when durable links are needed.
- Consider tagref-style references for code notes that must remain valid across movement: <https://github.com/stepchowfun/tagref>.
- Resolve references late when early resolution would create stale links, duplicated identifiers, or unnecessary coupling.
- Check spelling and naming carefully because lazy binding depends on discoverable, consistent identifiers.
- Re-run searches after refactors to confirm references still resolve to the intended targets.
