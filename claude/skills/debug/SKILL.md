---
name: debug
description: Debug a bug from error to root cause to regression test. Use when given a stack trace, traceback, test failure, error message, crash, 500/503, Sentry URL, or "X doesn't work" / "X is broken" report. Also use when user says debug, diagnose, troubleshoot, or investigate.
allowed-tools: Bash(git:*), Bash(dev:*), Bash(rg:*), Bash(grep:*), Bash(mix:*), Bash(MIX_ENV=* mix:*), Bash(bin/spring:*), Bash(yarn test:*), Bash(yarn run:*), Read, Glob, Grep, Edit, Write, Agent, AskUserQuestion, mcp__tidewave__*, mcp__tidewave-web__*, mcp__sentry__*, mcp__atlassian__getJiraIssue
argument-hint: [stack trace, error message, Sentry URL, or bug description]
---

# Debug

Walk a bug from "what's happening" to "fixed and regression-tested" in six phases. Each phase produces evidence; no phase jumps ahead without it.

**You do NOT:** apply fixes without per-change approval, commit, push, or skip phases. The user commits after the regression test passes.

## Don't skip this skill when

- The bug "looks obvious" — obvious bugs still have root causes
- You're under time pressure — guessing produces rework; phases 1-3 are fast
- You already tried a fix and it didn't hold — that's the signal to restart at Phase 1, not try fix #2
- The user says "just" or "quick fix" — those are the cases that produce regressions

## Phase 1: Reproduce

Goal: see the bug happen on demand.

1. Run `dev status` first. If a process is stopped or in a crash loop, investigate it first — likely the cause or a symptom.
2. Capture the error surface: stack trace (paste from user), error message, browser console, or `dev logs <process> 200`. Use `dev logs <process> 500` for more scrollback.
3. If the input is a Sentry URL, fetch the event via `mcp__sentry__*` for stack trace, breadcrumbs, frequency, and recent occurrences.
4. If reproduction steps aren't obvious, ask the user. Don't guess.

Output: a documented reproduction (steps + observed error). Don't proceed without this.

## Phase 2: Isolate

Goal: narrow the bug to a specific code path.

1. Trace the failing call from the stack trace to the offending function. Read those files.
2. Check `git log -n 10 -- <file>` for recent changes that could have introduced the bug.
3. For Phoenix projects, use Tidewave:
   - `mcp__tidewave__get_source_location` to jump to function definitions
   - `mcp__tidewave__get_ecto_schemas` to confirm schema shape matches code assumptions
   - `mcp__tidewave__execute_sql_query` to check actual data state
   - `mcp__tidewave__get_logs` for runtime context
4. Name the suspected area in one sentence: "Bug originates in `lib/x/y.ex:42` when `customer.plan` is nil."

## Phase 3: Hypothesize

Goal: form 1-2 theories with evidence.

Each hypothesis must cite:
- The line(s) of code where the bug occurs
- Why the code produces the observed error (logical chain)
- What conditions trigger it (input state, timing, environment)

Avoid "this might be" without evidence. If you can't form an evidenced hypothesis, return to Phase 2.

## Phase 4: Test hypothesis

Goal: confirm the theory before changing code.

1. Add a failing test that exercises the suspected condition. Use the project's test runner: `mix test path/to/test.exs:line` or `bundle exec rspec path/to/spec.rb:line`.
2. Run the test. Watch it fail with the expected error.
3. If the test passes (no failure), the hypothesis is wrong. Return to Phase 3.

If you can't write a test (integration-only, hard-to-reach state), flag the gap to the user and proceed to Phase 5.

## Phase 5: Fix

Goal: apply the smallest change that makes the failing test pass.

1. Show the proposed diff inline.
2. Use `AskUserQuestion` with options: Apply / Edit / Skip.
3. On Apply, edit the code. On Edit, take the user's revision and re-show the diff.
4. Run the failing test from Phase 4. It must pass.
5. Run nearby tests (same file, same module) to catch regressions.
6. After a dependency or migration fix: `dev restart <process>`.

Never batch fixes. Never apply without confirmation.

## Phase 6: Regression check

Goal: confirm no new breaks.

1. Run a broader test suite if relevant (`mix test`, `bundle exec rspec`, `yarn test`). Scope: the package containing the fix.
2. Re-run `dev status` to confirm no processes crashed during testing.
3. If the bug was in Sentry, note the Sentry issue ID so the user can close it after deploying.

## Stop

> Bug reproduced, isolated, fixed, and regression-tested. The failing test is now passing. Commit when ready.

No commit. No push. No close-Sentry-issue API calls. The user handles those.
