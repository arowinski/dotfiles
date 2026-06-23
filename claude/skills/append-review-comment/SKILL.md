---
name: append-review-comment
description: Add an inline comment to an existing PENDING PR review (or start one if none exists). Use when iteratively drafting a review — read a line, add a comment, keep reading — instead of batching everything at once. Differs from /post-review (which creates a fresh review with all comments via REST in one shot); this skill appends to an in-flight pending review via GraphQL.
argument-hint: [pr-number-or-url] [optional inline comment body]
allowed-tools: Bash(gh api:*), Bash(gh pr view:*), Bash(gh auth status:*), Bash(git:*), Read, Glob, Grep, AskUserQuestion, Skill
---

# Append Review Comment

**You do NOT:** submit the review (`event: APPROVE/REQUEST_CHANGES/COMMENT`), modify other authors' comments, post separate top-level comments. Submission stays a manual action.

## Workflow

### 1. Resolve PR

If $ARGUMENTS contains a PR number or URL, use it. Otherwise:

1. `gh pr view --json number,url,baseRepository -q '"\(.baseRepository.owner.login) \(.baseRepository.name) \(.number)"'`
2. Capture `{owner}`, `{repo}`, PR number from `baseRepository` (not `headRepository`, which is the fork for cross-fork PRs).

### 2. Find or create the pending review

Precondition: `gh` is authenticated as the reviewing user (`gh auth status` shows the right account).

1. Get current user's login: `gh api user --jq .login`
2. List reviews and filter to current user + state PENDING:
   `gh api repos/{owner}/{repo}/pulls/{pr}/reviews --jq '.[] | select(.user.login == "<login>" and .state == "PENDING")'`
3. If a pending review exists, capture its `id` and `node_id`.
4. If none exists, create one:
   `gh api repos/{owner}/{repo}/pulls/{pr}/reviews -X POST` → omit `event` so the review is created PENDING; capture `id` and `node_id` from response. (`-X POST` is required because `gh api` defaults to GET with no body field. A PENDING review has no comments yet.)

### 3. Draft the comment

If the user provided exact text, use it VERBATIM. Do not rewrite, add backticks, or change wording.

If drafting from a finding (e.g., from prior `/review` or `/rr` output), load BOTH:
- `clear-writing` skill — tightens sentences
- `human-writing` skill — strips LLM tells, adds peer voice

Default comment shape (same as `/post-review`):
- **Question first, then one sentence on WHY.** The question is the prompt for the author; the why grounds it in concrete evidence.
- Stop at the why. Do NOT propose solutions, list alternatives, paste analysis paragraphs, run tests inside the comment, or recommend specific code. The reviewer asks; the author decides.
- Pure-question comments (no why) are OK only when the question is unambiguous from the cited code.

### 4. Determine target line(s)

For single-line comment: `path` + `line` (RIGHT side for added/modified, LEFT for deleted).
For multi-line range: also pass `startLine` + `startSide`.

Confirm with user if path/line is ambiguous.

### 5. Preview gate (REQUIRED)

Print the proposed comment:

**Path:** `lib/foo.ex:42` (or range `lib/foo.ex:42-50`)
**Body:** `<full body>`

Then stop. The user replies:
- `post` — submit via GraphQL
- `edit` — user revises body
- `skip` — discard, leave pending review unchanged

Do not POST until the reply is `post`.

### 6. Post via GraphQL

REST `/pulls/{N}/comments` rejects `pull_request_review_id` — must use GraphQL `addPullRequestReviewThread`:

```bash
gh api graphql -f query='
mutation($reviewId: ID!, $path: String!, $line: Int!, $body: String!) {
  addPullRequestReviewThread(input: {
    pullRequestReviewId: $reviewId,
    path: $path,
    line: $line,
    side: RIGHT,
    body: $body
  }) {
    thread { id isResolved }
  }
}' -f reviewId="<node_id>" -f path="<path>" -F line=<n> -f body="<text>"
```

For multi-line range: add `startLine: <n>, startSide: RIGHT` to the input. Example:

```bash
gh api graphql -f query='
mutation($reviewId: ID!, $path: String!, $startLine: Int!, $line: Int!, $body: String!) {
  addPullRequestReviewThread(input: {
    pullRequestReviewId: $reviewId,
    path: $path,
    startLine: $startLine,
    startSide: RIGHT,
    line: $line,
    side: RIGHT,
    body: $body
  }) {
    thread { id isResolved }
  }
}' -f reviewId="<node_id>" -f path="lib/foo.ex" -F startLine=42 -F line=50 -f body="..."
```

Use heredoc / `--input -` if body contains apostrophes or other shell-sensitive chars.

### 7. Stop

End with:

> Comment appended to pending review (#`<review_id>`). Review still PENDING — submit manually via `gh api repos/{owner}/{repo}/pulls/{pr}/reviews/{review_id}/events -f event=COMMENT` (or APPROVE / REQUEST_CHANGES) when ready.

Do not auto-submit. Submission is a manual decision.
