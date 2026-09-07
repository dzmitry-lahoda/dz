---
name: early-binding-preference
description: Use when choosing between inheritance, dynamic dispatch, virtual tables, trait objects, enums, generics, composition, or closed dispatch in code design and refactoring. Prefer early binding, composition, and closed dispatch when extension requirements do not justify runtime indirection.
---

# Early Binding Preference

Prefer composition and closed dispatch over inheritance and runtime dispatch when the set of variants is known.

## Guidance

- Prefer composition over inheritance-style layering.
- Prefer static or closed dispatch over virtual tables when the implementation set is controlled by the codebase.
- Use enums, generics, direct calls, and feature modules when they keep behavior explicit.
- Use trait objects or runtime dispatch only when dynamic extension, object safety, or boundary abstraction is needed.
- Keep dispatch choices aligned with existing architecture instead of forcing a full rewrite.
