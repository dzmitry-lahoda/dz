---
name: concentric-feature-dissector
description: Dissect monolithic features, specifications, and system designs into concentric architectural layers from inner pure functional core to outer side-effect shells and non-functional envelopes. Use when the user asks to break down, slice, decompose, or dissect a big feature, spec, or architecture without using sequential task-by-task checklists, or mentions inner-to-outer, core-to-side, functional-to-non-functional, algebraic, or layered feature decomposition.
---

# Concentric Feature Dissector

Decompose complex features into strictly ordered concentric layers ($L_0 \subset L_1 \subset L_2 \subset L_3 \subset L_4$) using Initial Algebra Semantics, Monadic Coeffect/Effect Stratification, and Parnas's "Uses" Hierarchy. Never output chronological task-by-task lists or Agile user stories; always slice specifications radially from the zero-dependency deterministic core outward to the impure operational boundary.

## When to Use

- The user wants to dissect a large feature, RFC, or system architecture into smaller implementable slices.
- The user rejects chronological "Step 1, Step 2" task breakdowns in favor of inner-to-outer, core-to-side, or functional-to-non-functional layering.
- Designing systems where pure state transitions must be strictly isolated from I/O, network sockets, storage engines, and non-functional quality envelopes.

## Formal Theoretical Foundations

1. **Initial Algebra to Final Coalgebra ($F\text{-Algebra} \to T\text{-Coalgebra}$):** Model the feature's heart as an algebraic data structure and pure transition morphism $\delta: S \times \Sigma \to S$. Model external side effects, streams, and persistence as an outer coalgebraic observation shell $\gamma: S \to F(S)$.
2. **Coeffect & Effect Grading (Gifford-Lucassen / Moggi):** Stratify every operation by its effect grade $\epsilon \in \{\text{Pure}, \text{Read/Coeffect}, \text{Write/Effect}, \text{Async/IO}, \text{Control/NFR}\}$. Inner rings cannot import or invoke outer rings.
3. **Parnas's "Uses" Partial Order ($L_i \prec L_j$):** Enforce a Directed Acyclic Graph (DAG) condensation where $L_0$ has out-degree $0$ (depends on nothing). Any layer $L_k$ is testable and compilable in total absence of $L_{m}$ for all $m > k$.
4. **Abadi-Lamport Refinement Mapping ($M_{\text{concrete}} \sqsubseteq M_{\text{abstract}}$):** Treat non-functional requirements (latency, zero-copy layout, lock-free concurrency, rate-limiting) as outer refinement functors applied over the pure functional specification without mutating $L_0$ truth conditions.

## Concentric Layer Topology

Dissect every feature into exactly five concentric rings:

- **$L_0$ : Pure Algebraic Kernel (Types, State & Invariants)**
  - **Scope:** Sum/product types, compile-time `const` tables, state-machine tuples $(S, \Sigma)$, and total deterministic transition functions $\delta: S \times \Sigma \to \text{Result}\langle S, E_{\text{domain}}\rangle$.
  - **Constraints:** Zero heap allocations where possible, zero I/O, zero clocks/randomness, zero external crates/libraries beyond core primitives.
- **$L_1$ : Coeffect & Domain Policy Ring (Context-Bound Logic)**
  - **Scope:** Read-only environmental requirements (configuration parameters, routing tables, permission matrices, logical timestamps passed as explicit values) and multi-entity domain rules.
  - **Constraints:** Referentially transparent given explicit context $C$: $f: C \times S \times \Sigma \to \text{Result}\langle S \times \text{Vec}\langle\text{Intent}\rangle, E_{\text{policy}}\rangle$. Emits declarative effect *intents* (commands/events as values), never executes them.
- **$L_2$ : Effect Algebra & Port Boundaries (Side-Effect Interfaces)**
  - **Scope:** Trait/interface definitions for persistence, network transport, IPC, hardware buffers, and cryptographic signing. Maps $L_1$ declarative intents to abstract effect signatures.
  - **Constraints:** Defines the contract and error translation boundary ($E_{\text{infra}} \to E_{\text{domain}}$) without binding to specific drivers or sockets.
- **$L_3$ : Impure Operational Shell (Drivers, I/O & Execution Runtime)**
  - **Scope:** Concrete adapters (e.g., eBPF/XDP hooks, raw sockets, Neo4j/SQL transactions, filesystem syscalls, event loops) that interpret $L_2$ interfaces and drive the $L_0/L_1$ state machine.
  - **Constraints:** Contains all async runtimes, mutable buffers, syscall error handling, and retry loops. Thin orchestration only; zero domain branching.
- **$L_4$ : Non-Functional Envelope (Performance, Security & Telemetry)**
  - **Scope:** Orthogonal operational constraints: memory layout/alignment (cache-line padding, arena allocation, zero-copy DMA), concurrency/locking strategy, backpressure, rate limiting, sandboxing, and metrics/tracing probes.
  - **Constraints:** Expressed as quantifiable invariants (e.g., $O(1)$ worst-case time, zero syscalls on hot path, bounded queue capacity $N$) wrapping $L_0 \dots L_3$.

## Dissection Workflow

1. **Extract the Invariant Core:** Strip all mention of databases, protocols, UI, threads, and caches from the feature request. Identify the irreducible state $S$, input alphabet $\Sigma$, and safety invariants $I(S)$.
2. **Factor Side Effects into Intents:** Replace every inline side effect ("save to DB", "send packet", "log audit") with a pure return value (an `EffectIntent` enum emitted by $L_1$).
3. **Populate the 5-Layer Dissection Matrix:** Present the feature breakdown using a wide, multi-dimensional Markdown table covering all five rings ($L_0 \to L_4$) with explicit signatures, invariants, and verification strategies.
4. **Define the Radial Build & Verification Order:** Specify how to verify each ring in isolation before wrapping it in the next outer ring (e.g., property-based/Kani model checking for $L_0$, mock-free value testing for $L_1$, contract tests for $L_2$, integration tests for $L_3$, benchmark/fuzz harnesses for $L_4$).

## Required Output Format

Always output the dissection in two parts:

### Part 1: Wide Concentric Layer Matrix

Render a Markdown table with these exact columns:
`| Layer & Ring | Formal Role & Effect Grade | State / Types / Signatures | Invariants & Pre/Post-Conditions | Coupled Dependencies (Allowed / Forbidden) | Verification & Proof Strategy |`

Populate multiple concrete items per cell using compact `<br>` bullets so the entire architecture is visible in a single high-density view.

### Part 2: Cross-Layer Boundary Contracts

1. **Intent Emitted ($L_1 \to L_2$):** Exact sum type (`enum`) of side-effect commands emitted by the pure core.
2. **Coeffect Context Injected ($L_3 \to L_1$):** Exact read-only snapshot struct passed from the outer shell into the pure core on each tick/request.
3. **Non-Functional Refinement ($L_4$ over $L_0 \dots L_3$):** Concrete memory, latency, concurrency, and failure-isolation bounds.

## Gotchas

- **Never leak I/O into $L_0$ or $L_1$:** Even calling `SystemTime::now()` or generating a UUID v4 inside $L_0/L_1$ violates purity. Pass time and entropy in from $L_3$ as explicit coeffect values in $L_1$.
- **Avoid chronological task drift:** Do not write "Phase 1: Set up database, Phase 2: Write API". Always anchor the decomposition strictly by dependency depth ($L_0$ inward to $L_4$ outward).