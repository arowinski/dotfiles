---
name: triage-review
description: Triage PR review comments, investigate code, recommend actions, apply approved fixes with per-change accept gate, then re-review. Use when responding to PR review feedback, when user says "see comments on PR", "checkout to PR, see comments", "PR comments", "check pr/<num>", or pastes a github.com/.../pull/ URL with intent to read comments. Also use on the reviewer side — checking whether the author addressed comments you left: "check if all my comments properly addressed", "see my comments, addressed?", "are comments addressed?", "anything left?", "approvable?", "is the solution acceptable?", "see update to the PR now". Does NOT post replies, commit, resolve threads, or approve.
allowed-tools: Bash(gh-comments:*), Bash(gh pr view:*), Bash(gh pr diff:*), Bash(git diff:*), Bash(git log:*), Bash(git status:*), Read, Edit, Write, Agent, AskUserQuestion, Skill
---

# Triage Review

Fetch PR review comments, classify them, investigate the code, recommend actions, apply approved fixes per accept gate, then run a re-review pass on the result.

## Workflow

### 0. Pick the side

- **Author side**: the comments are on my PR and the ask is to act on them. Steps 1–9 below.
- **Reviewer side**: I left the comments and the ask is whether the author addressed them ("are my comments addressed?", "anything left?", "approvable?"). Step 1, then the reviewer-side pass. Skip steps 2–9; the reviewer-side pass buckets by its own states.

When the PR author is the user, it's author side. Otherwise, filter to the comments the user wrote and go reviewer side.

### 1. Fetch comments

`gh-comments <pr-number>` returns three sections: `==CONVERSATION==` (top-level PR thread), `==REVIEWS==` (inline review comments), `==STANDALONE==` (inline, no review). PR number defaults to the current branch's open PR.

**Reviewer side MUST use `gh-comments --all <pr-number>`.** The default hides resolved threads, and an author who fixes a comment usually resolves it, so the plain call drops exactly the comments that were handled and biases the answer toward "not addressed".

Then check whether HEAD is the PR's head branch (`gh pr view <pr> --json headRefName`, compare against the branch `git status` reports):

- **Author side**: must match. Steps 3 and 7 read and edit files in the working tree, so off the PR branch the already-fixed and stale buckets are wrong and any fix lands on the wrong code. If it doesn't match, stop and tell the user to check the PR out.
- **Reviewer side**: a checkout is nice, not required. Off the branch, work from `gh pr diff` and `gh pr view` and say so in the evidence column; don't read working-tree files and present them as the PR's state.

### 2. Triage each comment

Classify into one of four buckets:

- **Already-replied**: the comment author or someone else already responded in the thread
- **Already-fixed**: the cited line changed since the comment was posted. gh-comments gives no commit SHA, only the `at=` timestamp, which is UTC: `git log --since='<at> UTC' -- <path>`, then read the file. Keep the `UTC` suffix; git reads a bare timestamp as local time and would shift the window by your offset
- **Stale**: the cited line no longer exists in the current file
- **Actionable**: none of the above

Drop Stale. The other three go to step 3: a reply or a later change is a claim to verify, not a reason to skip.

### Reviewer-side pass

For each comment the user left, decide the state from the code, not from the thread's tone:

- **Addressed**: the cited code changed and the change answers the concern. Name the commit or the current line that shows it.
- **Partly addressed**: some of the concern is handled, the rest isn't. Say which half is missing.
- **Answered, no change**: the author replied with a reason and no code change was needed. Say whether the reason holds.
- **Not addressed**: nothing moved and nothing was said.

Verify each one against the current head (`git log --oneline <base>..<head>`, `gh pr diff`, read the file). "The author replied 'done'" is not evidence.

Present as a table: `# | file:line | my comment (excerpt) | state | evidence`. The `line` gh-comments prints is the line as of the comment, not now; if the file shifted, give the current line in evidence and keep the original in the column. Then answer the approvability question directly (approve / changes still needed / blocked on a reply) in one line with the reason.

Stop there. The verdict is the deliverable. Submit only when the user's whole reply is the command ("approve", "approve it", "submit"): run `gh pr review <pr> --approve` with no body and no extra chat confirmation, and re-issue it unchanged if the gate hook bounces the first call. Any qualifier or opinion ("meh approve, let's trust", "looks approvable", "ok approve") makes it their verdict, and the turn ends. If they ask for reply text, draft it under the reviewer-facing-text rule in step 4.

### 3. Verify each comment

Settle inline the comments whose text is its own evidence: typo, naming, wording. Send the rest to one `review-specialist` agent. Its prompt carries the repo path, the PR base and head, and per comment its bucket, author, `path:line`, full text, `at=` timestamp, and any replies, plus this angle:

"Verification of PR review comments at the current head. Return one verdict per comment you were given, in place of the findings format: a comment the reviewer got wrong carries its evidence too, since that evidence is the push-back. Actionable: is the reviewer's claim true (right, partly right, or wrong). Already-fixed: does the change since `at=` answer the concern (addressed, partly, or not). Already-replied: does the reply's reasoning hold (holds or not). Read the cited code, its callers, and the history of the lines; settle a runtime claim with a read-only command (test, eval) rather than by reading. Evidence per verdict: `path:line`, or the command and its output. Non-scope: defects no comment raises."

Done when every non-stale comment has a verdict with evidence. Already-fixed that's addressed and already-replied that holds count as handled; the rest go to step 4 as actionable.

### 4. Categorize the action

Per actionable comment, pick one:

- **Fix**: reviewer is right; apply a code change
- **Push back**: reviewer is wrong or missing context; needs a reply explaining. Its reasoning cites evidence: a run (eval, test, schema dump) for a runtime claim, the `path:line` read otherwise
- **Clarify**: comment is ambiguous; needs a question back to the reviewer

Only **Fix** produces action in this skill. Push back and Clarify are recommendations the user acts on outside it.

**Reviewer-facing text**: before writing any push-back/clarify reasoning, or any reply draft the user asks for mid-flow, load `Skill(clear-writing)` + `Skill(human-writing)` first, for peer voice, question-shaped wording, no AI tells. This skill never posts replies or comments; it only drafts the text for the user. Reply text the user supplies is used verbatim. Replies live inside inline threads; a point with no thread gets its answer in chat, never as a top-level PR comment.

### 5. Present the action plan

Show one table:

| # | file:line | reviewer | comment (excerpt) | category | reasoning |
|---|-----------|----------|-------------------|----------|-----------|
| 1 | lib/x.ex:42 | @alice | "should validate input" | fix | input flows from public API; alice is right |
| 2 | lib/y.ex:88 | @bob | "use let_it_be" | push back | already memoized via @cache; bob missed it |

Plus a one-line summary: "X actionable (Y fix, Z push back, W clarify). N verified handled, S stale."

### 6. User selects fixes

Ask in prose which Fix items to apply: "all", specific numbers, or "skip".

### 7. Apply each fix with accept gate

For each selected Fix:
1. Show the proposed diff inline
2. Ask in prose: apply, edit, or skip
3. Apply only on "Apply". On "Edit", take the user's revision and re-show the diff. On "Skip", move on.

An explicit imperative or assent in the reply ("go", "go on", "ok", "apply", "do it") is the Apply selection for that one
change; don't re-ask it. The next change gets its own gate; one "go" never covers the rest.

Never apply silently. Never batch without per-change confirmation.

### 8. Re-review

A next step the user already named ("when done amend, rebase") replaces this step and step 9: go straight to it once the fixes are applied.

After all approved fixes are applied, run the `review-specialist` agent on the uncommitted diff. Its prompt carries the repo path, the comments the fixes answer (author, `path:line`, text, and the fix you applied for each), and this angle:

"Re-review of fixes made in response to PR review comments. For each comment, does the diff address the concern it raises; one that is only partly addressed or answered by a different change is a finding. Then, only in lines the diff changes, any new defect the fixes introduced. Non-scope: code the diff leaves untouched, and comments marked push back or clarify."

Present the agent's output verbatim under a "## Re-review" heading.

### 9. Stop

> Fixes applied and re-reviewed. Push back / clarify items are still open. Decide on replies and commits when ready.

No commit. No reply posting. No thread resolution. The user handles those.
