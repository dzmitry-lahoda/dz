---
name: code-topology-representation
description: Use when editing, reviewing, refactoring, or auditing code where dependency structure, control flow, data flow, ownership, module topology, call graphs, or AST-level relationships affect correctness or maintainability.
---

# Code Topology Representation

Build a code topology model before changing behavior that depends on structure.

## Workflow

1. Extract the relevant dependency, control-flow, data-flow, graph, or AST relationships before editing.
2. Identify callers, callees, module boundaries, ownership boundaries, and durable references affected by the change.
3. Keep graph references coherent when moving code. Update references, imports, documentation links, and tests together.
4. Prefer stable references for durable notes, using tagref-style identifiers when the codebase already supports them.
5. Re-check the topology after edits to catch broken references, orphaned helpers, and accidental dependency direction changes.

## Avoid

- Editing a structurally connected area after reading only the target function.
- Moving code without preserving callers, comments, doc comments, and module visibility.
- Creating cycles or broad shared modules when a feature-owned module is clearer.
