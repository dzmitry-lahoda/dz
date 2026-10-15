---
name: explicit-alloc
description: Use when editing or reviewing performance-sensitive code, Rust ownership paths, APIs, iterators, collections, strings, buffers, clones, boxing, async boundaries, or data transformations where heap allocation, copying, or ownership transfer costs should be visible.
---

# Explicit Allocation

Make allocation and ownership costs visible at the point they matter.

## Guidance

- Prefer APIs that make heap allocation, cloning, boxing, buffering, and collection materialization explicit.
- Avoid hiding allocation behind innocuous helper names when cost matters.
- Prefer borrowing, iterators, slices, views, or caller-provided buffers when they fit existing style and lifetime constraints.
- Use owned values when ownership is semantically required or simplifies a boundary enough to justify the cost.
- Preserve existing allocation strategy in hot paths unless the requested change is about that strategy.
- Check for accidental `clone`, `to_string`, `collect`, `Box`, `Arc`, `Vec`, or format allocation in changed paths.

## Review Checklist

- Confirm new allocations are necessary or intentionally placed at a boundary.
- Confirm lifetimes and borrowing do not make the API harder to use than the allocation cost warrants.
- Confirm error and logging paths do not accidentally affect hot-path allocation.
