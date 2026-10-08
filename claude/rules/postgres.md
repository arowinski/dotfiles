---
paths:
  - "**/priv/repo/migrations/**"
  - "**/db/migrate/**"
  - "**/db/schema.rb"
---

# Postgres schema and migrations

Index every foreign key column: `create index(:table, [:fk_id])`, `add_index :table, :fk_id` (or `t.references ..., index: true`).
In a 1:1 or 0:1 relation, the FK goes on the entity that can't exist without the other, so the column is `NOT NULL` (every tester has a user → `testers.user_id NOT NULL`); which entity reads as primary doesn't matter.
Soft-deleted tables get partial indexes on live rows: `create index(..., where: "deleted_at IS NULL")`, `add_index ..., where: "deleted_at IS NULL"`.
When a hot query reads a few extra columns, cover them with `INCLUDE` instead of widening the key.
Primary keys follow the repo's configured default (`migration_primary_key`, Rails `primary_key_type`); otherwise `bigint` identities, or UUIDv7 when an ID must be unguessable.
Strings are `text` (`:text`, `t.text`), with a length check constraint when a limit is real.
Timestamps are `timestamptz`: `:utc_datetime_usec` in Ecto, `t.timestamptz` in Rails. Money is `numeric` (`:decimal` with precision and scale).
A migration that drops or rewrites data carries a reversible path (`down`, `reversible`) or a written rollout in the PR: backfill, deploy, then drop.
