---
paths:
  - "**/*.rb"
---

# Ruby Patterns

Use operation pattern when implementing the method class. Use monads if available in the project.
Avoid unnecessary initialization for small classes, for big ones try to hide it with `def self.call(...) = new(...).call`
