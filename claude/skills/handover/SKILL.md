---
name: handover
description: Write or read a session handover at `<git-common-dir>/claude/handovers/<branch>.md` — the state a fresh session needs to pick the work up. Use on "write a handover", "write the handoff", "prepare a handover", "hand this off", "dump state before we run out of context", and on the read side "read the handover", "read the handoff", "resume from the handover", "where did we leave off on this branch". One file per branch, rewritten in place. Does NOT commit, push, or start implementing.
allowed-tools: Bash(git:*), Bash(mkdir:*), Bash(gh pr view:*), Read, Glob, Grep, Write
argument-hint: [write | read | empty]
---

# Handover

One handover per branch, at `<git-common-dir>/claude/handovers/<branch>.md`. `git rev-parse --git-common-dir` — so every worktree of a repo writes to the same place, and a handover written in `ark-bee` is readable from `ark`.

**You do NOT:** commit, push, or start implementing off the back of a read.

## Which mode

- **Write** — the ask is to record state ("write a handover", "hand this off"), or context is about to run out mid-task.
- **Read** — the ask is to pick work up ("read the handoff", "where did we leave off").

No argument and a handover exists for the current branch → read. No argument, no file → write.

**Reference, don't restate.** Anything already durable — the plan at `claude/plans/<branch>.md`, the ticket, the PR description, a commit message — gets a path or a link, not a copy. A handover that reproduces the plan goes stale the moment the plan changes, and a handover that reproduces the transcript is the thing this skill exists to avoid.

**When not to write one.** If a plan file or a running TODO already holds the state and is current, say so and skip — a second copy of the same state is a source of contradictions, not safety.

## Write

### 1. Collect state

- `git rev-parse --abbrev-ref HEAD`, `git rev-parse --short HEAD`, `git status --porcelain`, `git log --oneline <base>..HEAD`
- `gh pr view --json number,url,state,isDraft` if the branch has a PR
- Read the existing handover if one is there — it is input, not something to preserve verbatim

### 2. Fold the old file forward

Rewrite in place; there is no history to fall back on (`.git/claude/` is untracked, and backup files are banned). So before overwriting, carry forward every item from the old file that is still true, and drop the ones the work has since settled. If an item's status is genuinely unknown, keep it and mark it unknown rather than deleting it.

### 3. Write the file

`mkdir -p` the parent. Sections, in this order:

- **Title** (H1): branch name, plus the ticket ID if there is one
- **State line**: branch, short SHA, PR link/state, and whether the tree is dirty — this is what the read side checks for staleness
- **## Goal**: what this branch is for, 1-3 sentences. Link the plan at `claude/plans/<branch>.md` if one exists instead of restating it
- **## Done**: what is finished and verified, one line each, with the commit or test that proves it
- **## Next**: the immediate next action, first line, concrete enough to start on without re-deriving it. Then anything after it, in order
- **## Ruled out**: approaches tried that didn't work, and decisions already settled with the user — one line each, with the reason. This is the section that stops the next session re-running a failed approach or re-litigating a closed decision, and it is the one most often left out
- **## Open questions**: what genuinely needs the user or a spike. Not a dumping ground for things you didn't check
- **## Gotchas**: environment quirks, flaky tests, non-obvious file relationships. Skip the section when there are none

Facts only. No status-report voice, no "we successfully implemented". A claim in **Done** that isn't backed by a commit or a passing test belongs in **Next**. A section with nothing real to put in it gets left out or marked unknown — a handover padded with plausible-sounding detail is worse than a short one, because the next session acts on it.

If the work pivoted mid-session, rewrite **Goal** to what it became. Don't bend new work into the old framing to keep the sections tidy.

### 4. Report

One line: the path, and the first item under **Next**. Nothing else.

## Read

### 1. Locate

`<git-common-dir>/claude/handovers/<branch>.md`. Missing? Glob the handovers directory and offer the closest match by branch name — then stop and ask. Don't guess between two candidates.

### 2. Check it's still true

Compare the state line against reality: current branch, `git log --oneline` since the recorded SHA, `git status --porcelain`, PR state, and whether the files and paths it references still exist. Anything that moved since the handover was written, say so — commits landed, PR merged, tree now dirty, a cited file gone. A handover that predates several commits is a lead, not a source of truth.

### 3. Report and stop

- **Where we are**: one line, including any drift found in step 2
- **Next**: the recorded next action, adjusted if the drift invalidates it
- **Open questions**: verbatim from the file, with anything the drift has already answered marked as settled

Then stop and wait for a go. Reading a handover is not authorization to start the work in it.
