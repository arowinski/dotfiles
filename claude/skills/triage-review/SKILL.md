---
name: triage-review
description: Triage PR review comments, investigate code, recommend actions, apply approved fixes with per-change accept gate, then re-review. Use when responding to PR review feedback, when user says "see comments on PR", "checkout to PR, see comments", "PR comments", "check pr/<num>", or pastes a github.com/.../pull/ URL with intent to read comments. Also use on the reviewer side — checking whether the author addressed comments you left: "check if all my comments properly addressed", "see my comments, addressed?", "are comments addressed?", "anything left?", "approvable?", "is the solution acceptable?", "see update to the PR now". Does NOT post replies, commit, resolve threads, or approve.
allowed-tools: Bash(gh-comments:*), Bash(gh pr view:*), Bash(gh pr diff:*), Bash(git diff:*), Bash(git log:*), Bash(git status:*), Read, Glob, Grep, Edit, Write, Agent, AskUserQuestion, Skill
---

# Triage Review

Fetch PR review comments, classify them, investigate the code, recommend actions, apply approved fixes per accept gate, then run a code-reviewer pass on the result.

## Workflow

### 0. Pick the side

- **Author side** — the comments are on my PR and the ask is to act on them. Steps 1–9 below.
- **Reviewer side** — I left the comments and the ask is whether the author addressed them ("are my comments addressed?", "anything left?", "approvable?"). Step 1, then the reviewer-side pass. Skip step 2 — its buckets discard already-replied threads, which is exactly what this side has to verify.

When the PR author is the user, it's author side. Otherwise, filter to the comments the user wrote and go reviewer side.

### 1. Fetch comments

`gh-comments <pr-number>` returns three sections: `==CONVERSATION==` (top-level PR thread), `==REVIEWS==` (inline review comments), `==STANDALONE==` (inline, no review). PR number defaults to the current branch's open PR.

**Reviewer side MUST use `gh-comments --all <pr-number>`.** The default hides resolved threads, and an author who fixes a comment usually resolves it — so the plain call drops exactly the comments that were handled and biases the answer toward "not addressed".

Then check whether HEAD is the PR's head branch (`gh pr view <pr> --json headRefName`, compare against the branch `git status` reports):

- **Author side** — must match. Steps 3 and 7 read and edit files in the working tree, so off the PR branch the already-fixed and stale buckets are wrong and any fix lands on the wrong code. If it doesn't match, stop and tell the user to check the PR out.
- **Reviewer side** — a checkout is nice, not required. Off the branch, work from `gh pr diff` and `gh pr view` and say so in the evidence column; don't read working-tree files and present them as the PR's state.

### 2. Triage each comment

Classify into one of four buckets:

- **Already-replied** — the comment author or someone else already responded in the thread
- **Already-fixed** — the cited line changed since the comment was posted. gh-comments gives no commit SHA, only the `at=` timestamp, which is UTC: `git log --since='<at> UTC' -- <path>`, then read the file. Keep the `UTC` suffix — git reads a bare timestamp as local time and would shift the window by your offset
- **Stale** — the cited line no longer exists in the current file
- **Actionable** — none of the above

Skip the first three. Investigate only Actionable.

### Reviewer-side pass

For each comment the user left, decide the state from the code, not from the thread's tone:

- **Addressed** — the cited code changed and the change answers the concern. Name the commit or the current line that shows it.
- **Partly addressed** — some of the concern is handled, the rest isn't. Say which half is missing.
- **Answered, no change** — the author replied with a reason and no code change was needed. Say whether the reason holds.
- **Not addressed** — nothing moved and nothing was said.

Verify each one against the current head (`git log --oneline <base>..<head>`, `gh pr diff`, read the file). "The author replied 'done'" is not evidence.

Present as a table: `# | file:line | my comment (excerpt) | state | evidence`. The `line` gh-comments prints is the line as of the comment, not now — if the file shifted, give the current line in evidence and keep the original in the column. Then answer the approvability question directly — approve / changes still needed / blocked on a reply — in one line with the reason.

Stop there. This skill never runs `gh pr review --approve`; the user does that. If they ask for reply text, draft it under the reviewer-facing-text rule in step 4.

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

**Reviewer-facing text** — before writing any push-back/clarify reasoning, or any reply draft the user asks for mid-flow, load `Skill(clear-writing)` + `Skill(human-writing)` first: peer voice, question-shaped, no AI tells. This skill still never *posts* — it only drafts the text for the user.

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

An explicit imperative in the reply ("go", "go on", "apply", "do it") is the Apply selection for that one
change — don't re-ask it. The next change gets its own gate; one "go" never covers the rest.

Never apply silently. Never batch without per-change confirmation.

### 8. Re-review

After all approved fixes are applied, run the `code-reviewer` agent on the uncommitted diff:

Prompt: "Review these uncommitted changes that were applied in response to PR review feedback. Did the fixes address the reviewers' concerns? Did they introduce new issues? Are there obvious follow-ups?"

Present the agent's output verbatim under a "## Re-review" heading.

### 9. Stop

> Fixes applied and re-reviewed. Push back / clarify items are still open. Decide on replies and commits when ready.

No commit. No reply posting. No thread resolution. The user handles those.
