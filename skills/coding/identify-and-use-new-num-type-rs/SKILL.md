---
name: identify-and-use-new-num-type-rs
description: Use when editing or reviewing Rust code that passes, stores, parses, computes, validates, serializes, or displays numeric values with domain meaning, especially IDs, counts, indexes, offsets, sizes, prices, quantities, percentages, timestamps, durations, limits, balances, quotes, fees, basis points, risk numbers, and funding indexes. Guides Codex to identify and reuse existing numeric newtypes, avoid raw primitives and type aliases where they hide invariants, and propose new numeric newtypes only when reuse, arithmetic composition, or durable boundaries justify them.
---

# Identify and Use New Numeric Types in Rust

Use this skill before editing or reviewing Rust code that introduces, changes, or reasons about numeric values with domain meaning.

## Goal

Prefer domain-specific numeric newtypes over raw primitives or type aliases when a number carries meaning beyond local arithmetic.

Examples:
- `UserId` instead of `u64`
- `ByteOffset` instead of `usize`
- `TokenCount` instead of `u32`
- `PriceCents` instead of `i64`
- `TimeoutMs` instead of `u64`
- `BasisPoints` instead of `u32`

Newtypes are the practical local replacement for missing or weak Rust support around custom numeric ranges, units, refinement types, and foreign trait extension.

## Why

Use numeric newtypes because:
- many useful Rust features remain unstable for domain numeric modeling
- `TryFrom`, `Add`, and related traits are awkward or incomplete across `NonZero`, 64-bit, and 128-bit numeric combinations
- Rust prevents extending another crate's types with another crate's traits
- core primitive-extension crates can lag, for example [rust-num/num-traits PR 346](https://github.com/rust-num/num-traits/pull/346)
- Rust lacks decent safe custom-range numbers, including [arbitrary-int issue 53](https://github.com/danlehmann/arbitrary-int/issues/53) and [arbitrary-int issue 37](https://github.com/danlehmann/arbitrary-int/issues/37)
- Rust lacks a maintained and composable generic multibase unit-of-measure stack, see [uom PR 529](https://github.com/iliekturtles/uom/pull/529) and [uom.rs notes](https://yoric.github.io/post/uom.rs/)
- type aliases cannot enforce custom or arbitrary ranges
- `rust_decimal` may be too slow for hot numeric paths, including multiplication loops
- `u64 * u64` can require a `u128` result, for example price times size producing quote value
- storage compatibility is not automatic, for example PostgreSQL supports signed 64-bit integers but not unsigned 64-bit integers

This is a poor man's approximation of [refinement types](https://blog.yoshuawuyts.com/a-grand-vision-for-rust/). Applied consistently, newtypes replace bindings and type aliases, reduce repeated boilerplate over time, and make invalid numeric composition harder.

## Workflow

1. Read all relevant `*.md` instructions first, then read the relevant Rust module and nearby Rust files before editing.
2. Build enough dependency, control-flow, data-flow, graph, or AST context before changing types. Keep code graph references coherent; use [tagref](https://github.com/stepchowfun/tagref)-style stable references when durable references are useful.
3. Search for existing numeric newtypes before using a primitive:
   - `rg 'struct .*\(((u|i)[0-9]+|usize|isize|f32|f64|NonZero)'`
   - `rg 'type .* = ((u|i)[0-9]+|usize|isize|f32|f64)'`
   - `rg '(Id|Count|Index|Offset|Size|Len|Amount|Price|Qty|Quantity|Percent|Ratio|Time|Duration|Limit|Height|Width|Depth|Weight|Score|Nonce|Epoch|Slot|Block|Version|Balance|Quote|Fee|Basis|Risk|Funding)'`
4. Prefer existing newtypes over type aliases and primitives.
5. Trace constructors, conversion methods, validation methods, arithmetic impls, serialization impls, display/view usage, host/state boundaries, and database mappings before using or proposing a type.
6. Preserve validation boundaries. Construct newtypes where raw input enters the system, not deep inside business logic unless existing code does so.
7. Avoid widening visibility to reach a private field or constructor. Use existing public constructors and accessors.
8. If no suitable type exists, propose a new numeric newtype only when the criteria below are satisfied and the task permits new type definitions.

## When to Add a New Numeric Newtype

Create or propose a new numeric newtype when the value is:
- reused in several areas, modules, features, or API surfaces
- composed arithmetically with other domain numbers
- sent to view, host, state, storage, wire format, or another durable boundary
- a distinct unit or scale, such as balance scale, market-size quantity scale, quote scale, basis points, parts-per-million, risk number, or funding index
- an ID that should be range-limited, for example to `u31` or `u63`; consider `deranged` where the codebase already uses or accepts it, as in the Javier-style approach
- a `NonZero` value, because wrapping `NonZero` is often cheaper than repeatedly handling its missing math and public trait support

Do not create a new numeric newtype when those criteria are not satisfied enough, especially for short-lived local calculations.

When adding one, describe its unit clearly, especially for 128-bit values.

## Selection Rules

Use a newtype when the number has:
- a unit: bytes, milliseconds, cents, tokens, blocks
- an identity role: user ID, order ID, account ID
- a bounded invariant: positive count, nonzero limit, normalized percent
- an indexing role: cursor, offset, row index, slot
- cross-module meaning that can be accidentally swapped with another number
- storage or wire compatibility constraints
- arithmetic composition where the result type matters, such as size times price equals quote

Keep a primitive when the number is:
- purely local loop arithmetic
- an implementation detail inside a validated newtype
- generic math with no domain meaning
- required by a trait or external API boundary

## Financial Values

For financial values, identify these axes before choosing or adding a type:
- sign: positive-only, negative-only, or signed/sided
- zeroability: zeroable at rest versus nonzero deltas or receipts
- linearity: must be used once, such as a fee taken from an account and applied to the system, versus reusable accounting values
- unit and scale: balance, market size, quote, fee, basis points, parts-per-million, risk number, funding index

For example, `balance` could theoretically split across sign, zeroability, and linearity, but the real type count should be smaller and justified by usage.

Do not assume `fee = balance` unless the domain already establishes that equivalence. Fee, balance, size, quote, and risk values can have different units, invariants, and composition rules.

## Rust Implementation Guidance

- Do not create `type Foo = u64` when a domain type needs protection. Use or propose a tuple-struct newtype.
- Use existing newtypes instead of type bindings when available.
- Respect existing arithmetic style: checked, saturating, wrapping, or panic-on-overflow.
- Prefer `TryFrom` or named constructors for validated values.
- Prefer explicit conversions at boundaries over repeated `.0` field access.
- Preserve derives and impls consistent with nearby newtypes: `Copy`, `Clone`, `Eq`, `Ord`, `Hash`, `Debug`, `Display`, `From`, `TryFrom`, serde, database traits.
- Use `derive_more` as needed when it matches local style and shortens repetitive impls.
- Consider a macro only for repeated, stable patterns such as new ID types. A `newid` macro can be simple and common across languages; generic newnum macros need more care because numeric invariants and units vary by domain.
- If the codebase references ticket `#2262`, preserve that context: it was previously closed as not planned, but may be worth reopening if repeated newtype boilerplate makes the macro case concrete.
- Do not add public fields, public constructors, or broad `From` impls if they bypass invariants.
- Do not introduce a new numeric type if an existing one already carries the same invariant and domain meaning.

## Review Checklist

Before finishing, check:
- raw numeric parameters and fields introduced by the change
- numeric literals that should be constructors or named constants
- places where two primitives with different meanings can be swapped
- parsing and deserialization paths that should validate once at the boundary
- serialization, API, database, view, host, and state boundaries that must keep representation stable
- 64-bit multiplication or accumulation that may require 128-bit result types
- `NonZero` usage that would be simpler and safer as a newtype
- whether `deranged` is appropriate for ID ranges such as `u31` or `u63`
- whether repeated newtype boilerplate makes a macro worth revisiting
- whether spelling or naming obscures the unit, scale, or invariant
- tests that should assert invalid numeric values are rejected

## Output Expectations

When reporting the change or review, mention:
- which existing newtypes were reused
- where raw primitives remain and why
- any missing newtype you recommend but did not add
- whether current usage satisfies the criteria for new numeric type usefulness
- validation commands run, especially `cargo check`, `cargo check --tests`, or `cargo test`
