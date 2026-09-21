---
name: dead-code
description: Find and delete unreferenced code in an Elixir project — one deletion per test run, reverting any that turns the suite red. Use on "dead code", "unused functions / modules / deps", "what can we delete", "leftovers after the X removal". Not for restructuring live code and not for removing a feature that still has callers.
allowed-tools: Bash(mix:*), Bash(MIX_ENV=test mix:*), Bash(git:*), Read, Glob, Grep, Edit
argument-hint: [path or module to sweep, or empty for the whole project]
---

# Dead code

Delete what nothing calls. Every candidate carries evidence; every deletion is proven by a green suite; a red suite reverts the deletion instead of fixing it.

**You do NOT:** refactor live code, add deps or tools, or commit.

## 1. Detect

Scope is the argument, else the whole project. Collect candidates with the command output or empty grep as evidence; a candidate without evidence is not a candidate.

- `mix compile --force --warnings-as-errors` — the compiler names unused private functions, aliases, imports, and variables.
- `mix xref graph --sink lib/<file>.ex` listing only the file itself = orphan module. Public functions have no xref mode: grep `fun_name(`, `.fun_name`, `&Mod.fun_name/`, and the HEEx component forms `<.fun_name` and `<Mod.fun_name` across `lib/`; hits only inside its own module or tests = candidate.
- `mix deps.unlock --check-unused` for lock drift; a dep in `mix.exs` with no module of its app referenced under `lib/` and `config/` = candidate.

The reference grep covers atom and string forms too — `:fun_name`, `"fun_name"` — because that is how dynamic dispatch and `phx-*` event names name things.

## 2. Tier

- **SAFE**: private functions, unreferenced modules that implement no behaviour or protocol, unused aliases and imports, tests that only exercised deleted code.
- **CAUTION**: public functions and modules. Dynamic dispatch hides callers: `apply/3`, `&Mod.fun/n`, `send`/`GenServer` messages, `@behaviour` callbacks, `defimpl`, Oban workers, Phoenix controllers/LiveViews/channels reached from the router. A CAUTION item becomes SAFE only when the greps for its atom, string, and captured forms come back empty.
- **DANGER**: `config/`, `application.ex` children, migrations, seeds, routers, endpoints, Mix tasks. List them; leave them.

## 3. Delete loop

Baseline first: `mix test` green; red baseline stops the sweep.

For each SAFE item, one at a time: Edit out the code plus its `@doc`/`@spec` and the tests that only covered it; run `mix compile --warnings-as-errors` then the suite; green → `git add` the touched files and move on, with any new compiler warning (the alias or import the deletion orphaned) as the next candidate; red → `git restore <files>` (back to the index, the last green state) and record the item as skipped with the failing test. The full suite runs per deletion; when it takes over a minute, run the affected test files per deletion and the full suite once at the end.

Done when every candidate is deleted, skipped with the failure named, or listed under DANGER.

## 4. Report

Deleted (`path` — name), Skipped (item — failing test), Left for you (DANGER, and CAUTION items with a live dynamic reference), lines removed, and the final suite output in the same message.
