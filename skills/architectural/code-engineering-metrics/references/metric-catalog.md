# Metric search catalog

These are candidate measures, not a requirement to run every possible tool.
For each family record applicability, available tools/data, collection cost,
and measurement status. Extend with domain-specific contracts.

| Family | Candidate measures | Interpretation constraints |
|---|---|---|
| Size and shape | Files, source lines by language, functions/types/modules, function length, parameter count, nesting, public API size | Separate generated/vendor/test code; define physical versus logical lines. |
| Control and cognitive complexity | Cyclomatic complexity, cognitive complexity, branch count, recursion, fan-in/out | Use parser/tool definitions; text counts are proxies, not equivalent measurements. |
| Duplication | Duplicated tokens/lines/blocks, clone families, duplication density | Record thresholds and denominator; distinguish intentional generated repetition. |
| Structure | Dependency graph edges, cycles/SCCs, coupling, cohesion, forbidden boundary edges, dependency depth | State graph nodes/edges; cohesion measures depend on language and tool. |
| Compiler and static quality | Build/typecheck result, diagnostics by rule/severity, lint findings, dead code, unsafe/unchecked operations | Findings are not defect counts; unsupported analysis is not a clean scan. |
| Test execution | Passed/failed/skipped tests, duration, repeated-run flake rate, failure classes | Report retries and skipped tests; test count alone says little about assurance. |
| Coverage | Line, statement, branch, function, changed-code coverage; uncovered critical paths | Each uses its own denominator; passing coverage does not prove behavior. |
| Test strength | Mutation score, killed/surviving/uncovered/timed-out mutants, property/fuzz failures, cases and execution budget | State excluded/equivalent mutants and tool scoring policy; no failure is not proof. |
| Runtime performance | Latency distribution, throughput, startup, CPU time, allocations, peak/steady memory, GC pauses | Specify representative workload and resource limits; separate microbenchmark and system results. |
| I/O and concurrency | Query count/latency, bytes read/written, syscalls, queue depth, lock contention, scheduling delay, connection usage | Requires instrumentation; rates need a time interval and workload context. |
| Resource efficiency | CPU-seconds/request, bytes/request, cost/unit of work, energy/unit of work | Cost and energy require actual pricing or measurement models; label estimates. |
| Dependencies | Direct/transitive counts, versions, duplicates, graph depth, update lag, unsupported packages, license inventory | An old version is not automatically unsafe; define lag and support evidence. |
| Dependency security | Advisory matches by severity, affected ranges, reachability evidence, fix availability, scanner DB age | Advisory matches do not alone prove exploitability; preserve source and scan time. |
| Build and tooling | Clean/incremental build duration, cache hits, artifact size, install/resolve time, reproducibility comparison | Specify warm/cold caches, toolchain, platform, and lockfiles. |
| Change risk | Churn, hotspot concentration, complexity × churn as an explicitly defined heuristic, co-change frequency, ownership concentration | Requires history and a window; do not rank people or infer causation from correlations. |
| Compatibility | Public API/schema/ABI changes, contract-test failures, serialization round trips, migration failures | Requires a baseline and compatibility policy; reversibility is contract-specific. |
| Operational reliability | Error rate, availability, saturation, recovery time, SLO compliance | Requires operational evidence; cannot be inferred reliably from source alone. |
| Delivery | Deployment frequency, change lead time, change failure/rework, failed deployment recovery | Requires delivery/incident data and explicit event definitions; repository history alone is insufficient. |
| Documentation | Broken links, API documentation coverage, executable-example results, stale references | Presence is measurable; clarity/usefulness need a rubric and review. |

## Definitions worth making explicit

- Coverage: covered eligible items / all eligible items, for the chosen item kind.
- Flake rate: inconsistent outcomes / repeated comparable trials; define the
  trial unit and treatment of infrastructure failures.
- Throughput: completed units of work / elapsed time; report errors separately.
- Duplication density: tool-defined duplicated eligible units / eligible units.
- Mutation score: use the tool's stated mutant categories and denominator;
  report counts so different scoring conventions remain visible.
- Relative delta: (candidate − baseline) / baseline, when baseline ≠ 0.

Report distributions/hotspots where they matter. Do not compare scores across
languages, tool versions, or different exclusions without a justified mapping.
