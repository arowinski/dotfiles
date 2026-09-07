---
name: doc
description: |
  Write and review Elixir documentation against one standard — `@moduledoc`, `@doc`, `@spec`, `@type`, and doctests.
  TRIGGER (user prompt match): "document this", "add doc", "write moduledoc", "draft moduledoc", "module is missing a doc", "run docs through /doc", "review the docs", "cut fluff from docs", "trim docs", "go over docs/comments", or asks to write/add/generate/review `@moduledoc`/`@doc`.
  SELF-RULE (during code work): invoke proactively when about to create a new `.ex` file with `defmodule` in `lib/`, add `@moduledoc` to a bare-or-`false` file, or add `@doc`/`@spec`/`@typedoc` to a public function. DON'T write inline — stop and invoke.
  For non-Elixir prose, use clear-writing.
allowed-tools: Bash(git diff:*), Read, Glob, Grep, AskUserQuestion, Skill, Edit, Write, mcp__tidewave__get_source_location, mcp__tidewave__get_ecto_schemas
argument-hint: [path to .ex file, or empty if context is clear]
---

# Doc

Docs explain WHY a module exists, who it works with, what's non-obvious, and what real usage looks like.
One standard, both directions: writing means writing to it; reviewing means diffing against it — fix wrong
claims first, delete every sentence that fails the gates.

Core rule: **document only what the code can't say.** If the signature, `schema` block, `use` line, or
function body shows it, MUST NOT restate it in prose. Every sentence MUST add intent, invariant,
collaborator, gotcha, or real usage.

MUST NOT: document private functions, invent fictional examples, write before classifying the module
(step 1), or show a draft without invoking clear-writing (step 6).

Scope: the given file(s). For a branch review, collect changed files via
`git diff origin/main... --name-only` (`.ex`/`.exs` only; swap `origin/main` for the default branch) and run
every touched `@moduledoc`, `@doc`, `@spec`, `@typedoc`, and comment through the workflow.

## Workflow

### 1. Classify the module

Read the target file, match its type:

| signal | type |
|---|---|
| `use SomeApp.Web, :live_view` / `use Phoenix.LiveView` | LiveView |
| `use SomeApp.Web, :controller` | Controller |
| `use Oban.Worker` | Oban worker |
| `use Ecto.Schema` (top-level) | Schema |
| `use Ecto.Schema` + `embedded_schema` | Embedded schema / changeset |
| `use Plug.Builder` / `def call(conn, _)` | Plug |
| `use GenServer` | GenServer |
| `use Supervisor` | Supervisor |
| `use Application` | Application |
| `defprotocol` | Protocol |
| `defimpl` | Protocol implementation |
| `@callback` declarations | Behaviour definition |
| `@behaviour` declaration | Behaviour implementation |
| Top-level facade re-exporting via `defdelegate` | Context module |
| Mix.Task | Mix task |
| None of the above + pure functions | Pure functional / helper |

Verify symbols with `mcp__tidewave__get_source_location` and schema fields with
`mcp__tidewave__get_ecto_schemas` if available; otherwise read directly.

### 2. Short-circuit trivial modules

MUST emit `@moduledoc false` and STOP for: `defimpl` (unless the implementation has surprising semantics),
internal helpers never aliased outside their context, macro-generated modules, tiny (≤10 meaningful lines)
self-explanatory modules. NEVER invent prose for these.

This wins over step 3's sibling-convention rule. Convention decides whether a *construct* inside a documented
module gets `@doc`/`@spec`; it never promotes a trivial module out of `@moduledoc false`.

### 3. Answer four questions before writing

Answer in working memory (not as visible output sections):

1. **WHY, in domain terms?** Not "Oban worker" — "drains the event outbox so downstream systems receive
   published events." One sentence.
2. **Who calls it, what does it call?** Grep `alias <Module>` and `<Module>.`.
3. **What surprising constraint or invariant?** Concurrency, idempotency, irreversible side effects,
   auth/scope assumptions, retry semantics, ordering. None nameable = genuinely simple; move on.
4. **What does real usage look like?** A real snippet from the codebase — config, router line, call site.
   NEVER synthetic placeholders.

Can't answer 1 + 2 → MUST stop and ask the user. NEVER fabricate.

Then check sibling modules (same directory, same role) for convention — convention beats minimalism.
Siblings document a construct → document it and match their wording. No sibling does → adding one is noise.

### 4. Write `@moduledoc` in this order

1. One-sentence summary (ExDoc indexes it; no period if single-clause)
2. 1-3 sentences on WHY in domain terms
3. Mental model / how it fits with collaborators
4. `## <Concept>` H2 per major idea
5. `## Examples` or `## Configuration` with a real snippet

Callouts: plain-caps `IMPORTANT:` / `WARNING:` / `NOTE:`. No `**bold**` in `@moduledoc`/`@doc` — visible
asterisks in source (bold is fine in plain Markdown docs and READMEs).

Length is an outcome, not a target: the fewest sentences that answer the four questions and the per-type
fields. A helper SHOULD be 1-2 sentences; even a context module rarely earns more than ~300 words.
MUST NOT pad toward a length.

Format: hard cap 120 chars/line; break at clause boundaries; rephrase sentences that wrap awkwardly.

### 5. Cover per-type required fields

MUST cover these — woven into prose, not a filled-in form. "Queue: default / Retries: 3" bullets fail;
write "Runs on the `default` queue with 3 attempts." Bullets only for 3+ genuinely parallel items.

- **Context module** — domain ownership, public API (the `defdelegate` surface), submodule map
- **Schema** — entity sentence in domain terms; `@type t` (mandatory); non-obvious config (`@derive`,
  soft-delete, audit hooks, denormalized fields). MUST NOT restate fields — the `schema` block shows them
- **Embedded schema / changeset** — what payload/form it represents; normalization rules (trimming, casing,
  blanks-as-nil); `@type t` + `@spec` on changeset/apply
- **LiveView** — route, `on_mount` hooks (policy, auth), tabs/modes it switches between, non-obvious socket
  state (timers, PubSub, accumulators), URL params. MUST NOT document every assign
- **Oban worker** — queue, `max_attempts`, retry/idempotency contract, side-effect/rollback policy on
  partial failure, unique keys, `## Configuration` with the `config :app, Mod, …` snippet
- **Plug** — what it gates, what it raises or halts on, `## Options` (required + optional), router pipeline
  example, assigns read and written
- **GenServer** — why it's a process (what state or serialization it owns), state shape, registration
  (named singleton vs per-entity), client API vs callback split, crash/restart consequences
- **Protocol** — the contract implementations must satisfy, fail-loud invariants (raise vs default),
  fallback policy (`@fallback_to_any` or explicit "no fallback"), reference implementations
- **Behaviour definition** (declares `@callback`s) — narrative intro, full typical-implementation example,
  one-liner per callback (`@doc` per `@callback` carries the detail), `## Anti-patterns` if relevant
- **Supervisor** — children with one-line purpose each, restart strategy and why, parent supervisor,
  start-arg shape, non-obvious init (dynamic or env-conditional children)
- **Application** — top-level children (the spine), test/dev/prod differences, start phases, non-default
  stop callback, notable `Application.get_env/2` consumers

Types without a bullet (Controller, Mix task, pure helper, behaviour implementation): the universal four
questions suffice. A behaviour *implementation* documents why this implementation exists and what it does
differently — the callback contract belongs in the module that defines it.

### 6. Prose pass — invoke clear-writing

After drafting (steps 4-5 and the per-construct rules below), MUST invoke the clear-writing skill via the
Skill tool — not from memory — and run every drafted sentence through its full checklist. Its rules are inherited, not restated here; skipping the invocation means
skipping the rules.

## Per-construct rules

- **`@doc`** on every public function (unless sibling convention says otherwise): one-sentence active-voice
  summary, then preconditions, returns, edge cases. NEVER on private functions (Elixir warns), NEVER
  restate the signature, NEVER "Returns the X" tautologies.
- **`@spec`** on every public function (unless sibling convention says otherwise): match actual arity,
  honest nil-ability, `@type` aliases for repeated shapes. `any() -> any()` is worse than no spec.
- **`@type t`** on every `defstruct`/`embedded_schema`: fields match exactly, `String.t() | nil` not
  `any()`, `@typedoc` for non-obvious types.
- **Doctests** (`## Examples` with `iex>`) ONLY for pure, deterministic, small functions. NEVER for
  anything touching `Repo`, Oban, PubSub, `DateTime.utc_now`, `:rand`, PIDs/refs, or output over ~5 lines
  — those get plain code blocks with `# => result`.
- **Code comments** MUST state a constraint the code can't show (WHY). Delete WHAT-comments: restated data
  shapes, clause walkthroughs, `# adds two numbers` over `add/2`.

## Quality gates

**Forbidden openings** — MUST rewrite drafts starting with "Module for", "Provides functionality for",
"Helper module that", "Wrapper around", "Contains functions to", "This module". Start with what the module
IS in domain terms.

**Banned content**:

- Anything the reader sees in the code — schema fields, behavior the function name states, the queue name
  on the `use` line, "takes a changeset and returns a tuple" when the `@spec` says so
- Visual/layout description in LiveView docs (visible in the render)
- Implementation details in `@moduledoc` — it documents the contract
- "Used by X" caller lists in `@doc` (grep answers that); collaborators belong in the moduledoc mental
  model only when they explain WHY
- Legacy/migration history, tickets, prior/external system names — unless the constraint is still live
- Bare export lists as the only body
- "See external doc" without an inline summary
- Synthetic examples with fake module names (`MyApp.Foo.bar/1`)
- Test mentions in `@moduledoc`/`@doc`
- Mislabeling a fixture/golden test as a "canary" — a canary runs against a live external system

**Prose style** — every sentence MUST pass clear-writing (loaded at step 6, never applied from memory).
Doc-specific rules:

- Express the idea, not the code. Backtick a symbol only when the reader needs the exact identifier — to
  grep, call, or match it. "Blocks when the limit is reached" beats "uses `block_limit`"
- No "use this from X" advice without a concrete alternative to contrast with — otherwise cut the sentence
- Spell out project-internal abbreviations, keep canonical casing. Industry acronyms (URL, HTTP, SPA) stay;
  lowercase literal file/function names stay as code references

## Verify before emit

MUST check, in order:

1. Every factual claim matches current code — wrong beats fluffy; fix stale claims before style work
2. Every backticked module resolves to a real `defmodule` (Grep)
3. `@spec` arities match; `@type t` fields match the struct/schema
4. Doctests run without setup; no `@doc` on private functions
5. Redundancy pass: per sentence, "does the code already show this?" — delete if yes
6. Prose pass: clear-writing's full checklist, plus idea-not-code and shortest-that-answers

## Preview gate

Show the proposed doc inline; diff for existing docs. MUST get Apply / Edit / Skip via `AskUserQuestion`
before writing — unless the reply is already an explicit imperative ("go", "go on", "apply", "do it"),
which is the Apply selection for that one doc; don't re-ask it. Each further doc gets its own gate.

## Stop

End with the file path and one line on what changed (moduledoc, N @doc, N @spec, N @type). No commit.
