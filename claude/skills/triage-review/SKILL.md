---
name: triage-review
description: Triage PR review comments, investigate code, recommend actions, apply approved fixes with per-change accept gate, then re-review. Use when responding to PR review feedback. Does NOT post replies, commit, or resolve threads.
allowed-tools: Bash(gh-comments:*), Bash(gh pr view:*), Bash(git diff:*), Bash(git log:*), Bash(git status:*), Read, Glob, Grep, Edit, Write, Agent, AskUserQuestion
---

# Triage Review

Fetch PR review comments, classify them, investigate the code, recommend actions, apply approved fixes per accept gate, then run a code-reviewer pass on the result.

## Workflow

### 1. Fetch comments

`gh-comments <pr-number>` returns three sections: `==CONVERSATION==` (top-level PR thread), `==REVIEWS==` (inline review comments), `==STANDALONE==` (inline, no review). PR number defaults to the current branch's open PR.

### 2. Triage each comment

Classify into one of four buckets:

- **Already-replied** — the comment author or someone else already responded in the thread
- **Already-fixed** — the cited line changed since the comment was posted (check `git log -L` or diff since comment SHA)
- **Stale** — the cited line no longer exists in the current file
- **Actionable** — none of the above

Skip the first three. Investigate only Actionable.

### 3. Investigate each actionable comment

For each:
- Read the cited file and surrounding code
- Run `git diff` or `git log` for code history context
- Form an opinion: reviewer is right, partly right, or wrong

### 4. Categorize the action

Per actionable comment, pick one:

- **Fix** — reviewer is right; apply a code change
- **Push back** — reviewer is wrong or missing context; needs a reply explaining
- **Clarify** — comment is ambiguous; needs a question back to the reviewer

Only **Fix** produces action in this skill. Push back and Clarify are recommendations the user acts on outside it.

### 5. Present the action plan

Show one table:

| # | file:line | reviewer | comment (excerpt) | category | reasoning |
|---|-----------|----------|-------------------|----------|-----------|
| 1 | lib/x.ex:42 | @alice | "should validate input" | fix | input flows from public API; alice is right |
| 2 | lib/y.ex:88 | @bob | "use let_it_be" | push back | already memoized via @cache; bob missed it |

Plus a one-line summary: "X actionable (Y fix, Z push back, W clarify). N already-handled."

### 6. User selects fixes

Use `AskUserQuestion` to pick which Fix items to apply: "all", specific numbers, or "skip".

### 7. Apply each fix with accept gate

For each selected Fix:
1. Show the proposed diff inline
2. Use `AskUserQuestion` with options: Apply / Edit / Skip
3. Apply only on "Apply". On "Edit", take the user's revision and re-show the diff. On "Skip", move on.

Never apply silently. Never batch without per-change confirmation.

### 8. Re-review

After all approved fixes are applied, run the `code-reviewer` agent on the uncommitted diff:

Prompt: "Review these uncommitted changes that were applied in response to PR review feedback. Did the fixes address the reviewers' concerns? Did they introduce new issues? Are there obvious follow-ups?"

Present the agent's output verbatim under a "## Re-review" heading.

### 9. Stop

> Fixes applied and re-reviewed. Push back / clarify items are still open. Decide on replies and commits when ready.

No commit. No reply posting. No thread resolution. The user handles those.
