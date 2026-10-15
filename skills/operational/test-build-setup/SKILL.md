---
name: test-build-setup
description: Discover a repository's existing build, test, CI, and runtime dependency setup before reviewing or verifying code. Identify the required toolset and produce setup context without installing tooling or changing the active environment.
---

# Verification Setup Context

Inputs are the target checkout, requested scope or changed files, the current working directory and shell, and the caller's artifact directory and failure policy. Consume `change-context.md` and `secrets-context.md` when available; record if discovery precedes either artifact.

1. Identify the target repository root and relevant subprojects from manifests, CI working directories, and the requested scope. Default to the repository root when no subproject is established. Preserve the original caller directory separately; do not carry its relative path into an unrelated repository.
2. Read relevant CI workflows, Nix files, lockfiles, shell/task scripts, manifests, and setup documentation. Identify the toolset and commands for dependency services, build, tests, lint, validation, evaluation, and debugging, including their required working directory and toolchain. Separate declared commands from commands actually verified during this run.
3. Identify runtime services, databases, fixtures, environment variables, platform requirements, and how the repository starts dependencies. Reference `secrets-context.md` for credential requirements rather than copying values.
4. Compare the selected tasks' requirements with the environment already supplied by the caller. Use read-only availability/version checks when needed. Record missing tools or incompatible versions; do not install tooling, enter a new Nix shell, start services, or run project setup scripts merely by loading this skill. Follow explicit caller authorization if recovery is requested.
5. Identify existing isolation and cleanup procedures. Document them without clearing shared caches, deleting previous runs, or stopping services that this run does not own.

Before executing a scoped test command, compare its selected packages, features and targets with the repository's CI command. A narrowed package selection can omit dependency features supplied by the workspace build. If compilation exposes this difference, document it and use an authorized retry with the existing declared feature context; do not patch production manifests merely to make a review harness compile.

Pass absolute checkout, operating, artifact and build-cache paths to workers as distinct values. Preserve an assigned cache path exactly; never derive it from a log directory. Record the actual command, revision, package/features, cache, exit status and log before handing off results. Quote shell-expanded path values, including PATH, because inherited entries can contain spaces. Reuse the caller's current failure policy in every handoff, including incremental rechecks; an old worker's stop policy must not override later recovery authorization.

Write `setup-context.md` under the caller's artifact directory, separate from the reviewed checkout. Include the original directory, target root, selected subproject, relevant configuration references, commands and working directories, required tool versions and services, and current readiness. Distinguish `discovered`, `available`, `executed successfully`, and `blocked`; an entry in a lockfile does not prove local availability.

For each failure, record the command or failed requirement, evidence, affected tasks, and any authorized recovery and result. Honor the caller's current failure policy: stop dependent work on the first required infrastructure, dependency, installation, or configuration failure in stop mode; continue only through authorized recovery in recovery mode. Never label a local setup failure as a defect in the reviewed change without evidence that the change caused it.
