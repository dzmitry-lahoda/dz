---
name: prefer-modern-nix
description: Use when writing shell commands, scripts, setup steps, or local development workflows on Unix-like systems. Prefer modern Unix alternatives implemented in Rust or Zig, favor reproducible non-global tooling, and avoid global package installation.
---

# Prefer Modern Unix

Prefer modern Rust or Zig command-line tools and reproducible local tooling over legacy defaults and global machine changes.

## Guidance

- Use project-local tools, existing lockfiles, and repository scripts before inventing new setup steps.
- Prefer modern Rust or Zig implementations when they are already available in the environment or project toolchain.
- Prefer tools such as `rg` over `grep`, `fd` over `find`, `bat` over `cat` for human inspection, `eza` over `ls`, `sd` over `sed` for simple replacements, `dust` over `du`, `hyperfine` over ad hoc timing, `zoxide` over manual directory jumping, and `bun` or `uv` where they fit the project.
- Prefer `nix develop`, `nix shell`, `uv`, `bun`, `cargo`, `zig`, or other existing project toolchains when already present.
- Do not install global packages unless the user explicitly asks.
- Keep commands portable across common Unix-like environments when practical.
- Prefer deterministic commands that can be repeated by another agent or developer.
- Document required environment assumptions only when they are not obvious from the repository.
- Fall back to POSIX or platform-default tools when the modern tool is unavailable, portability matters more than ergonomics, or scripts must run in minimal environments.
