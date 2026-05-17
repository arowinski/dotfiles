---
name: doc
description: Generate Elixir documentation with required structure — `@moduledoc`, `@doc`, `@spec`, `@type`, and doctests. Use when writing module docs for a new or undocumented module, when asked to add/draft/write/generate `@moduledoc` or `@doc`, or when a module is missing its doc. For improving existing prose style, use clear-writing instead.
allowed-tools: Bash(git:*), Bash(rg:*), Read, Glob, Grep, Edit, Write, AskUserQuestion, mcp__tidewave__get_source_location, mcp__tidewave__get_ecto_schemas
argument-hint: [path to .ex file, or empty if context is clear]
---

# Doc

Generate Elixir documentation that explains WHY a module exists, who it works with, what's non-obvious, and what real usage looks like. Refuses to write tautological "Module for X functionality" docs.

**You do NOT:** document private functions, invent fictional examples, or write docs without first classifying the module type.

## Workflow

### 1. Classify the module

Read the target file. Identify its type from these signals:

| signal | type |
|---|---|
| `use SomeApp.Web, :live_view` / `use Phoenix.LiveView` | LiveView |
| `use SomeApp.Web, :controller` | Controller |
| `use Oban.Worker` | Oban worker |
| `use Ecto.Schema` (top-level) | Schema |
| `use Ecto.Schema` + `embedded_schema` | Embedded schema / changeset |
| `use Plug.Builder` / `defmodule ... do def call(conn, _)` | Plug |
| `use GenServer` | GenServer |
| `use Supervisor` | Supervisor |
| `use Application` | Application |
| `defprotocol` | Protocol |
| `defimpl` | Protocol implementation |
| `@behaviour` declaration | Behaviour implementation |
| Top-level facade re-exporting submodules via `defdelegate` | Context module |
| Mix.Task | Mix task |
| None of the above + pure functions | Pure functional / helper |

Use `mcp__tidewave__get_source_location` if available to verify symbols; otherwise read directly.

### 2. Short-circuit for trivial modules

Emit `@moduledoc false` and STOP for:
- Protocol implementations (`defimpl`) unless the implementation has surprising semantics
- Internal helpers used only within the same context, never aliased from outside
- Generated modules (from macros)
- Tiny modules (≤ 10 lines of meaningful code) that are self-explanatory from their name and usage

Don't invent prose for these. `@moduledoc false` is the correct answer.

### 3. Answer four questions before writing

For every other module, answer in working memory (not necessarily as visible sections in the output):

1. **Why does this module exist, in domain terms?** Not "Oban worker" — "drains the event outbox so downstream systems receive published events." One sentence. No "Module for X" / "Provides functionality" openings.
2. **Who calls it, what does it call?** Use `rg "alias <Module>"` and `rg "<Module>\\."` to find callers. Note the major collaborators.
3. **What surprising constraint or invariant must a reader know?** Concurrency rules, idempotency, side effects you can't undo, fail-loud invariants, scope/auth assumptions, retry semantics, ordering. If you can't name one, the module is genuinely simple — note that and move on.
4. **What does real usage look like?** A config snippet, a router pipeline line, an `import` + call, a real function invocation from a caller. Never synthetic placeholders.

If you can't answer 1 + 2, stop and ask the user. Don't fabricate.

### 4. Write `@moduledoc` in this order

Inside the `@moduledoc """ ... """` heredoc, in this order:

- One-sentence summary (ExDoc indexes this — keep tight, no period if single-clause)
- 1-3 sentences on WHY in domain terms
- Mental model / how it fits with collaborators
- `## <Concept>` H2 section per major idea (model, API, operations, ...)
- `## Examples` or `## Configuration` with a real snippet from the codebase
- Use plain-caps callouts (`IMPORTANT:`, `WARNING:`, `NOTE:`) for non-obvious constraints. Drop `**bold**`: visible asterisks in source.
- `## Related modules` with bulleted backticked module names + one-line purpose each

Length: 200-2000 words depending on surface area. Single-purpose helpers can be 1-2 sentences. Context modules and Oban workers usually need 200-500 words.

Format: hard cap at 120 chars per line. Within that, wrap where it reads best — short sentences can stay on one line; longer ones break at clause boundaries. If a sentence runs near or over 120 and reads awkward, rephrase it to read better rather than stretch.

### 5. Apply per-module-type required fields

Different module types need different content. Force these in addition to the universal four:

**Context module** (top-level facade like `MyApp.Accounts`):
- Domain ownership ("Owns customers and their lifecycle in the app")
- Public API list (functions exposed via `defdelegate`)
- Submodule map (which internal modules implement what)

**Schema** (top-level Ecto.Schema):
- Entity sentence in domain terms ("A user of the platform")
- `@type t` (mandatory)
- Non-obvious config: `@derive` for Flop/encoders, soft-delete, audit hooks, denormalized fields
- Don't restate fields prose-style; the `schema` block is self-documenting

**Embedded schema / changeset** (like `Search.Filter`):
- One paragraph: what payload/form it represents
- Normalization rules (trimming, casing, blanks-as-nil)
- `@type t` + `@spec` on changeset/0,1,2 and apply/1

**LiveView**:
- URL / route
- `on_mount` hooks (policy, auth)
- Tabs, modes, or views the LV switches between
- Non-obvious socket state (timers, PubSub subscriptions, accumulators)
- URL params accepted
- Don't document every assign

**Oban worker**:
- Queue name
- `max_attempts`
- Retry / idempotency contract
- Side-effect / rollback policy (what happens on partial failure)
- Unique key constraints
- `## Configuration` block with the `config :app, Mod, …` snippet

**Plug**:
- What it gates (auth, rate limit, request shaping)
- What it raises or halts on
- `## Options` listing required + optional opts
- `## Example` with router pipeline snippet
- Assigns it reads and writes

**Protocol** (`defprotocol`):
- The contract (what implementations must satisfy)
- Fail-loud invariants (raise on unknown vs return default)
- Fallback policy (`@fallback_to_any`, or explicit "no fallback")
- Reference implementations

**Behaviour module** (`@behaviour` declaring callbacks):
- Narrative intro
- Full example showing typical implementation
- Callbacks listed with one-liner each (the actual `@doc` per `@callback` does the heavy lifting)
- `## Anti-patterns` section if relevant

**Supervisor**:
- Children supervised, each with a one-line purpose
- Restart strategy (`:one_for_one` / `:rest_for_one` / `:one_for_all`) and why
- Where it's started from (parent supervisor)
- Start arg shape (`:ok` / config map / etc.)
- Non-obvious init logic (dynamic children, env-conditional children)

**Application** (Mix application module):
- Top-level supervisor children — the spine of the app
- Environment-specific differences (test vs dev vs prod)
- Start phases (if used)
- Stop callback (if non-default)
- Mix application env (`Application.get_env/2` consumers worth noting)

## Per-construct rules

### `@doc` per public function

Every public function gets `@doc`:
- First line: one-sentence summary in active voice
- Then: preconditions, returns, edge cases
- `## Examples` block when the function is pure and a doctest would compile

Never:
- `@doc` on private functions (Elixir warns)
- Restate the function signature in prose
- Generic "Returns the X" tautologies

### `@spec` per public function

Every public function gets `@spec`:
- Match actual arity
- Reflect nil-ability honestly
- Avoid ceremonial `any() -> any()` — that's worse than no spec
- Use `@type` aliases for repeated shapes

### `@type t` per struct

Every `defstruct` or `embedded_schema` gets `@type t`:
- Match struct fields exactly
- Use `String.t() | nil` not `any()` for optional fields
- `@typedoc` for non-obvious types

### Doctests

Add `## Examples` with `iex>` doctests ONLY when:
- Function is pure (no DB, no PubSub, no Oban, no time, no PIDs)
- Output is deterministic
- Example is small and obvious

Never doctest:
- Anything touching `Repo`, `Oban`, `Phoenix.PubSub`, `DateTime.utc_now`, `:rand`
- Functions that return PIDs or refs
- Output longer than ~5 lines (use plain code blocks instead)

For context/worker/LiveView/plug functions, use plain code blocks with `# => result` comments.

## Quality gates

### Forbidden openings

Reject and rewrite if the draft starts with:
- "Module for ..."
- "Provides functionality for ..."
- "Helper module that ..."
- "Wrapper around ..."
- "Contains functions to ..."
- "This module ..."

Start with what the module IS in domain terms.

### Banned content

- Bare lists of exports as the only body (the `Audit` failure mode — looks like documentation, isn't)
- "See external doc" without an inline summary
- Synthetic examples with fake module names (`MyApp.Foo.bar/1`)
- Comments stating the obvious (`# adds two numbers` over `add/2`)

### Verify before emit

Before showing the doc to the user:
- Every backticked module reference resolves to a real module (`rg "defmodule <Name>"`)
- `@spec` arities match the actual function arities
- `@type t` fields match `defstruct` or `schema` fields
- Doctests can run without setup
- No private functions have `@doc` (Elixir will warn)

## Preview gate

Show the proposed doc inline. Use `AskUserQuestion` with Apply / Edit / Skip before writing to the file.

## Stop

End with the file path of the modified module and a one-line note on what was added (moduledoc, N @doc, N @spec, N @type). No commit.
