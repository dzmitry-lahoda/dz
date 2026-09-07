---
name: persistent-state-artifacts
description: Review consistency across authoritative state, durable records, caches, derived views, queues, and outputs. Use when asked to identify persisted or cached state, define invariants, trace missed updates, or check temporal ordering and state desynchronization in a code change.
---

# When not to use

- Codebase has not async/threading/coccurrent componnts
- No state or only one simple state used

# State and temporal consistency review

Identify what each state represents, when it becomes visible, and which transitions can leave two representations inconsistent. Use the caller's pinned checkout, change/code/domain context, artifact directory, failure policy, model preference and delegation authorization. Reuse completed setup; do not install tools, start services or repeat unrelated audits merely by invoking this skill.

## Inventory the state

For each relevant representation record:

- Authority and durability: canonical state, speculative overlay, durable log/snapshot, derived database row, cache/index, queue, response or client projection.
- Identity and version: entity key, action/subaction ID, generation, cursor, retry ticket and progress watermark.
- Writers/readers, update source, publication boundary, recovery/rebuild source and invalidation path.
- Expected divergence: ordinary bounded/unbounded lag, permitted intermediate state, or a requirement to match another representation at the same version.

Enumerate mutation paths as well as data structures. Include create, partial update, replace, activate, cancel/delete, success, permanent failure, transient error, retry exhaustion, multi-operation transactions, administrative mode changes, migration and restart.

## State the invariants

Distinguish documented requirements from proposed desirable contracts. Give each invariant an enforcement boundary: private helper completion, completed subaction, transaction commit, durable append, completed projection update, or common read cutoff.

Check at least the applicable invariants:

- Canonical records and secondary indexes correspond in both directions; owners/parents and reciprocal links remain valid.
- Derived metadata preserves its documented meaning across partial updates and lifecycle changes.
- Failure commits exactly the permitted subset; temporary overlays/counters do not leak from rejected work.
- Applying a receipt/event projection to the previous state reproduces the projection of the committed state. Consumers may derive changes implicitly when the derivation is correct.
- Journal, snapshots, replicas and acknowledgments preserve their actual durability/order contract.
- Progress is monotonic and advances only after its promised work completes. A watermark proves completion of generated work, not that all required work was generated.
- Reads presented as one version actually use a common completed version; cursors alone do not provide a multi-table snapshot.
- A fresh wakeup/update is not lost behind an older in-flight callback. Deduplication, task generation and retry state must preserve newer work.
- Replay is deterministic/idempotent, and incremental projection equals rebuilt projection at the same authoritative version.

Use simple always/eventually/until notation when it sharpens a requirement. State fairness, worker health, delivery, valid-session and retry-policy assumptions for liveness; do not claim unconditional eventual execution when policy intentionally stops retrying.

## Trace time and refute candidates

Build happens-before edges from actual code: staging, commit, append/flush, publication, enqueue, callback consumption, SQL commit, watermark update and acknowledgment. Separate send order from consumption order across independent channels.

For a suspected mismatch write a minimal sequence table with event, canonical state, cached/persisted state, and the precise point where the invariant fails. Check delayed/out-of-order callbacks, update/delete races, stale generations, partial batch failure, process restart, unchanged input after a lost event and multiple subactions in one transaction.

Attempt refutation through validation, shared test wrappers, fresh-overlay rollback, later update paths, version gates, deduplication and restart logic. Queue deletion cannot revoke a request already sent. Replaying the same incomplete event cannot invent omitted history; distinguish rebuilding a live cache from repairing durable history.

Classify each result as confirmed violation, permitted asynchronous lag, observed intermediate-read seam with an unresolved API contract, intentional policy, or unresolved candidate. Separate PR-introduced defects from pre-existing issues exposed by the requested wider review. For each violation record exact revision/lines, consequence, correction and source-only versus executed validation. Do not relabel suggested tests as tests that ran.

## Parallel composition and output

When delegation is authorized, independent canonical/index, persistence/replay, and view/queue passes may run in parallel with disjoint output ownership. The coordinator verifies shared-boundary conclusions and removes duplicates. Honor the caller's model/latency preference; do not restart the enclosing orchestration.

Write `state-consistency-review.md` under the caller's artifact root: state inventory, invariants and boundaries, transition/update matrix, happens-before diagram, concrete desynchronization sequences, recovery limits, evidence, proposed regression checks and actual execution/failure ledger. Name any delegated source reports explicitly. Preserve the pinned revision and prior reports when extending an existing run.

Only run additional checks justified by a concrete uncertainty and available setup. Respect the current failure policy and any blocked work; source review does not authorize retrying previously declined execution. Do not change production code, post findings, or repair historical data without separate authorization for those actions.


## Modelling 

Model crusial starte propertiws via TLA+ or quint