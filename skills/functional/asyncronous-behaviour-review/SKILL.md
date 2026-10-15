---
name: asyncronous-behaviour-review
description: Review asynchronous code using async/effect keywords, callbacks, threads, or fibers, focusing on consistency, crashes, and timeouts. Interprocess syncronization.
---

# Asynchronous behaviour review

## Desired input

- Existing code domain and architecture analysis.

## Scope

Consider:

- consistenty models, eventual vs immeadite, more strict.

- crashes(aborts) and timeouts behaviour.

- time and virtual clocks/counters dependant syncronization

## Model

Depending on existing model use or of these:

- TLA+
- Pi calculus
- Communicaiton squances processes
- quinn
- https://lean-lang.org/use-cases/veil/
- codding langauge simplified model

to model asyncrony.

## Chaos

High+ effort

Use local setup with process kills, network degrations to e2e reality if available with contex

Check if remote credentials are avaiable to handle and if it was not run on remote CI already.
