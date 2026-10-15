---
name: code-engineering-metrics
description: Inventory and measure applicable code engineering metrics across quality, complexity, tests, performance, and dependencies. Use for repository baselines, engineering assessments, or before/after comparisons with reproducible evidence and explicit measurement gaps.
---

# Code engineering metrics

Produce an evidence-backed measurement inventory, not a universal quality score.
The metric space is open-ended: cover the applicable families in
[references/metric-catalog.md](references/metric-catalog.md), then add measures
required by the system's actual contracts and workloads.

## Establish the measurement boundary

- Identify the revision, dirty changes, languages, components, and relevant
  contracts. Distinguish functions, types, files, modules, and repository totals.
- Read repository instructions, build definitions, CI, existing reports, and
  benchmark configuration. Prefer configured tools and pinned environments.
- Record exclusions for generated, vendored, test, migration, and build output
  code. Keep production and test measurements distinguishable.
- Determine whether the request is an inventory, baseline, comparison, or deep
  assessment. For a comparison, hold workload, tooling, options, and environment
  constant; otherwise label the comparison's limitations.

## Collect

1. Map each catalog family to a concrete decision and an available measurement
   method. Inspect configured tool capabilities before selecting commands.
2. Reuse compatible reports with provenance; label stale or incompatible ones.
   Otherwise run repository-supported checks and collect machine-readable output
   where available. Preserve command, exit status, and raw report locations.
3. Start with source, dependency, compiler, lint, test, and existing coverage
   evidence. Run performance, mutation, fuzz, or load campaigns when requested
   or within the established runtime and resource budget. Never silently use
   production traffic or services for a benchmark.
4. Do not install ad hoc tools or modify code/configuration to obtain a metric.
   Use the declared environment; report a missing capability and the specific
   setup needed. A failed check remains visible even if other collection proceeds.
5. Report each selected metric as measured, unavailable, not applicable,
   not run, or failed, with a reason. Missing data is never zero. Distinguish a
   successful scan with findings from a tool execution failure using its documented
   exit semantics. Do not turn a failed required check into a passing assessment.

## Interpret

- Define every ratio's numerator, denominator, and aggregation. Retain counts
  and distributions; a repository average can hide a critical hotspot.
- Keep tool-specific complexity, duplication, severity, and maintainability
  definitions explicit. Compare only compatible definitions and versions.
- Treat churn, complexity, coverage, and findings as signals. They do not alone
  establish defects, correctness, exploitability, or developer productivity.
- For performance, record workload, input size, hardware, runtime, build mode,
  concurrency, warmup, repetitions, and uncertainty. Report tail quantiles only
  with adequate observations; do not average quantiles across runs.
- Compare an explicit baseline and report absolute/relative deltas where defined.
  A zero baseline makes percentage change undefined. Label observational
  correlations and estimated proxies; do not present them as causal results.
- Use project contracts or agreed baselines for thresholds. Do not invent
  universal cutoffs or combine unrelated units into one quality score.

## Deliver

Give scope/revision/environment, a concise metrics table, measurement gaps, and
the few findings that most affect an engineering decision. Each table entry needs:

`metric | entity/scope | value + unit | definition/denominator | status | evidence`

For comparisons add baseline, delta, and comparability limitations. Link commands
and raw artifacts rather than flooding the report with logs. Preserve enough
provenance to repeat the measurement without retaining secrets or sensitive data.
