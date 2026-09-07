---
name: conservative-weighted-code-reuse
description: Use when reviewing or editing pull/merge/patch requests for code reuse opportunities, especially duplicated or near-duplicated production code or reusable test infrastructure. Applies conservative DRY judgment: suggest extraction only when reuse is actionable, lowers total complexity, and preserves typed, named intent.
---

# Conservative Weighted Code Reuse

Use this skill to find code reuse opportunities without forcing abstraction.

## Design Principles

## Scope

Review production code and reusable test infrastructure such as invariants, assertions, builders, fixtures, and helpers.

Do not scan docs, examples, generated code, snapshots, or one-off test cases unless the user explicitly asks.

## Desired input 

Detailed codegraph primitives with static analysis of measure of similiary and distances amid duplication

## Workflow

1. Inspect the PR diff first, then nearby existing code that the diff resembles.
2. Identify exact or near duplication in logic.
3. Score reuse opportunities conservatively.
4. Suggest only extractions that are actionable and lower complexity after the change.
5. If applying a reuse change, report lines added and removed.

## Weight Higher

Prioritize reuse when duplication is:
- larger
- procedural or algorithmic
- higher repepeat count
- located close together
- likely to evolve together
- built from inputs with distinct domain types
- already similar to an existing helper, builder, method, or module pattern

## Weight Lower

Deweight or skip reuse when:
- the abstraction needs more code than it removes
- the duplicated code is clearer inline, for example in tests and examples
- the callers would pass many same-typed positional arguments
- names, fields, or builder setters would be replaced by unnamed parameters
- the extraction requires no-op hooks, empty/default returns, or dynamic/late binding dispatch just to share shape
- the abstraction would create a new struct for one narrow case
- the code is duplicated only because tests are documenting separate behavior
- inventing interfaces or traits without any default impl are very very deweighted


## Preferred Extractions

Prefer, in order:
- existing helper, builder, fixture, assertion, or method
- a small function or method with typed, named inputs
- a feature-owned helper near the duplicated code
- a shared test helper only when multiple tests express the same setup or assertion

Avoid closures when a named function or method would be clearer.

## Output

For reviews, return only actionable reuse suggestions. Each finding should include file and line references, the duplicated shape, and what helper, function, method, or abstraction should be extracted.

If there are no worthwhile reuse opportunities, say so directly.

## Parameters reuse

If method/function has 3 or more parameters, 
and there is struct which has similar named fields and same type paramters,
consider suggesting to replace parameters with struct.