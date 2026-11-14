---
name: review-spec-into
description: Grill, formalize, and close a feature specification into an existing maintenance codebase using only specifications, requirements, and host-system domain docs—strictly excluding feature implementation code.
---

# Review Spec Into Maintenance Codebase (Implementation-Blind Grilling)

Audit and close a feature specification $\mathcal{S}_{\text{new}}$ for consistency, completeness, and compositional soundness **into** an existing host system $\mathcal{S}_{\text{host}}$ before (or blind to) implementation code.

## DO NOT USE WHEN

- Reviewing an existing or newly written code implementation against a spec (use `spec-to-code-compliance` or `implementatation-review`).
- Designing a greenfield system with no host-system invariants or coupled domain specs.

---

## 1. Epistemic Partition (Zero Impl Contamination)

Partition available inputs before reading:

- $\mathcal{S}_{\text{new}}$: target feature spec (`.md`, `.typ`, RFCs), test/prompt specs, linked issue and PR requirements.
- $\mathcal{S}_{\text{host}}$: host codebase's established domain specs, formal/reference models, and architectural laws (e.g., `plan-apply` purity, fixed-point scales/rounding, accounting, risk/margin, order/trigger lifecycles, auth/ACL, subsystem exclusions).
- $\mathcal{C}_{\text{new}}$: candidate implementation, wire, SDK, persistence, or generated test code for the feature — **strictly excluded**. Never read $\mathcal{C}_{\text{new}}$ to infer missing rules; accidental code choices must not launder themselves into the specification.

---

## 2. Host-System Pullback & Cross-Doc Audit

Model host state as a product $\Sigma = \prod_{k \in K} \Sigma_k$ over coupled subsystems and the specified feature as a partial state morphism
$$T : \Sigma \times I \rightharpoonup \Sigma \times R.$$
Delegate parallel read-only passes over $\mathcal{S}_{\text{new}}$ and $\mathcal{S}_{\text{host}}$ to extract:

1. **Admissibility Domain $\operatorname{dom}(T) \subseteq \Sigma \times I$**:
   - Actor/role gates, aliasing ($a_{\text{src}} \neq a_{\text{dst}}$), and excluded account classes (e.g., vaults $a \notin \mathcal{V}$).
   - Market/subsystem regimes (operational, frozen, delisting, missing external oracle/index, CLOB vs RFQ).
   - Input sign, monotonicity, and magnitude bounds (e.g., strict reduction $0 < s \le |b_{\text{src}}|$ vs flip, explicit price bounds, integer overflow domain).
2. **Non-Commuting Phase Factorization $T = T_n \circ \dots \circ T_1$**:
   - Fix exact phase ordering where operations do not commute (e.g., full-position funding settlement $\to$ exposure/cost-basis transfer & rounding $\to$ resting order/trigger/OI maintenance $\to$ post-state invariant check).
   - Fix exact rounding operators ($\lfloor \cdot \rfloor$, $\lceil \cdot \rceil$, scale conversions) and state representations (e.g., $(b, q)$ vs $(b, p_{\text{open}})$) to match $\mathcal{S}_{\text{host}}$ laws unless explicitly overridden.
3. **Invariant & Failure Semantics**:
   - For each affected entity, fix which invariants are checked **pre**, **inter-phase**, **post-plan only**, or **never** (e.g., source health ignored with negative balance retained vs absorbed; target checked post-plan only on $\text{MF}' > \text{MMF}'$ vs full trade `IMF`/`CMF`/`PON` gates).
   - Require atomic rollback on any failed precondition or post-condition ($\text{err} \implies \sigma' = \sigma$).
4. **Equivalence Quotient Verification**:
   - Whenever $\mathcal{S}_{\text{new}}$ claims $T \equiv T_{\text{ref}}$ (e.g., *"same state transition as a zero-fee trade"*), compute the exact validity locus
     $$D_{\text{eq}} = \{(\sigma, i) \in \operatorname{dom}(T) \cap \operatorname{dom}(T_{\text{ref}}) \mid T(\sigma, i) = T_{\text{ref}}(\sigma, i)\}$$
     and explicitly enumerate $(\Sigma \times I) \setminus D_{\text{eq}}$ (sub-tick/off-grid states, bypassed resting liquidity or price bands, asymmetric risk predicates) to refute false unconditional claims.
5. **Contradiction & Drift Inventory**:
   - Flag sign inversions, representation clashes within the same document, terminology drift across $\mathcal{S}_{\text{new}} \cup \mathcal{S}_{\text{host}}$, and unstated cross-subsystem side effects.

---

## 3. Bounded Decision Forking & Iterative Human Grilling

Compose with `review-plan-spec`: never guess silent defaults for undetermined transitions.

1. **Fork Generation**: Expand unresolved design choices into 2–3 dominant forks covering the solution space (depth $\le 2$, $\le 10$ forks total), stating for each fork what $\mathcal{S}_{\text{new}}$ leaves undefined and which $\mathcal{S}_{\text{host}}$ invariant it touches.
2. **Round 1 — Structural Grilling**: Present compact, numbered decisions covering core transition laws, subsystem exclusions, canonical host behavior reuse (*"same as $T_{\text{ref}}$"* vs custom), deficit/error ownership, and invariant evaluation point/relation.
3. **Round 2 — Boundary & Regime Closure**: Substitute Round 1 answers into $T$, simplify the formal equations, and surface only the residual boundary questions exposed by those choices (e.g., price-band exemptions, frozen-market admissibility, virtual-credit/special-collateral exemptions, zero-denominator edge cases, narrowed equivalence scope $D_{\text{eq}}$).

---

## 4. Persistent Artifact & Spec Write-Back

1. Maintain a single structured review artifact (`spec_consistency_and_fullness_review.md`) containing:
   - Audited $\mathcal{S}_{\text{new}}$ and $\mathcal{S}_{\text{host}}$ file/line links (zero $\mathcal{C}_{\text{new}}$ references);
   - Closed formal transition specification ($A$ Preconditions, $B\dots D$ Ordered Phases, $E$ Post-State Invariants, $F$ Architectural Split);
   - Direct contradictions found across $\mathcal{S}_{\text{new}} \cup \mathcal{S}_{\text{host}}$;
   - Open vs resolved decision forks.
2. Only when explicitly instructed by the human (`FINAL` / write-back approval), patch the resolved equations, preconditions, invariant formulas, and restricted equivalence scope $D_{\text{eq}}$ directly into the target `.md` / `.typ` spec files without touching implementation code.
