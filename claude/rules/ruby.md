---
paths:
  - "**/*.rb"
---

Use operation pattern for single-purpose service classes.
Use monads if available in the project. Chain with bind/fmap/or instead of unwrapping intermediate results.
Avoid unnecessary initialization for small classes, for big ones hide it with `def self.call(...) = new(...).call`
Avoid single-use local variables unless they improve readability — inline the expression instead.
Avoid guard clauses and early returns in the middle of a method — use them at the top or restructure the logic.
Prefer `attr_reader` over direct `@ivar` access — use private readers for ivars from initializer.
When breaking method calls into multiple lines, put each argument on its own line consistently.
