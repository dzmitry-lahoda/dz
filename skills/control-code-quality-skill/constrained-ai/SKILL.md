---
name: constrained-ai
description: Use for AI-assisted code changes in this repository, especially Rust work, reviews, pull requests, and tasks with user-authored TODOs or strict editing constraints. Enforces conservative edits, no unintended reversions, no global installs, current-code authority, and repository-specific command discipline.
---

# Constrained AI

Follow the user's repository constraints before editing code.

## Core Rules

- Use the strongest available reasoning model.
- Read relevant `*.md` instructions before changing code.
- Do not install global packages.
- Modify only this repository unless the user explicitly allows another location.
- Estimate broad or expensive requests first. Ask if the work appears too broad, imprecise, or likely to exceed the user's expected cost.
- Treat read-only repository inspection as allowed.
- Do not add new code comments unless the user asks. Move existing comments and doc comments when moving code.
- Do not revert user edits or restore recently deleted code unless the user explicitly requests it.
- Use the current files as authoritative. Treat concurrent user changes as intentional.
- Follow repository `README.md` guidance when present.
- Avoid using git history to infer intent for recently changed code. Use history only for context on code not modified by the user.
- If staged changes are present, treat them as likely approved direction.

## Review

- During review, check `NOTE(agent)` comments and verify changes align with them.

## Pull Requests

- Use branch names containing an `ai/` section when creating PR branches.
- Add `#ai` to PR titles.
- Use a conventional-commit-style PR title that summarizes the change.
- Do not rewrite, rebase, or edit VCS history unless explicitly asked.

## TypeScript

- Run `bun install`, `bun test`, and `bun run build` as needed without asking when the repository uses Bun.

## Rust

- Read relevant Rust modules before editing. If reading a `*.rs` file, read nearby files in the same module and search usages.
- Preserve trait locations. Do not move a trait back to an old crate because history suggests it used to live there.
- Do not replace existing functional code with `panic!`, `todo!`, or `unimplemented!`.
- Preserve existing method receiver shape. Do not add or remove `self` unless required, and explain why if required.
- Ask before relaxing visibility of fields or methods.
- If unsure how to complete a new section, use `unimplemented!("agent: ...")` with the needed guidance.
- Fulfill `todo(agent)` and `todo!("agent...")` instructions before removing them.
- Avoid new `struct` or `enum` definitions unless the user permits them. Prefer extending existing definitions.
- Avoid creating new files when existing files can hold the change cleanly.
- Default Rust check sequence: `cargo check`, then `cargo check --tests`, then `cargo test`.
- Do not run `cargo build` unless explicitly instructed.
- If a cargo command reports any error, do not report full success.
- Use existing newtypes instead of type aliases when available.

## Tests

- Do not make existing tests pass by adding conditional skip logic inside test bodies.
- Modify assertions, setup, and data only when that preserves the test's real validation path.

## `.llm` Files

Treat a `.llm` file as a deterministic generator instruction for a new file or directory. Only the target output may be created or replaced, and no unrelated files may be changed.
