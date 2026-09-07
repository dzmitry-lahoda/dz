---
name: sugar-fluent-concise
description: Use when editing or reviewing code with manual loops, recursion, boilerplate impls, hand-written schema glue, or verbose concrete helpers where language sugar, fluent combinators, derives, macros, or existing zero-cost libraries would express the same intent more clearly.
---

# Sugar, Fluent, Concise

Use this skill when code is correct but too manual.

## Goal

Prefer concise, composable, zero-cost language and library features over hand-written boilerplate.

## Apply

- Replace explicit loops or recursion with iterators, combinators, folds, maps, filters, or zips when clearer.
- Prefer derives, extension traits, macros, and metaprogramming for repeated schema-like impls.
- Prefer existing crates over inventing local helpers when the crate is already accepted or clearly justified.
- Prefer generic composable operations over concrete one-off named operations when runtime cost stays zero.
- Keep fluent chains readable; split only when names clarify domain intent.

## Rust Notes

Check `references/rs.md` for crates that may reduce boilerplate.

Good candidates include iterator-heavy code, enum/struct derives, assertion helpers, display/error formatting, tuple plumbing, static assertions, bounded numbers, and enum introspection.

## Avoid

- Clever chains that hide branching, errors, ownership, or performance.
- Closures with big bodies.
- New macros for one-off code.
- Extra dependencies for tiny local wins.
- Abstractions that make compile errors or inference much worse.
- Sugar that changes allocation, ordering, short-circuiting, or panic behavior.
- original code has usafe in impl

## Do Not Apply

- Code that uses `unsafe`; preserve explicit control flow and invariants there.
- Data structure implementations where explicit control flow documents invariants.
- Ad hoc bit encoding, packed fields, partial struct encoding/decoding, or complicated non-default wire formats.
- Hot-path optimizations where loops are shaped for bounds checks, allocation control, cache behavior, or early exits.
- Loops over data structures with many exits, mutations, cursor moves, or invariant checks.
