---
paths:
  - "**/*_spec.rb"
---

Test behavior, not implementation. Test public interfaces, never private methods.

Before writing tests:
1. Search for existing test files and factories
2. If factory exists, read it to understand available traits

## Structure

Setup → Exercise → Verify. Separate phases with blank lines. No phase comments.

**For new specs:**
- Define variables inline (`user = build(:user)`), not with `let` or `let!`
- Use named helper methods instead of `before` or `after` hooks
- Context names start with "when" or "with"; nested contexts use "and". Max 2 context levels deep — flatten rather than nest further.
- For classes with a single public method, omit the method describe block

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

## Avoid

- `expect(...).to receive(...)` — use `allow` then `have_received`
- `allow_any_instance_of` — stub specific instances
- `.map` / manual iteration when a matcher like `match_array`, `contain_exactly`, `include`, or `hash_including` would work
