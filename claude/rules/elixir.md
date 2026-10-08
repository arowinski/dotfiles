---
paths:
  - "**/*.ex"
---

# Elixir errors

Propagate `{:error, reason}` to a caller that can act on it. A clause that turns an error into `nil`, `[]`, or a default carries the reason with it (a log line with the reason and the input, or an error field on the result) and says why the default is correct.
A `with` gets an `else` only to reshape an error the caller can't use as-is; otherwise `{:error, _}` passes through unchanged.
Rescue the specific exception you expect and handle it; let everything else crash to the supervisor. `rescue _ ->` and `catch _, _ ->` are for process boundaries that report the error.
A logged error either returns `{:error, reason}` too or states in the log line why the caller can continue.
Give every call that can hang a timeout: `Task.await/2` and `Task.yield/2` with an explicit value, HTTP clients with `receive_timeout`, `Repo` calls on large queries with `timeout:`.
Inside `Repo.transaction/2` or an `Ecto.Multi`, a failed step returns `{:error, _}` or calls `Repo.rollback/1`; the transaction's return value reflects the failure.

# Elixir API shape

To add an optional argument, keep the shorter arity delegating with the default; callers never pass `nil` for "not applicable".
`@spec` sits directly on its `def`, no blank line between them.
Workers and hot paths look up entities another context owns and skip or error when one is absent; creating them stays in the owning context.
