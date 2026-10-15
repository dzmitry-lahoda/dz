## Rust

- Use `bon` when the project already depends on it, or when many optional fields create unreadable `None` runs.
- Use a plain parameter struct when fields are mostly required.
- Use typed-state builders when construction order or required-field presence matters.
- Prefer direct calls over helper functions that only rename or reorder arguments.
- Collapse enum selector parameters only when a variant maps to a real distinct operation or existing direct branch.
- Partial application through a builder is acceptable when repeated setup is real and call sites become clearer.
