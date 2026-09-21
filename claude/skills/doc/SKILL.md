---
name: doc
description: |
  Write and review Elixir documentation against one standard — `@moduledoc`, `@doc`, `@spec`, `@type`, and doctests.
  TRIGGER (user prompt match): "document this", "add doc", "write moduledoc", "draft moduledoc", "module is missing a doc", "run docs through /doc", "review the docs", "cut fluff from docs", "trim docs", "go over docs/comments", or asks to write/add/generate/review `@moduledoc`/`@doc`.
  SELF-RULE (during code work): invoke proactively after writing a new `.ex` file in `lib/` with `@moduledoc false`, when adding `@moduledoc` to a bare-or-`false` file, or when adding `@doc`/`@spec`/`@typedoc` to a public function. The fork reads the target from disk, so the file must exist first.
  Pass the file path as the argument, or `branch` for a sweep of changed files. Runs in a fresh context and returns drafts to gate.
  For non-Elixir prose, use clear-writing.
argument-hint: [path to .ex file | branch]
context: fork
agent: doc-writer
background: false
---

# Doc

Docs explain WHY a module exists, who it works with, what's non-obvious, and what real usage looks like.
One standard, both directions: writing means writing to it; reviewing means diffing against it — fix wrong
claims first, then delete every sentence that fails the gates.

Core rule: **document only what the code can't say.** If the signature, `schema` block, `use` line, render,
or function body shows it, prose that repeats it is deleted. Every sentence adds intent, invariant,
collaborator, gotcha, or real usage.

Target: `$ARGUMENTS`. A file path runs the workflow on that file. `branch` runs it on every changed
`.ex`/`.exs` file from `git diff origin/main... --name-only` (swap `origin/main` for the default branch),
one file at a time, touched docs and comments only; the report lists every file. Empty target → return a
one-line request for the path instead of guessing.

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

Emit `@moduledoc false` and STOP for: `defimpl` (unless the implementation has surprising semantics),
internal helpers never aliased outside their context, macro-generated modules, tiny (≤10 meaningful lines)
self-explanatory modules. This wins over sibling convention (step 3): convention decides which constructs a
documented module documents; it never promotes a trivial module out of `@moduledoc false`.

### 3. Answer four questions before writing

Answer in working memory (not as visible output sections):

1. **WHY, in domain terms?** Not "Oban worker" — "drains the event outbox so downstream systems receive
   published events." One sentence.
2. **Who calls it, what does it call?** Grep `alias <Module>` and `<Module>.`.
3. **What surprising constraint or invariant?** Concurrency, idempotency, irreversible side effects,
   auth/scope assumptions, retry semantics, ordering. None nameable = genuinely simple; move on.
4. **What does real usage look like?** A real snippet from the codebase — config, router line, call site.
   Never a synthetic placeholder or a fake module name.

Can't answer 1 + 2 → return the questions instead of a draft; a fabricated answer is worse than no draft.

Then match sibling modules (same directory, same role). A construct the siblings document gets documented in
their wording; one they leave bare stays bare. Convention beats minimalism, and it is the only exception to
the per-construct rules in step 6.

### 4. Write `@moduledoc` in this order

1. One-sentence summary (ExDoc indexes it; no period if single-clause)
2. 1-3 sentences on WHY in domain terms
3. Mental model / how it fits with collaborators
4. `## <Concept>` H2 per major idea
5. `## Examples` or `## Configuration` with a real snippet

Callouts: plain-caps `IMPORTANT:` / `WARNING:` / `NOTE:`. No `**bold**` in `@moduledoc`/`@doc` — visible
asterisks in source (bold is fine in plain Markdown docs and READMEs).

Length is an outcome, not a target: the fewest sentences that answer the four questions and the per-type
fields. A helper is 1-2 sentences; even a context module rarely earns more than ~300 words.

Format: hard cap 120 chars/line; break at clause boundaries; rephrase sentences that wrap awkwardly.

### 5. Cover per-type required fields

Read the classified type's section in [`MODULE-TYPES.md`](MODULE-TYPES.md) and weave its fields into the prose, not a
filled-in form. "Queue: default / Retries: 3" bullets fail; write "Runs on the `default` queue with 3
attempts." Bullets only for 3+ genuinely parallel items. Types without a section (Controller, Mix task,
pure helper): the four questions suffice.

### 6. Document each public construct

- **`@doc`** on every public function: one-sentence active-voice summary, then preconditions, returns, edge
  cases. Not on private functions (Elixir warns). No "Returns the X" tautologies.
- **`@spec`** on every public function: match actual arity, honest nil-ability, `@type` aliases for repeated
  shapes. `any() -> any()` is worse than no spec.
- **`@type t`** on every `defstruct`/`embedded_schema`: fields match exactly, `String.t() | nil` not
  `any()`, `@typedoc` for non-obvious types.
- **Doctests** (`## Examples` with `iex>`) only for pure, deterministic, small functions. Anything touching
  `Repo`, Oban, PubSub, `DateTime.utc_now`, `:rand`, PIDs/refs, or output over ~5 lines gets a plain code
  block with `# => result`.
- **Code comments** state a constraint the code can't show (WHY). Delete WHAT-comments: restated data
  shapes, clause walkthroughs, `# adds two numbers` over `add/2`.

### 7. Prose pass — clear-writing

After drafting, run every sentence through the full clear-writing checklist (preloaded in the agent). Its
rules are inherited, not restated here. Doc-specific additions:

- Express the idea, not the code. Backtick a symbol only when the reader needs the exact identifier — to
  grep, call, or match it. "Blocks when the limit is reached" beats "uses `block_limit`"
- Spell out project-internal abbreviations, keep canonical casing. Industry acronyms (URL, HTTP, SPA) stay;
  lowercase literal file/function names stay as code references

### 8. Verify before emit

Check, in order:

1. Every factual claim matches current code — wrong beats fluffy; fix stale claims before style work
2. Every backticked module resolves to a real `defmodule` (Grep)
3. `@spec` arities match; `@type t` fields match the struct/schema
4. Doctests run without setup; no `@doc` on private functions
5. Redundancy pass: per sentence, "does the code already show this?" — delete if yes
6. Quality gates (below): the opening and every sentence pass

### 9. Return

You cannot ask the user and you never write to the file: the main session shows your report, gets
Apply / Edit / Skip per file, and applies. Per file, in order:

1. The draft: a diff for existing docs, the inline block for new ones. `@moduledoc false` is a one-line draft.
2. One line on what changed (moduledoc, N @doc, N @spec, N @type).
3. Every claim you could not verify against the code, named.

End the report with the file list and "Apply / Edit / Skip per file".

## Quality gates

**Forbidden openings** — rewrite drafts starting with "Module for", "Provides functionality for",
"Helper module that", "Wrapper around", "Contains functions to", "This module". Start with what the module
IS in domain terms.

**Banned content**:

- Implementation details in `@moduledoc` — it documents the contract
- "Used by X" caller lists in `@doc` (grep answers that); collaborators belong in the moduledoc mental
  model only when they explain WHY
- Legacy/migration history, tickets, prior/external system names — unless the constraint is still live
- Bare export lists as the only body
- "See external doc" without an inline summary
- "Use this from X" advice without a concrete alternative to contrast with
- Test mentions in `@moduledoc`/`@doc`; a "canary" only when the test runs against a live external system
