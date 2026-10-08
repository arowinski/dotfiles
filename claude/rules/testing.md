---
paths:
  - "**/*_test.exs"
  - "**/*_spec.rb"
  - "**/*.spec.ts"
  - "**/*.spec.tsx"
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.test.js"
  - "**/test_*.py"
  - "**/*_test.py"
---

# Tests

Each test pins one behaviour reachable through the public API (behind a facade, through the facade). Leave out tests for config or allowlist entries an existing test already covers, and library round-trips.
After deleting a branch or threshold, delete the test at its old boundary, even when a bot flags mutation coverage. Test names state the expectation, not the removed condition.
Values asserted from a fake's response are set inline in that test and differ from the fake's defaults.
