### Fundamental rules

Be brutally honest — if I'm wrong, say so bluntly.

- NEVER attempt to install packages or modify the system.
- Run tests and linters before committing.
- NEVER test private methods.
- NEVER comment out code to make tests pass.

### Skills

You MUST use these skills when applicable:
- commit — when committing changes
- pr — when creating pull requests
- ruby-testing — when writing or modifying Ruby tests

### Patterns

In ruby:

Use operation pattern when implementing the method class. Use monads if available in the project.
Avoid unnecessary initialization for small classes, for big ones try to hide it with `def self.call(...) = new(...).call`
