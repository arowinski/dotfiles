---
name: doc
description: |
  Write and review Elixir documentation against one standard — `@moduledoc`, `@doc`, `@spec`, `@type`, and doctests.
  TRIGGER (user prompt match): "document this", "add doc", "write moduledoc", "draft moduledoc", "module is missing a doc", "run docs through /doc", "review the docs", "cut fluff from docs", "trim docs", "go over docs/comments", or asks to write/add/generate/review `@moduledoc`/`@doc`.
  SELF-RULE (during code work): invoke proactively when about to create a new `.ex` file with `defmodule` in `lib/`, add `@moduledoc` to a bare-or-`false` file, or add `@doc`/`@spec`/`@typedoc` to a public function. DON'T write inline — stop and invoke.
  For non-Elixir prose, use clear-writing.
allowed-tools: Bash(git:*), Read, Glob, Grep, AskUserQuestion, Skill, Edit, Write, mcp__tidewave__get_source_location, mcp__tidewave__get_ecto_schemas
argument-hint: [path to .ex file, or empty if context is clear]
---

# Doc

Documentation explains WHY a module exists, who it works with, what's non-obvious, and what real usage looks like. One standard, applied in both directions: writing docs means writing to it; reviewing existing docs means diffing them against it — run the same workflow, fix wrong claims first, delete every sentence that fails the gates.

Core principle: **document only what the code can't say.** If a reader sees it by glancing at the signature, the `schema` block, the `use` line, or the function body, don't write it in prose. Every sentence must add something the code doesn't show: intent, invariant, collaborator, gotcha, or real usage.

**You do NOT:** document private functions, invent fictional examples, or write docs without first classifying the module type.

Scope: the given file(s). When asked to go over the branch's docs, collect changed files via
`git diff $(git merge-base HEAD origin/main)... --name-only` (`.ex`/`.exs` only; swap `origin/main` for the
repo's default branch) and run every touched `@moduledoc`, `@doc`, `@typedoc`, and code comment through the
workflow.

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
2. **Who calls it, what does it call?** Grep for `alias <Module>` and `<Module>.` to find callers. Note the major collaborators.
3. **What surprising constraint or invariant must a reader know?** Concurrency rules, idempotency, side effects you can't undo, fail-loud invariants, scope/auth assumptions, retry semantics, ordering. If you can't name one, the module is genuinely simple — note that and move on.
4. **What does real usage look like?** A config snippet, a router pipeline line, an `import` + call, a real function invocation from a caller. Never synthetic placeholders.

If you can't answer 1 + 2, stop and ask the user. Don't fabricate.

Then check sibling modules (same directory, same role — other wizard steps, other workers) for convention:
whether they carry `@moduledoc`/`@doc`/`@spec` on the same constructs, and how they phrase them. Convention
beats minimalism — if siblings consistently document a function, document (or keep) it and align wording to
theirs; if no sibling documents it, adding one is noise, not a gap to backfill.

### 4. Write `@moduledoc` in this order

Inside the `@moduledoc """ ... """` heredoc, in this order:

- One-sentence summary (ExDoc indexes this — keep tight, no period if single-clause)
- 1-3 sentences on WHY in domain terms
- Mental model / how it fits with collaborators
- `## <Concept>` H2 section per major idea (model, API, operations, ...)
- `## Examples` or `## Configuration` with a real snippet from the codebase
- Use plain-caps callouts (`IMPORTANT:`, `WARNING:`, `NOTE:`) for non-obvious constraints. Drop `**bold**`: visible asterisks in source. (This is for `@moduledoc`/`@doc`; bold for emphasis is fine in plain Markdown docs and READMEs, don't flag it there.)

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

Every public function gets `@doc` (unless sibling convention says otherwise — step 3):
- First line: one-sentence summary in active voice
- Then: preconditions, returns, edge cases
- `## Examples` block when the function is pure and a doctest would compile

Never:
- `@doc` on private functions (Elixir warns)
- Restate the function signature in prose
- Generic "Returns the X" tautologies

### `@spec` per public function

Every public function gets `@spec` (unless sibling convention says otherwise — step 3):
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

### Code comments

A comment earns its place only by stating a constraint the code can't show (WHY). Comments explaining WHAT
the code does get deleted — the non-obvious test applies to comments exactly as to docs. Typical offenders:
restating a data shape, walking through function clauses, `# adds two numbers` over `add/2`.

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

- Anything the reader sees in the code itself — field lists the `schema` block shows, behavior the function
  name states, the queue name when it's on the `use Oban.Worker` line two lines down, "takes a changeset and
  returns a tuple" when the `@spec` says exactly that. The per-type rules above ("don't restate fields",
  "don't document every assign") are instances of this; apply it to every module type
- Visual/layout description in LiveView docs (dividers, cards, headings — all visible in the render)
- Implementation details in `@moduledoc` — it documents the contract; the body documents itself
- "Used by X" / caller-enumeration notes in `@doc` (grep answers that); collaborators belong in the
  moduledoc's mental-model sentence only when they explain WHY
- Legacy/migration history, ticket references, names of prior or external systems (Zephyr, TestRail) —
  unless the constraint they explain is still live
- Bare lists of exports as the only body (the `Audit` failure mode — looks like documentation, isn't)
- "See external doc" without an inline summary
- Synthetic examples with fake module names (`MyApp.Foo.bar/1`)
- Test mentions in `@moduledoc`/`@doc` — a test-file reference isn't the module's contract
- Mislabeling a fixture/golden test as a "canary" — a canary runs against a live external system; a test pinning hardcoded fixtures proves output matches a reference, it can't detect upstream change

### Prose style

Every sentence of generated doc must pass clear-writing's rules: active voice, the de-AI vocabulary banlist,
copula hiding, filler, hedging, no em dashes. Invoke the clear-writing skill for the full checklist rather
than restating its word-list here. The rule specific to docs:

- Express the idea, not the code. A doc reads like prose, not like the source restated in backticks. Inline a
  symbol only when the reader needs the exact identifier — to grep it, call it, or match a signature; otherwise
  it's noise that's harder to read. "Blocks when the limit is reached" beats "uses `block_limit`" — name the
  behavior, not the variable
- No hand-wavy "use this from X" advice unless it names a concrete alternative to contrast with; otherwise cut
  the sentence (it looks authoritative but answers no question)
- Spell out project-internal abbreviations in prose and keep canonical casing. Industry acronyms (URL, HTTP,
  SPA) stay; lowercase forms that are literal file or function names stay as code references

### Verify before emit

Before showing the doc to the user:
- Every factual claim (referenced behavior, constraints, collaborators) matches the current code — wrong
  beats fluffy as a problem; fix stale claims before style work
- Every backticked module reference resolves to a real `defmodule <Name>` (Grep)
- `@spec` arities match the actual function arities
- `@type t` fields match `defstruct` or `schema` fields
- Doctests can run without setup
- No private functions have `@doc` (Elixir will warn)
- Redundancy pass: for each sentence, ask "does the code already show this?" — delete it if yes
- Prose pass: scan for banned vocabulary, copula hiding, filler, and em dashes (clear-writing's de-AI checklist)

## Preview gate

Show the proposed doc inline; for changes to existing docs, show a per-file diff. Use `AskUserQuestion` with Apply / Edit / Skip before writing to the file.

## Stop

End with the file path of the modified module and a one-line note on what was added or trimmed (moduledoc, N @doc, N @spec, N @type). No commit.
