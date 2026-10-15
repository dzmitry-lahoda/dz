---
name: named-parameters-builders
description: Use when editing or reviewing call sites, constructors, config objects, APIs, or Rust functions with many positional parameters, repeated same-type parameters, optional parameters, flags, enum dispatch parameters, or partially-applied setup. Prefer explicit named inputs, typed-state builders, and intent-specific methods over ambiguous positional calls.
---

# Named Parameters and Builders

Use this skill when code passes meaning through parameter order instead of names.

## Goal

Make calls readable at the call site and make invalid construction harder.

Prefer, in order:
- intent-specific methods
- direct calls with clear arguments
- existing typed-state builders
- existing parameter structs
- explicit local variables with domain names
- positional parameters only for small, obvious calls

## Triggers

Apply when you see:
- three or more positional arguments
- adjacent arguments with the same primitive or domain type
- boolean flags
- many `None` or `Some(...)` arguments
- optional config mixed with required inputs
- enum parameters that only choose a behavior branch
- repeated call sites with similar setup

## Workflow

1. Read nearby constructors, call sites, tests, and existing builder/config patterns.
2. Prefer existing structs/builders before adding anything.
3. If the codebase uses typed-state builders, preserve required-field checking in the type system.
4. If a parameter only selects a dispatch branch, consider collapsing that selector out of the API shape. Prefer the existing direct branch call when available; do not add one helper per enum variant just to rename the enum.
5. Keep API churn local unless the ambiguous function is already a shared boundary.
6. Do not widen field visibility to make builder wiring easier.

## Rust Guidance

- Prefer `foo(AdminParams { ... })` over `foo(a, b, c, true)`.
- Prefer a direct call to the real operation over wrapping it in a helper solely to name parameters.
- Prefer an intent-specific method such as `execute_admin(action)` over
  `execute_kind(ActionKind::Admin(action))` when the outer enum variant only
  selects a dispatch branch.
- Prefer typed-state builders over large parameter structs when required fields are otherwise easy to omit.
- Prefer a parameter struct over a builder when all fields are required and construction is simple.
- Collapse enum selector parameters only when the variant maps to a real distinct operation or existing direct branch, not by generating wrapper methods for every enum variant.
- Use the `bon` crate only if it already fits the project, or when many optional fields make manual constructors noisy.
- Named locals are acceptable for narrow edits:
  - `let timeout = ...;`
  - `let retry_limit = ...;`
  - `connect(timeout, retry_limit)`

## Avoid

- New builders for one-off private calls.
- Builder setters that bypass validation.
- `Default::default()` hiding required domain choices.
- Boolean parameters when named methods or enums would carry intent better.
- Helper functions that only wrap a direct call with reordered or renamed parameters.
- One wrapper method per enum variant when the enum remains the real abstraction.
- Large API rewrites just to improve one call site.

## Do Not Apply

- Do not replace well-known conventional ordering from functional programming, Haskell, F#, algebra, or established domain APIs when the order is already idiomatic and unambiguous.
- Preserve conventional orders such as `map(f, xs)`, `fold(init, xs, f)` where local style uses it, `compose(f, g)`, `add(lhs, rhs)`, `mul(lhs, rhs)`, and algebraic operator-like functions.
- Do not force builders onto small combinators, closures, parser combinators, iterator adapters, or math functions where positional order is the notation.

## Review Checklist

Before finishing, check:
- call sites still show domain intent
- required fields cannot be silently skipped
- optional fields have clear defaults
- enum collapse removed selector noise instead of adding wrapper noise
- old selector-shaped calls, e.g. `execute_kind(ActionKind::Admin(...))`, no
  longer remain in the changed scope after introducing the intent-specific call
- tests cover at least one non-default construction path when behavior changes
