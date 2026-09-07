---
name: temporal-remote-context-aggregation
description: Aggregate time-ordered remote project context for code review, including GitHub PR descriptions, review comments, linked issues, CI results, project-management tasks, design links, and prior decisions. Use when a review needs external discussion history, issue references, decision context, or a chronological task narrative before judging code changes.
---

# Temporal Remote Context Aggregation

## Goal

Build a compact, chronological context packet that explains why a change exists, what reviewers already discussed, and which claims need verification in the code or database.

## Inputs

Collect whichever sources are available:

- PR or merge request URL, number, branch, or commit range.
- Issue tracker links, project-management task IDs, design docs, incident links, or Slack/email references.
- CI run links and failure summaries.
- The review objective and any suspected risk areas.
- The caller's artifact directory, pinned review revision, existing change context, and current failure policy.

Reuse sources already collected by the coordinator. Record optional missing sources as gaps. Required source or access failures follow the caller's policy: stop dependent work in stop mode; record and attempt only authorized recovery in recovery mode.

## Procedure

1. Identify the canonical review object: PR, branch, commit range, or issue.
2. Read the title, description, linked issues, labels, requested reviewers, and changed-file summary.
3. Read the PR discussion, submitted review bodies, and inline review threads including author replies, in chronological order. Use the installed GitHub CLI or repository-supported tooling and consume all pages. Preserve source links or IDs, authors, timestamps, thread relationships, and available commit, resolution, and outdated status. Record retrieval gaps rather than treating a partial page as complete history.
4. Follow only links that affect the review decision: design rationale, bug reports, incident notes, schema docs, rollout plans, and CI failures.
5. Extract claims that must be checked against code or runtime evidence. For author responses, preserve the original objection and the reply's concrete claim; identify the code revision to which each applies. Thread resolution is discussion state, not proof that a claim is correct.
6. Emit a small context bundle into the caller's artifact directory, separate from the reviewed checkout. If invoked independently, choose and record a task-specific output directory before writing. Give each output one writer when agents run concurrently.

## Output Files

Write these files under that output directory:

- `remote-context.md`: concise chronological summary.
- `review-claims.md`: claims to verify, including author responses, each with source, relevant revision, evidence needed, and initial `unresolved` status.
- `open-questions.md`: missing context, ambiguous requirements, and access gaps.
- `remote-tasks.md`: action items already requested by humans.

Pass all four artifact paths to code-context construction and final verification. Verification updates each material claim to `supported`, `contradicted`, or `unresolved`, citing loaded code context and exact code/test evidence. Distinguish behavior at the comment's revision from behavior at the reviewed head. Do not present unperformed verification as a verdict.

## Summary Format

Use this structure:

```markdown
# Remote Context

## Timeline
- YYYY-MM-DD: Event, decision, or comment summary. Source: <link or label>

## Review-Relevant Claims
- Claim: ...
  Evidence needed: ...

## Existing Reviewer Requests
- Request: ...
  Status: unresolved | resolved | unclear

## Open Questions
- ...
```

## Review Rules

- Do not treat PR descriptions as truth; convert them into claims.
- Prefer direct source links or stable identifiers over vague summaries.
- Do not include long quotes unless exact wording changes the technical interpretation.
- Keep the packet short enough for downstream review agents to load without losing code context.
