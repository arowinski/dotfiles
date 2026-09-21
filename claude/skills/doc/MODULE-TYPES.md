# Per-module-type fields

What each module type's `@moduledoc` covers beyond the four questions. Read only the section for the
classified type; step 5 of `SKILL.md` says how to weave it in.

## Context module

Domain ownership, public API (the `defdelegate` surface), submodule map.

## Schema

Entity sentence in domain terms; `@type t` (mandatory); non-obvious config (`@derive`, soft-delete, audit
hooks, denormalized fields).

## Embedded schema / changeset

What payload/form it represents; normalization rules (trimming, casing, blanks-as-nil); `@type t` +
`@spec` on changeset/apply.

## LiveView

Route, `on_mount` hooks (policy, auth), tabs/modes it switches between, non-obvious socket state (timers,
PubSub, accumulators), URL params. The render shows the assigns and the layout; leave those to it.

## Oban worker

Queue, `max_attempts`, retry/idempotency contract, side-effect/rollback policy on partial failure, unique
keys, `## Configuration` with the `config :app, Mod, …` snippet.

## Plug

What it gates, what it raises or halts on, `## Options` (required + optional), router pipeline example,
assigns read and written.

## GenServer

Why it's a process (what state or serialization it owns), state shape, registration (named singleton vs
per-entity), client API vs callback split, crash/restart consequences.

## Protocol

The contract implementations must satisfy, fail-loud invariants (raise vs default), fallback policy
(`@fallback_to_any` or explicit "no fallback"), reference implementations.

## Behaviour definition

Narrative intro, full typical-implementation example, one-liner per callback (`@doc` per `@callback`
carries the detail), `## Anti-patterns` if relevant.

## Behaviour implementation

Why it exists and what it does differently. The callback contract belongs in the module that defines it.

## Supervisor

Children with one-line purpose each, restart strategy and why, parent supervisor, start-arg shape,
non-obvious init (dynamic or env-conditional children).

## Application

Top-level children (the spine), test/dev/prod differences, start phases, non-default stop callback,
notable `Application.get_env/2` consumers.
