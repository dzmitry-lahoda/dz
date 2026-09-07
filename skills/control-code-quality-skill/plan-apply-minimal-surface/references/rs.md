
- view patter
- splut mut





## Unsafe split

In some cases, for example market and orderbook, we need one part of data to be read-only referenced and other mutable.
We use unsafe code to split such structure as needed.
Some data is marked `!Send + !Sync` to ensure unsafe references don't escape usage scope.
`Hungarian` notaton is `split_` function prefix for these.

## View types

Rust has a well-known problem using methods with disjoint mutable references,
and we use [reference views](https://internals.rust-lang.org/t/notes-on-partial-borrows/20020) solution on our side.

Also I tend to prefer [ECS](https://en.wikipedia.org/wiki/Entity_component_system) `function as system` approach,
because it avoids `&mut self` and helps with partial views (and easy to tune toward data-oriented design as needed).

Also, you may see `overlay` approach which allows to provide raw fields and yet allow them to be impl of traits, 
so that can "override fields" as needed.