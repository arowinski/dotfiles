---
name: commit
description: Use when the user wants their working-tree changes recorded in git history — "commit this", "save/snapshot this to git", "write a commit message", "amend the last commit", "absorb these fixups into the right commits", or "stage these files and write it up". Covers picking what to stage, splitting unrelated changes into separate commits, and writing a subject (and body) that matches the repo's existing log style. Trigger on staging-plus-describe requests even when the word "commit" never appears, and even when the user says not to push. Do not use for other git work that leaves the commit itself alone: pushing, opening PRs, rebasing or squashing existing commits, cherry-picking, stashing, or just showing a diff or status.
allowed-tools: Bash(git-commit-context:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git absorb:*), Read
---

# Commit

## Workflow

1. **Read the context.** `git-commit-context` returns status, diffs, and the last 10 subjects in one call. Treat the log as the style spec — prefix convention, subject shape, whether bodies are normal here. A commit that reads like the ones above it keeps `git log` scannable months later.
2. **Check the gate.** Formatter applied, pre-commit tests/lint green. If the gate failed, stop and report; a broken commit costs more to unpick than to not make.
3. **Split, then stage.** See below. Do this before touching `git add`.
4. **Consider amend or absorb** — ask first:
   - Last commit unpushed and this change belongs to it? Amend.
   - Change fixes a specific earlier commit on the branch? `git absorb --and-rebase`.

## Splitting

One commit, one intent. Someone reading the subject and then the diff should find nothing the subject didn't promise.

If the index already holds one coherent intent, that is the user's split: commit exactly it and add nothing.

Staging is not always a decision, though. A staged deletion whose replacement sits untracked beside it is one rename arriving in two halves, and committing the deletion alone leaves a dangling reference. Finish the intent instead of asking which half was meant.

Otherwise group the changed paths by intent before staging anything. A bug fix, a rename, a new feature, and a config bump are four commits even when they came out of one editing session — they get reverted, cherry-picked, and bisected independently. Then work one at a time: stage that group's paths, commit, move to the next. Never stage everything and write one subject that strings intents together with "and" — that conjunction is the tell that step 3 got skipped.

Order the commits so each one builds on its own: the refactor lands before the feature that uses it.

Ask only when two intents genuinely overlap inside one file and the diff can't settle which lines belong to which — interactive staging isn't available here, so guessing splits the wrong way silently. Everywhere else the diff answers it: finish the work and say how you grouped it.

## Message

The subject names the change at the altitude a reader scanning the log needs. The diff already carries the detail — the subject shouldn't restate it, and the body (when there is one) covers what the diff can't show: why this was needed, what it breaks, what a reader would otherwise misread.

Add a body only when the reasoning isn't recoverable from the diff — a non-obvious constraint, a breaking change, a migration step, or why the obvious alternative lost. Skip it when the subject already says everything.

**Too vague — describes the process, not the change:**
`Fix issues`, `Address review feedback`, `Update based on suggestions`
=> `Reject empty tokens in session lookup`

**Restates the diff:**
`Change timeout from 5 to 30 in uploader.rb`
=> `Raise upload timeout to 30s`, body: 5s cut off multipart uploads over ~20MB on slow links.

**Names the file, not the change:**
`Update parser.ex`
=> `Treat trailing commas as valid in list literals`

## Rules

- First line max 80 chars, imperative mood, plain ASCII — no Unicode (arrows `->`, use "to" or `>`).
- Copy the log's prefix convention; never invent one. If subjects there read `Claude - ...` or `feat(auth): ...`, match that. If they carry no prefix, add none.
- Never mention tests unless tests are the change.
- Never add ticket prefixes (`JIRA-123`, `GH-456`) or provenance suffixes ("per review", "after retro") — the change stands on its own; where it came from belongs in the PR.
- Never put unrelated changes in one commit.
