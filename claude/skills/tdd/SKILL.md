---
name: tdd
description: Build a feature or change test-first in red-green slices, at seams agreed with the user before any test is written. Use on "TDD", "test-first", "red-green", "write the failing test first", "add a test then make it pass", or when the user wants a new behaviour driven by its tests. Not for diagnosing a bug (debug writes the failing test there) and not for adding tests to code that already exists and works.
allowed-tools: Bash(just:*), Bash(mix:*), Bash(MIX_ENV=* mix:*), Bash(bundle exec rspec:*), Bash(yarn test:*), Bash(yarn run:*), Bash(git:*), Read, Edit, Write, Grep, Glob, AskUserQuestion
argument-hint: [behaviour to build]
---

# TDD

Red, then green, one slice at a time. The rules below make the loop produce tests worth keeping. Apply them on every cycle.

**You do NOT:** write a test at a seam the user hasn't confirmed, hold more than one failing test at a time, refactor inside the loop, or commit.

## Seams first

A **seam** is the public boundary you test at: the function, context, endpoint, or command a caller uses, where behaviour is observable without reaching inside. Before the first test, list the seams you intend to test and confirm them with AskUserQuestion, recommended set first. No test at an unconfirmed seam. Agreeing the seams is how test effort lands on critical paths and real logic instead of every edge.

## What a good test is

A test verifies behaviour through the seam and reads like a spec: `test "user can check out with a valid cart"` says what capability exists and survives a rewrite of the internals. Expected values come from an independent source (a known literal, a worked example, the spec), never recomputed the way the code computes them.

```elixir
# good: behaviour through the public function, literal expectation
test "totals line items" do
  assert Cart.total([%{price: 10}, %{price: 5}]) == 15
end

# bad: reaches past the seam to verify
test "create_user writes a row" do
  Accounts.create_user(%{name: "Alice"})
  assert Repo.get_by(User, name: "Alice")
end
```

```ruby
# good: verifies through the interface
it "makes the user retrievable" do
  user = Accounts.create_user(name: "Alice")
  expect(Accounts.get_user(user.id).name).to eq("Alice")
end
```

## Anti-patterns

- **Implementation-coupled**: mocks internal collaborators, tests private functions, asserts on call counts or order, or verifies through a side channel (querying the table instead of calling the seam). Tell: the test breaks on a refactor that changed no behaviour.
- **Tautological**: the expected value is computed the way the code computes it, so it passes by construction.
- **Horizontal slicing**: all tests first, then all code. Bulk tests pin imagined behaviour and the shape of things. Work vertically: one test, one implementation, repeat, each test shaped by what the last cycle taught you.

## Mocks

Mock only at system boundaries: external APIs, time, randomness, mail. Not your own modules. In Elixir that is a Mox behaviour for the HTTP client, not for the context next door; in Rails, a double for the payment gateway, not for the service object that calls it. Design for it by passing the boundary in (a client argument, an application config key) instead of constructing it inside, and give the boundary one function per operation so each mock returns one shape.

## The loop

1. **Red.** One test at a confirmed seam. Run it (`mix test path:line`, `bundle exec rspec path:line`, or the `just` recipe) and watch it fail for the expected reason. A test that passes before the code exists tests nothing.
2. **Green.** The least code that passes it. No anticipating the next test.
3. **Repeat** at the next slice. Run the touched file's tests each cycle and the suite once at the end.

Refactoring is not in the loop. When green holds, run /simplify or /review, then the user commits.
