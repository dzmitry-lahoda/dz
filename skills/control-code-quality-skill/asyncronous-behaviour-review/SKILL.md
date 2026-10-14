

# When to use

Want to review or write asyncrous code, async(effect) keyword based, callback based,
manually build around threads/fibers. 

## Desired input

- Existing code domaina and architecture analysis.

## Scope

Consider

- consistenty models, eventual vs immeadite, more strict.

- crashes(aborts) and timeouts behaviour.

## Opinionation

Prefer lock free, contention free, recurisve helping,  fine grained, optimistic, messaging 

over lock based, shared memory syncronization.

## Model

Depending on existing model use or of these:

- TLA+
- Pi calculus
- Communicaiton squances processes
- quinn
- https://lean-lang.org/use-cases/veil/

to model asyncrony


## Chaos

Use local setup with process kills, network degrations to e2e reality.

Check if remote credentials are avaiable to handle and if it was not run on remote CI already.