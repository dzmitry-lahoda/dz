---
name: spec-deep-review
description: Conduct a rigorous, multi-dimensional technical specification review covering logical contradictions, edge cases, system invariants, mathematical verification, and multi-persona critiques (Novice, Domain Expert, and 3rd-Party Integrator). Use whenever the user asks to review, audit, stress-test, or find flaws in a specification, architecture design, protocol, RFC, or legal/technical document.
---
# Spec Deep Review

Perform an exhaustive, adversarial, and structural audit of technical specifications, protocols, architectures, or formal rulesets across seven distinct analytical lenses.

## When to Use

- The user provides a specification, RFC, protocol design, architecture doc, or formal ruleset and asks for a review, audit, or stress-test.
- The user asks to find contradictions, edge cases, broken invariants, or math flaws in a design.
- The user wants multi-perspective feedback (e.g., Novice, Expert, or 3rd-Party view) on a document.

## Core Workflow

When reviewing a specification, systematically execute the following seven analytical passes. Do not summarize or gloss over details; cite exact sections, variables, or claims from the source text.

### 1. Logical Contradictions & Ambiguities

- Cross-reference all definitions, state transitions, constraints, and requirements across the entire document.
- Identify direct contradictions (e.g., Section A permits state X while Section B forbids it, or timeout T1 is smaller than retry interval R1).
- Flag semantic drift (where the same term is used to mean two different things, or two terms refer to the same entity).
- Pinpoint underspecified behaviors (e.g., "must be handled gracefully" without defining the fallback state or error code).

### 2. Systems Invariant Search

- Explicitly extract both stated and unstated **system invariants** (properties that must hold true before, during, and after every valid state transition, such as conservation of value, monotonicity of nonces, acyclic graph constraints, or lock ordering).
- Formulate each invariant precisely.
- Attempt to construct a counter-example or sequence of valid operations (including concurrent execution, partial failure, or message reordering) that violates each invariant.

### 3. Edge Cases & Boundary Conditions

- Test limits across all dimensions:
  - **Numerical/Data:** Zero, negative, `MAX_INT`, `NaN`, empty sets, single-element sets, Unicode/encoding boundaries, maximum payload size.
  - **Temporal/Ordering:** Clock skew, leap seconds, out-of-order delivery, duplicate delivery, zero-latency vs. infinite-latency (network partition), thundering herd on recovery.
  - **State/Lifecycle:** Initialization races, ungraceful shutdown mid-transaction, resource exhaustion (OOM, disk full, file descriptors), orphan states.

### 4. Mathematical & Quantitative Verification

- Audit all formulas, equations, bounds, complexity claims, and numerical examples.
- Check **dimensional analysis** and unit consistency (e.g., bits vs. bytes, milliseconds vs. seconds, rates vs. absolutes).
- Verify boundary behavior of formulas as variables approach $0$, $1$, or $\infty$.
- Re-calculate any worked examples in the spec to confirm arithmetic accuracy and check for floating-point precision loss, rounding bias, or integer overflow/underflow.

### 5. Novice Perspective (First-Principles Questions)

- Adopt the lens of an intelligent engineer who has zero prior context on this specific project or its tribal knowledge.
- Identify unstated assumptions, undefined acronyms, missing architectural context, and "magic numbers" introduced without justification.
- Formulate sharp, foundational questions that expose where the author skipped from Step A to Step D assuming the reader already knew Steps B and C.

### 6. 3rd-Party / Adversarial View (Integration & Game Theory)

- Adopt the lens of an external integrator, untrusted client, or rational adversary interacting with the system strictly through its defined boundaries.
- **Integration friction:** What is painful, brittle, or ambiguous when building a client, SDK, or webhook consumer against this spec? Are error states distinguishable and actionable?
- **Adversarial abuse:** How can a malicious or selfish actor exploit the spec while remaining technically compliant? Look for griefing vectors, asymmetric resource exhaustion (DoS), front-running, sybil amplification, or incentive misalignment.

### 7. Domain Expert Review (Architectural & Idiomatic Critique)

- Adopt the lens of a principal systems architect and domain specialist.
- Evaluate the fundamental design trade-offs (e.g., CAP/PACELC positioning, coupling, state growth over time, hardware/network sympathy, lock contention).
- Point out where the spec reinvents a standard mechanism poorly, hits known anti-patterns, or creates long-term operational/migration traps (e.g., lack of versioning, irreversible schema lock-in).

## Output Format

Present findings using high-dimensional, wide Markdown tables followed by targeted deep-dives for critical flaws.

### Master Defect & Risk Matrix

Always include a comprehensive summary table with these columns:
`| ID | Lens / Category | Severity (Crit/High/Med/Low) | Location / Ref | Core Issue & Violated Assumption | Concrete Counter-Example / Failure Scenario | Recommended Fix / Spec Wording |`

### Invariant & Math Ledger

Provide a dedicated table for invariants and mathematical checks:
`| Invariant / Formula | Formal Definition | Status (Holds / Broken / Conditional) | Breaking Condition / Precision Risk | Mitigation |`

### Persona Breakdown (Novice / 3rd-Party / Expert)

Group the specific questions, integration friction points, and architectural critiques clearly under their respective lenses so the author can address onboarding, external API boundaries, and core architecture independently.

## Gotchas

- Never give superficial praise or generic advice ("consider adding more tests"). Every critique must anchor to a specific mechanism, omission, or claim in the provided spec.
- If a spec contains no explicit math, apply the Mathematical lens to implicit quantitative bounds (timeouts, queue depths, throughput limits, big-O scaling).
- If the user asks to run only a subset of these lenses (e.g., "just do invariants and novice questions"), execute only the requested lenses in full depth.