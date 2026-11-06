---
name: issue-context-scavenger-v4
description: Scavenge, correlate, and synthesize distributed context around a GitHub issue, PR, Slack thread, Doc/RFC, or technical ticket across codebases, issue comments, Slack/chat, Google Docs/RFCs, and competitor implementations. Uses k-hop snowball traversal (low=1, med=2, high=3), Belnap 4-valued paraconsistent logic to retain contradictions without silent resolution, and dual stopping gates: Least Fixed-Point (zero new delta) and a Contradiction Circuit Breaker (stops immediately if contradictions exceed threshold K_max).
---

# Issue Context Scavenger

Systematically harvest, cross-reference, and reconcile scattered technical truth around a technical issue, PR, chat thread, or design document across five domains: issue trackers, codebase & VCS history, internal chat (Slack), architecture docs (Google Docs/RFCs), and external competitor/ecosystem prior art.

## 1. Theoretical Foundations: Monotone Convergence & Paraconsistent Contradiction Retention

Scavenging distributed engineering context is governed by five formal laws:

1. **Monotone Context Accumulation & Least Fixed-Point (LFP) Termination (Tarski-Knaster)**:
   - Let $C_k$ be the accumulated knowledge state after hop $k$, initialized at $C_0 = \text{Parse}(\text{Seed})$.
   - Each hop $k$ applies an expansion operator $\Phi$ across all 5 channels and merges newly discovered facts:
     $$C_k = C_{k-1} \cup \Phi(C_{k-1}), \quad \Delta C_k = C_k \setminus C_{k-1}$$
   - **Zero-Delta Convergence Gate (Early Stop #1)**: If a hop adds no new semantic difference ($\|\Delta C_k\|_{\text{sem}} = 0$ or $\Delta C_k = \emptyset$), the traversal has reached its **Least Fixed Point** ($C_k = C_{k-1}$) and **MUST STOP IMMEDIATELY**, even if $k < d_{\max}$.

2. **Belnap's 4-Valued Paraconsistent Logic ($\mathcal{FOUR} = \{\mathbf{U}, \mathbf{T}, \mathbf{F}, \mathbf{B}\}$) — Retain Contradictions**:
   - In classical logic, $(P \land \neg P) \vdash \bot$ causes *Principle of Explosion* (or prompts an AI to hallucinate a silent harmonization).
   - Instead, evaluate every domain invariant $P$ in Belnap's bilattice $\mathcal{FOUR}$:
     - $\mathbf{U}$ (*Unknown*): No channel mentions $P$.
     - $\mathbf{T}$ (*True*) / $\mathbf{F}$ (*False*): Verified consistently across inspected channels.
     - $\mathbf{B}$ (*Both / Overdetermined Contradiction*): Source $S_i$ asserts $P$ while Source $S_j$ asserts $\neg P$ (e.g., RFC states lock-free $\mathbf{T}$, `jj file annotate` proves mutex lock $\mathbf{F}$).
   - **Strict Non-Overwrite Law**: Never silently resolve, average out, or overwrite a $\mathbf{B}$-state contradiction. Append every conflicting tuple $x = (P, S_i \vdash P, S_j \vdash \neg P, \text{Hop } k)$ into a monotonic **Contradiction Ledger** $\mathcal{X}_k = \mathcal{X}_{k-1} \cup \Delta \mathcal{X}_k$.

3. **Epistemic Entropy Circuit Breaker (Contradiction Overload Stop #2)**:
   - Let $|\mathcal{X}_k|$ be the cardinality of active, unresolved critical contradictions at hop $k$, and let $K_{\max}$ be the **Contradiction Budget** (default: $K_{\max} = 3$ for `low`, $5$ for `med`, $7$ for `high`, or if contradicting branches > 50% of active frontier).
   - **Divergence / Incoherence Halt**: If $|\mathcal{X}_k| \ge K_{\max}$, the system is in a state of **Architectural Split-Brain** (the spec, issue, Slack, and code are fundamentally desynchronized). Further automated hops only amplify noise ($O(b^d)$ garbage expansion). **ABORT TRAVERSAL IMMEDIATELY**, freeze $\mathcal{X}_k$, and escalate directly to a human Decision Gate.

4. **Information Foraging & Marginal Value Theorem (Pirolli, Card & Charnov)**:
   - Score outgoing links by **Information Scent** $S(e)$ (symbol overlap, stack-frame match, blame authorship, timestamp proximity). Prune branches where marginal invariant discovery $g'(t) \to 0$.

5. **Bounded $k$-Hop Snowball Sampling (Goodman)**:
   - Traverse $G = (V, E)$ up to depth $d_{\max} \in \{1, 2, 3\}$, compiling concrete queries at hop $k$ from residual tokens $\Delta T_{k-1}$.

---

## 2. Depth Modes ($d_{\max} \in \{1, 2, 3\}$) & Dual Stopping Gates

Default to `med` ($d_{\max}=2$) if unspecified, or infer from user prompt (`low`/`1`, `med`/`2`, `high`/`3`).

- **Cumulative Context & Contradiction Retention**:
  $$C_k = C_{k-1} \cup \Delta C_k, \qquad \mathcal{X}_k = \mathcal{X}_{k-1} \cup \Delta \mathcal{X}_k$$
- **Tri-State Loop Control at Every Hop $k$**:
  1. **STOP (Fixed-Point Convergence)**: $\Delta C_k = \emptyset \implies \text{HALT}$ (Nothing new learned).
  2. **STOP (Contradiction Circuit Breaker)**: $|\mathcal{X}_k| \ge K_{\max} \implies \text{HALT & ESCALATE}$ (Too many contradictions; architectural incoherence detected).
  3. **CONTINUE / ESCALATE ($d_{\max} \mathrel{+}= 1$)**: If $1 \le |\mathcal{X}_k| < K_{\max}$ at $k = d_{\max}$ (a bounded, localized contradiction or dangling pointer), allow $+1$ targeted hop strictly on those $|\mathcal{X}_k|$ conflicting edges to locate the tie-breaking commit/ADR until $\Delta C = \emptyset$ or $|\mathcal{X}| \ge K_{\max}$.

| Mode & Max Depth ($d_{\max}$) | Frontier Expansion ($V_0 \to V_k$) | Context & Contradiction Accumulation ($C_k, \mathcal{X}_k$) | Dual Stopping Gates (Fixed-Point $\lor$ Circuit Breaker $K_{\max}$) |
| :--- | :--- | :--- | :--- |
| **`low` ($d_{\max} = 1$)** <br> *Direct Neighborhood* | $V_0 \to V_1$ <br> *(1-Hop Ego Graph)* | Harvest direct `rg` definitions, `gh` issue body/comments, exact ticket-ID Slack hits, and direct RFC matches into $C_1$; log all immediate conflicts in $\mathcal{X}_1$. | Stop at $k=1$, **OR** halt immediately if $|\mathcal{X}_1| \ge 3$ (Circuit Breaker). If $1 \le |\mathcal{X}_1| \le 2$, allow $+1$ targeted tie-breaker hop. |
| **`med` ($d_{\max} = 2$)** <br> *Transitive Context & Blame* | $V_0 \to V_1 \to V_2$ <br> *(2-Hop Transitive Closure)* | Compile $\Delta T_1$ (callers/callees, `jj`/`hg` blame SHAs & authors, linked PRs) into Hop 2 queries; retain all cross-channel conflicts in $\mathcal{X}_2$. | **Stop early at $k=1$ if $\Delta C_1 = \emptyset$ OR $|\mathcal{X}_1| \ge 5$**. Otherwise run Hop 2 and stop when $\Delta C_2 = \emptyset$, $|\mathcal{X}_2| \ge 5$, or $k=2$. |
| **`high` ($d_{\max} = 3$)** <br> *Deep Archaeology & Prior Art* | $V_0 \to V_1 \to V_2 \to V_3$ <br> *(3-Hop Structural Closure)* | Compile $\Delta T_2$ (`jj evolog` renames, reverted PR chains, prior incident IDs, competitor bug refs) into Hop 3 queries; retain $\mathcal{X}_3$. | **Stop at any hop $k \le 3$ as soon as $\Delta C_k = \emptyset$ (Fixed Point) OR $|\mathcal{X}_k| \ge 7$ (Circuit Breaker)**. |

---

## 3. Execution Steps

### Step 1: Initialize Context $C_0$, Contradiction Ledger $\mathcal{X}_0 = \emptyset$ & Seed Signature $T_0$

Decompose the input into initial token sets inside $C_0$:
- **Identifiers ($T_{\text{id}}$)**: Issue/PR IDs, `jj` change IDs, `hg`/`git` SHAs, branch/bookmark names, incident IDs.
- **Code Symbols ($T_{\text{sym}}$)**: Struct/trait/function names, error variants, CLI flags, config keys, file paths, stack frames.
- **Domain Semantics ($T_{\text{dom}}$)**: Core problem nouns, algorithms, state-machine invariants, protocol mechanisms.
- **Actors & Temporal Bounds ($T_{\text{meta}}$)**: Reporters, maintainers, code owners, and timestamp windows around regressions.

### Step 2: Iterative Hop Execution, Contradiction Retention & Concrete Query Synthesis ($k = 1 \dots d_{\max}$)

For each hop $k$:
1. **Compile Concrete Queries**: Translate residual tokens $\Delta T_{k-1}$ into **concrete, zero-placeholder queries** across all 5 channels.
2. **Execute & Merge**: Run reachable workspace/web tools directly, emit concrete CLI pipelines (`jj`, `hg`, `rg`, `gh`, `slack`) for gated local environments, and update $C_k = C_{k-1} \cup \Delta C_k$.
3. **Populate Contradiction Ledger ($\mathcal{X}_k = \mathcal{X}_{k-1} \cup \Delta \mathcal{X}_k$)**: Whenever two sources disagree on an invariant, tag the invariant with Belnap state $\mathbf{B}$ and record both sides verbatim in $\mathcal{X}_k$.
4. **Check Dual Stopping Gates**:
   - **Gate A (Zero-Delta Fixed Point)**: If $\Delta C_k = \emptyset$, **STOP**.
   - **Gate B (Contradiction Overload)**: If $|\mathcal{X}_k| \ge K_{\max}$, **STOP IMMEDIATELY** and flag `CIRCUIT_BREAKER_TRIPPED`.

| Channel | Hop 1 ($C_0 \to C_1$) Concrete Synthesis | Hop 2 ($C_1 \to C_2$, driven by $\Delta C_1, \mathcal{X}_1$) | Hop 3 ($C_2 \to C_3$, driven by $\Delta C_2, \mathcal{X}_2$) |
| :--- | :--- | :--- | :--- |
| **1. Issue & PR Graph** | Fetch seed issue/PR body, comments, labels, and timeline events (`gh issue/pr view`). | Fetch cross-referenced PR diffs, review threads, and linked issues discovered in $\Delta C_1$ (`gh search prs/issues`). | Query historical closed/reverted PRs, milestone blockers, and org-wide issues touching invariants in $\Delta C_2$. |
| **2. Codebase & VCS (`jj` / `hg` preferred)** | Locate exact symbol definitions and direct references (`rg -n`, `ast-grep`). | Trace callers/callees, test suites, and line-level blame/annotations (`jj file annotate`, `jj log -r "grep(...)"`, `hg annotate`). | Trace multi-step revset ancestry, symbol renames, and evolution logs (`jj log -r "ancestors(..., 10)"`, `jj evolog`, `hg log -r "::rev"`). |
| **3. Slack & Async Chat** | Search exact issue ID, PR number, and literal error strings (`slack search messages`). | Search threads by $\Delta C_1$ blame authors + subsystem channel + date window around the regression commit. | Search historical incident channels, architectural debates, and deprecated codenames uncovered in $\Delta C_2$ RFCs/commits. |
| **4. Google Docs & RFCs** | Search Drive/Docs for exact issue IDs, feature names, and primary symbols in $T_0$. | Search ADRs, design docs, and meeting notes for subsystem invariants and internal codenames found in $\Delta C_1$. | Inspect superseded specs, postmortems, and inline Doc comment threads to uncover why alternative designs were rejected. |
| **5. Competitors & Prior Art** | Search known competitors or upstream repos for the primary feature or error noun. | Query competitor issue trackers and PRs for the specific algorithmic mechanism or lock/memory invariant found in $\Delta C_1$ code. | Extract competitor benchmark trade-offs, pathological edge-case bug reports, and RFC rejections to stress-test our proposed fix. |

### Step 3: Paraconsistent Contradiction Classification (Retain All $\mathbf{B}$-States)

Never smooth over conflicts. Classify every retained entry in $\mathcal{X}_{\text{final}}$ into one of four structural drift categories:
1. **Doc vs. Code Drift ($\mathbf{B}_{\text{doc-code}}$)**: RFC/Doc asserts invariant $P$, whereas codebase at tip implements $\neg P$.
2. **Slack vs. Tracker Drift ($\mathbf{B}_{\text{chat-issue}}$)**: Engineers agreed on a constraint or workaround in Slack that contradicts or is absent from the GitHub issue.
3. **VCS History vs. Proposed Fix ($\mathbf{B}_{\text{chesterton}}$)**: Commit/revset history (`jj`/`hg`) proves the current guard was deliberately added to prevent bug $X$, which the issue's proposed fix would re-introduce.
4. **Internal vs. Competitor Invariant ($\mathbf{B}_{\text{prior-art}}$)**: Proposed internal design assumes invariant $P$ holds at scale, whereas competitor/upstream trackers prove $P$ fails under edge case $E$.

### Step 4: Output Synthesis Structure (Wide Multi-Dimensional Tables)

#### Table 1: Cumulative Hop & Context Delta Ledger ($C_0 \to C_{\text{final}}$)
Columns: `Hop (k) | Source Domain | Artifact / Ref | Net-New Context Added (\Delta C_k) | New Tokens Spawned (\Delta T_k) | Belnap State (T/F/B/U) | Stop Gate Status (\Delta C=0 or |\mathcal{X}| \ge K_max)`

#### Table 2: Retained Contradiction Ledger ($\mathcal{X}_{\text{final}}$ — Unresolved $\mathbf{B}$-States)
Columns: `Contradiction ID | Drift Type | Invariant / Subject | Thesis (Source A + Exact Proof/Ref) | Antithesis (Source B + Exact Proof/Ref) | Blast Radius & Failure Mode if Ignored | Tie-Breaker Action / Owner`

#### Table 3: Competitor & Ecosystem Prior Art Matrix
Columns: `System / Competitor | Architectural Mechanism & Data Model | Edge-Case Handling & Perf Trade-offs | Upstream Issue / PR / Code Ref | Applicability & Lesson for Our Issue`

#### Table 4: Codebase Blast Radius & VCS Touchpoints
Columns: `Hop (k) | Subsystem / File Path | Symbol / Invariant | Current Behavior & Constraints | Historical Context / VCS Blame (jj / hg) | Required Mutation & Risk Level`

### Step 5: Synthesized Concrete Query Block & Decision Gates

Close with two actionable blocks:
1. **Concrete Synthesized Queries by Hop ($k = 1 \dots k_{\text{stop}}$)**: Copy-pasteable CLI pipelines (`jj`, `hg`, `rg`, `gh`, `slack`, Drive, competitor queries) populated with the **actual extracted symbols, commit/change IDs, dates, and keywords**—zero raw `<placeholder>` tags. State explicitly whether termination was triggered by **Depth Limit ($k = d_{\max}$)**, **Zero-Delta Fixed Point ($\Delta C_k = \emptyset$)**, or **Contradiction Circuit Breaker ($|\mathcal{X}_k| \ge K_{\max}$)**.
2. **High-Leverage Questions & Contradiction Resolution Gates**:
   - **If Circuit Breaker Tripped ($|\mathcal{X}_k| \ge K_{\max}$)**: Present a prioritized **Split-Brain Triage Checklist** forcing stakeholders to pick the canonical source of truth before any further code or spec work proceeds.
   - **For Issue Author / PM**: Ambiguous boundary conditions, unstated invariants, or SLA trade-offs.
   - **For Domain Maintainers (Slack / PR Review)**: Exact $\mathbf{B}$-state contradictions from Table 2 requiring human arbitration.

## Gotchas

- **Never hallucinate consensus**: If the RFC says $A$, Slack says $B$, and the code does $C$, retain all three in Table 2 ($\mathcal{X}_{\text{final}}$) as an explicit $\mathbf{B}$-state conflict.
- **Enforce both early-stopping gates**: Stop immediately if a hop yields zero new semantic difference ($\Delta C_k = \emptyset$) **OR** if accumulated contradictions breach the circuit breaker ($|\mathcal{X}_k| \ge K_{\max}$).
- **Zero placeholder leakage**: Always compile extracted tokens into concrete queries; never output literal `<symbol>` or `<id>` placeholders when investigating a real target.