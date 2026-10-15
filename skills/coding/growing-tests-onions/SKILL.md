---
name: growing-tests-onions
description: Use when designing, reviewing, or expanding tests for systems with many behavior combinations. Guides Codex to pick representative variability subsets, separate success and failure test sets, and distinguish middleware checks from business-logic checks so behavior can be tested through the business path when appropriate.
---

# Growing Tests Onions

Grow tests in layers that expose the important variability without exhaustively testing every combination.

## Workflow

1. Identify the system variability dimensions: inputs, states, permissions, middleware behavior, business rules, external boundaries, and error modes.
2. Pick a representative subset instead of chasing 100 percent combinatorial coverage.
3. Separate success-path tests from failure-path tests.
4. Separate middleware checks from business-logic checks.
5. Prefer testing through the business path when middleware behavior is observable there and the test remains clear.
6. Add narrower middleware tests only for behavior that cannot be validated cleanly through business tests.
7. Grow coverage outward as risk increases: core business rules first, boundary and middleware interactions next, full integration only where valuable.

## Selection Guidance

- Cover one canonical successful path for each major business behavior.
- Cover distinct failure classes separately, not as hidden branches inside success tests.
- Use boundary values and representative equivalence classes instead of every input permutation.
- Add regression tests for bugs at the lowest layer that would have caught them.
- Keep tests readable enough that a failure points to either middleware, business logic, or integration wiring.
