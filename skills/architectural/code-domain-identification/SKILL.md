---
name: code-domain-identification
description: Identify a change's software type, domain, feature flow, and supporting components so reviewers can focus on the right risks.
---

# Code domain context

Use the target checkout and the caller's context files. Reuse existing remote, review, and temporal context. Ask the coordinator for missing remote data; do not repeat the same request in every review pass.

## Identify the change

- Classify each changed component as a library, framework, tool, application, service, infrastructure, prototype, SDK, or integration. A change can have more than one type.
- Identify the business or technical domain.
- Find the rules that apply to the change in specifications, documentation, tests, and source.
- Separate documented requirements, observed behavior, and inferred expectations. An inference alone does not prove a bug.

## Map behavior

- Trace the feature from input to output.
- List the components, interfaces, runtime dependencies, and state transitions involved.
- Check interactions with nearby features and shared data.
- Record security, safety, correctness, and liveness requirements.
- State failure behavior and the consequence of breaking each important invariant.
- Mark uncertain assumptions and the evidence needed to resolve them.

## Scope the review

Choose review passes from the mapped risks. Use one focused pass for a simple change. For a complex change, inspect more code or reuse temporal context only when it can change a review decision. Stop when more context will not affect the result.

Honor the coordinator's failure policy. Stop on required missing context or failed access when the policy requires it. Record optional gaps instead of hiding them.

## Output

Write `code-domain-identification.md` in the caller's artifact directory. Include:

- Input artifact paths and reviewed revision.
- Software and domain classifications.
- Feature flow and component relationships.
- Relevant requirements, assumptions, and evidence.
- Risks and review passes selected because of them.

Keep the report short enough for every focused reviewer to read.
