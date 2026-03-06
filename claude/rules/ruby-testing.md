---
globs: "**/*_spec.rb"
---

# Ruby/RSpec Testing Conventions

## Core Principles

- Test behavior, not implementation. Focus on WHAT the code does, not HOW.
- Test public interfaces and observable outcomes. **NEVER test private methods.**

## Workflow

Before writing tests:
1. Search for existing test files: `rg "describe.*ClassName" spec/`
2. Search for existing factories: `rg "factory.*:model_name" spec/factories/`
3. If factory exists, read it to understand available traits

## Test Structure

Setup → Exercise → Verify. Separate phases with blank lines. No phase comments.

**For new specs:**
- **NO `let` or `let!`** — define variables directly: `user = build(:user)`
- **NO `before` or `after` hooks** — use named helper methods instead
- context naming: start with "when" or "with", nested with "and", max 2 levels deep
- For classes with only `#call` or `.call`, omit the method describe block

**For existing specs:**
- Follow the existing file's patterns (`let`, `before`, etc. are okay if already used)

## FactoryBot

- **Prefer `build`** (no DB) as default
- **Use `build_stubbed`** when you need id/timestamps without DB
- **Use `create` only** when DB persistence is required (queries, counting, uniqueness)
- Use traits when available. Use only relevant attributes.

## Assertions

**For data store changes**, wrap in lambda:
```ruby
action = -> { MyService.call(user) }
expect(&action).to change(User, :count).by(1)
```

**For verifying method calls — stub then verify:**
```ruby
allow(UserCreator).to receive(:create)
MyService.call
expect(UserCreator).to have_received(:create).with(email: "test@example.com")
```

## Anti-Patterns (NEVER use)

- `expect(...).to receive(...)` — use `allow` then `have_received`
- `allow_any_instance_of` — stub specific instances
- Testing private methods
- Phase comments (setup/exercise/verify should be obvious from structure)
