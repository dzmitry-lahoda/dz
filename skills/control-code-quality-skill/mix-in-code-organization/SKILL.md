---
name: mix-in-code-organization
description: Use when organizing, refactoring, or reviewing feature code where central dispatchers, root enums, product components, middleware, or domain behavior are becoming too large or mixed together. Guides Codex to keep dispatch central while moving implementation into feature-owned modules.
---

# Mix-In Code Organization

Keep central dispatch stable and move feature implementation into modules.

## Goal

Use feature modules for large domain features while preserving central dispatch where it belongs.

Central dispatch files may own enum matching and orchestration. Branch implementations, domain types, math, algorithms, product components, middleware details, and helper logic should live under feature-owned modules.

## Pattern

- Keep root dispatchers focused on matching variants and calling module entrypoints.
- Extend central dispatch through modules instead of adding large inline branches.
- Put feature-specific types near the feature.
- Keep public feature APIs near the module root or in clearly named files.
- Move private helpers deeper into nested submodules, or keep them private to the file that uses them.
- Keep shared enums and cross-feature types in shared or root files until ownership is clear.

## Guidelines

- Split files when it reduces merge conflicts, review burden, or context size.
- Keep small feature APIs in one file until splitting has a clear benefit.
- Move doc comments and relevant notes with moved code.
- Preserve existing visibility unless a narrower or equally scoped module API already exists.
- Avoid forcing a rigid layout across all features at once. Apply the pattern to new or heavily changed areas first.
