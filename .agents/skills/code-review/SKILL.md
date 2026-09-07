---
name: code-review
description: Coordinate automated code review of pull requests, branches, commits, or diffs by selecting relevant review skills, collecting repository and change context, running focused subagents when delegation is allowed, and returning prioritized findings. Use when the user asks to "review PR", "code review branch", "code review commit", "review pull request", review a GitHub PR, inspect a branch before merge, or audit a commit range for correctness, security, tests, and maintainability.
---

## Requires

- Caller already shelled into proper env or container, so model must not and will not do any attempt to switch shell. From pwd of root orchestrator agent.
- You are authorized to spawn subagents for this workflow.
- Skills must be installable or installed.
- Hard abort if required tooling fails to install.
- Any finding must pass the Verify Findings step.
- Allow localhost access calls.

## When to use

Use this skill to turn an ambiguous review request into a structured code review. Identify the changed code, choose the smallest useful set of specialized review skills, delegate independent review passes when allowed, then consolidate findings in severity order with file and line references.

This skill may identify pre-existing issues when the reviewed change makes them worse, exposes them through a new path, or turns them into a regression.

## When not to use

- General code quality review without a specific diff, branch, commit, or pull request.
- Automatic fixes for CI failures or GitHub review comments.
- Broad searches for pre-existing issues unrelated to the reviewed change.
- Implementing fixes. Report problems and evidence, but do not patch code unless the user asks for fixes.
- Think about whether this needs to be implemented this way, or implemented at all, unless security and liveness are violated.
- Infrastructure or networking failure, not related to changes made in this PR.
- **Do not use if you can use traditional tools to check, like running existing tests, linters, formatters.**

## Review Workflow

Each run must produce review artifacts under `/tmp/n1/<repo-name>-pr-issues-review/<target>-<timestamp>/`, where `<target>` is a filesystem-safe name such as `pr-2785` and `<timestamp>` is UTC in `YYYYMMDDTHHMMSSZ` form. Include at least these files:

- `remote-skills.md`: required and selected skill names, source URLs, validation or download method, status, and blockers.
- `change-context.md`: target metadata, base and head refs, changed files, commits, review comments, CI state, fetched local refs, and diff summary.
- `code-context.md`: changed entry points, affected call paths, invariants, related tests, runtime dependencies, blast radius, and unresolved context gaps.
- `verification-notes.md`: selected passes, verification commands or reasoning, reproduced issues, skipped checks, blockers, and subagent usage.
- `final-report.md`: findings, limits, artifact list, process metrics, and clarification needed.

If subagents are used, write each subagent result under `subagents/<pass-name>.md` and cite those files from `verification-notes.md` and `final-report.md`.

Progress may be reported in chat, but durable review state must be written to files. The final answer must summarize the result in chat and name the output files. If artifact creation fails, hard fail the review and report the tooling blocker.

### Environment

When running this workflow, run the following without asking for confirmation:

Use `secrets-reader` and  `test-build-setup` to identify what 
is envirment and how to run dependncies.

Output into cntext.

## Effort and model

Reject low-effort or old or small models for execution of this orchestartor.

### 1. Isolation

- Prefer read-only `gh`, `jj`, and `git` commands while collecting context.
- Allow local `gh`, `jj`, or `git` writes only when needed to publish findings or prepare isolated subagent workspaces.
- Install review tools and skill dependencies locally through project-scoped tooling such as `nix`, `uv`, `bun`, or `cargo`; do not install them globally.
- Run subagents without asking when the user has authorized delegation. If delegation is authorized and subagents cannot be started, hard fail and report the blocker.
- Create worktrees. If the current checkout is not already on the target PR/ref, force clone the repository into `/tmp/n1/<repo>-pr-issues-review/<target>-<timestamp>/<agent-name>` and fetch/check out the target there. 
- Keep local verification failures separate from PR failures. A local SDK, dependency, network, or sandbox failure is a verification blocker unless the evidence shows the PR caused it.


### 2. Setup

Start by changing into the checkout's `<current-subproject>/` directory. Run `git rev-parse --show-toplevel` from there to identify the parent git root for repo-relative paths and `git diff` pathspecs, but keep the shell working directory at `<current-subproject>/` for subsequent operations. Record the original working directory, the `<current-subproject>/` operating directory, and the parent git root in `change-context.md` when they differ.

When creating or cloning isolated review checkouts, create the checkout first, then immediately change into `<checkout>/<current-subproject>` before running any workflow operation inside it. If `<checkout>/<current-subproject>` is missing, hard fail as a repository layout/configuration blocker.

Load and use the resolved general skills for the coordinator and any subagents when they were installed successfully.

### 3. Build Change Context

Produce one concise GitHub/change context artifact that all later steps must consume. This artifact is required input for code context, focused review passes, verification, and reporting.

- For a GitHub PR, use the GitHub skill or `gh` to read PR metadata, base and head refs, changed files, review comments, and CI state.
- Build all code diffs from fetched git refs with `git diff`. Do not use `gh pr diff`.
- For a GitHub PR, fetch stable local refs from the remote branch names, not from `origin/<branch>` refspecs. Example:

  ```sh
  git fetch origin pull/<PR>/head:refs/tmp/n1/pr-<PR> <baseRefName>:refs/tmp/n1/pr-<PR>-base
  git diff --stat refs/tmp/n1/pr-<PR>-base...refs/tmp/n1/pr-<PR>
  git diff --find-renames refs/tmp/n1/pr-<PR>-base...refs/tmp/n1/pr-<PR>
  ```

  If the PR metadata includes base and head OIDs, record them and verify the fetched refs resolve to the expected OIDs. If the head branch is from a fork and `pull/<PR>/head` is unavailable, fetch the advertised head repository and branch into `refs/tmp/n1/pr-<PR>`.
- For a branch, compare against the merge base with the configured base branch.
- For a commit or range, inspect only the requested commits and their blast radius.
- For an unstated target, infer from the current branch and repository state; ask only if there are multiple plausible targets.
- Record the target, base, head, changed files, review comments, CI state, and any relevant commit metadata in the artifact.

### 4. Build Code Context

Depends on: GitHub/change context.

Produce one concise code context artifact that all focused review passes, verification, and reporting must consume. Use the change context to identify the relevant code paths, invariants, tests, runtime dependencies, and blast radius. Prefer these skills:

- Load and use `audit-context-building`
- Load and use `trailmark-structural`
- Record the changed entry points, affected call paths, important invariants, related tests, and any unresolved context gaps in the artifact.
- Output all artifacts into files.

### 5. Code type and domain

use `code-domain-identification` and product context additn.

Outputs `code-domain-identification.md`

### 5. Run Focused Review Passes

Depends on: GitHub/change context and code context.

Run only the passes that match the changed files or inferred risk. Independent passes must run in parallel through subagents when delegation is authorized. Every selected pass must receive both shared context artifacts, and include any additional local context it discovered in its output. 

Load files of context from previous steps to enhace each review step.

#### SQL Review

- **Trigger:** Changed `*.sql` files, database schema changes, query construction changes, migrations, or SQL-related application logic.
- **Skill:** `dba-review`
- **Focus:** Query correctness, migration safety, locking, indexing, and data integrity regressions.

#### Dependency and Vendor Review

- **Trigger:** Changed lockfiles, `*.nix`, `Cargo.toml`, dependency configuration, vendored code, or increased use of existing dependencies.
- **Skill:** `supply-chain-risk-auditor`
- **Focus:** Supply-chain risk, unexpected dependency changes, version drift, and build reproducibility.

#### Specification Compliance

- **Trigger:** Protocol changes, document changes, new features with an existing specification(including github descriptions), or code that implements externally specified behavior.
- **Skill:** `spec-to-code-compliance`
- **Focus:** Gaps between the implementation and the governing specification.

#### CI Failure Analysis

- **Trigger:** Failing CI checks that appear related to the reviewed change.
- **Skill:** `openai-gh-fix-ci`
- **Focus:** Explain likely root causes. Do not implement fixes unless the user explicitly asks.
- If CI failures are unrelated infrastructure or setup failures, classify them as CI/tooling blockers rather than PR findings.

#### Differential Analysis

- **Trigger:** Always run for non-trivial diffs.
- **Skills:**
  - Load and use `graph-evolution`
  - Load and use `differential-review`
- **Focus:** Behavioral regressions, security impact, changed call graphs, and tests that no longer cover the modified behavior.

#### Dimensional Analysis

- **Trigger:** Numeric, accounting, unit, precision, or engine changes, especially under `engine/**.rs`.
- **Skill:** `dimensional-analysis`
- **Focus:** Unit mismatches, precision loss, rounding errors, overflow, underflow, and invariant violations.

#### Mutation and Property Testing

- **Trigger:** 
   - engine changes
- **Skills:**
  - Load and use `mutation-testing`
  - Load and use `property-based-testing`
  - Load and use `genotoxic`
- **Prompt**:
  - Generate custom Python script to mutate most relevant code and generalize or write generalized prop test to interact with mutants and find and explain failures.
- **Focus:** Use property tests and mutation testing to find bugs in the change. Generate targeted properties and mutation ideas that can distinguish the intended behavior from plausible regressions. Generalize existing tests for diff.

### Product Engineering

- reads all md files in docs/** and all README.md files in directories
- finds possible bugs of interaction of this feature added or modified in this PR with all others 
- Rads and depends on `code-domain-identification.md` output.
- Uses the domain and component information to guide focused review passes.

### 6. Verify Findings

Depends on: GitHub/change context, code context, and all selected focused review pass outputs.

After all selected review passes finish, verify each candidate finding before reporting it.

- Reproduce or reason through the issue from the changed code and surrounding context.
- Prefer direct evidence from tests, static analysis, logs, or concrete execution paths.
- Load and use `fp-check`.
- Load and use `second-opinion` when another model family is available (for gpt it could be gemini or claude models, or qwen, or kimi).
- Adjudicate disagreements between review passes. Do not leak unresolved subagent disagreement into the final answer.
- Separate verification outcomes into `passed`, `candidate issue reproduced`, and `blocked by environment/tooling`.

### 7. Report

Depends on: GitHub/change context, code context, selected review pass outputs, and verification results.

Return findings first, ordered by severity. For each finding include:

- Severity.
- File and line reference.
- What changed.
- Why it is wrong or risky.
- User-visible, operational, or security impact.
- Verification status and supporting evidence.

Also include:

- A clear statement when no issues are found.
- Residual test gaps or review limits.
- The GitHub/change context artifact and code context artifact consumed by the review.
- The review artifacts produced and their file names.
- A concise list of subagent inputs and outputs, if subagents were used.
- Relevant process metrics, such as time used, failures, timeouts, and interactive questions asked.
- Tooling blockers, missing remote skills, failed subagent startup, local verification blockers, and any clarification needed to run the workflow reliably.

#### 8. Cleanup

No cleanup.