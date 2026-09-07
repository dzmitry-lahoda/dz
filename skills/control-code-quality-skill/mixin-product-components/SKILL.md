---
name: mixin-product-components
description: Use when organizing product feature components, UI/domain modules, or reusable product logic where shared behavior should be composed through modules and central dispatchers should be extended through focused module entrypoints rather than large inline branches.
---

# Mixin Product Components

Compose product components through modules and keep dispatchers thin.

## Guidance

- Prefer composable product modules over duplicated feature code.
- Extend central dispatchers by delegating to module entrypoints.
- Keep dispatcher branches short and focused on routing, permissions, or orchestration.
- Put product-specific component behavior in the owning feature module.
- Share cross-product helpers only when ownership and reuse are clear.
- Avoid inheritance-style mixins or broad shared component bags that hide product boundaries.
- Keep middleware-facing glue separate from business behavior when that makes tests clearer.

## Checks

- The dispatcher should explain which component handles the request.
- The module should own the implementation details.
- Shared helpers should not depend on one product feature more than the others.
