---
name: append-review-comment
description: Add inline comments to a pending (draft) PR review, starting one if needed: "create a draft review", "add to the pending review", "append".
argument-hint: [pr-number-or-url] [optional inline comment body]
allowed-tools: Bash(gh api:*), Bash(gh pr view:*), Bash(gh auth status:*), Bash(git:*), Read, Skill
---

# Append Review Comment

**You do NOT:** submit the review (`event: APPROVE/REQUEST_CHANGES/COMMENT`), modify other authors' comments, post separate top-level comments. Submission stays a manual action.

## Workflow

### 1. Resolve PR

Pass a PR number or URL from $ARGUMENTS; with none, `gh` uses the current branch's PR.

1. `gh pr view <pr-or-empty> --json number,url -q '"\(.url | split("/") | .[3]) \(.url | split("/") | .[4]) \(.number)"'`
2. Capture `{owner}`, `{repo}`, PR number. The PR URL always names the base repo, which the review API needs; `headRepository` is the fork on a cross-fork PR, and `--json` has no `baseRepository` field.

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

If drafting from a finding (e.g., from prior `/review` output), load BOTH:
- `clear-writing` skill: tightens sentences
- `human-writing` skill: strips LLM tells, adds peer voice

Comment shape, kept in sync with `/post-review`'s "Each comment must":

- Default shape: question first, then a sentence on WHY you're asking. The question is the prompt for the author; the why grounds it in concrete evidence so they can engage with the actual concern. Examples:
  - "Should this also handle nil? `customer.plan` is nullable per schema L12, so `.price` would crash."
  - "Could this return `{:error, reason}` instead of `nil`? Caller at `lib/api.ex:88` matches `{:error, _}` and would miss the failure."
  - Pure-question comments (no why) are OK only when the question itself is unambiguous from the cited code.
- The question carries the point itself; a real finding opens with the concrete question, never "intentional?" or "is this deliberate?".
- **Stop at the why.** Do NOT propose solutions, list alternatives, run tests inside the comment, paste analysis paragraphs, or recommend specific code. The reviewer asks; the author decides.
- Acknowledge uncertainty when relevant: "Possibly a misread, but..."
- Reference concrete code with backticks; line numbers only when not obvious from inline placement
- Keep to 1–3 sentences unless the rationale genuinely needs more

Avoid imperatives ("you should", "this must"), praise filler ("nice, but..."), and preambles before the question.

### 4. Determine target line(s)

For single-line comment: `path` + `line` (RIGHT side for added/modified, LEFT for deleted).
For multi-line range: also pass `startLine` + `startSide`.

Confirm with user if path/line is ambiguous.

### 5. Preview gate (REQUIRED)

Print the proposed comment:

**Path:** `lib/foo.ex:42` (or range `lib/foo.ex:42-50`)
**Body:** `<full body>`

Then stop. The user replies:
- `post`: submit via GraphQL
- `edit`: user revises body
- `skip`: discard, leave pending review unchanged

Do not POST until the reply is `post`.

### 6. Post via GraphQL

REST `/pulls/{N}/comments` rejects `pull_request_review_id`, so use GraphQL `addPullRequestReviewThread`:

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

> Comment appended to pending review (#`<review_id>`). Review still PENDING. Submit manually via `gh api repos/{owner}/{repo}/pulls/{pr}/reviews/{review_id}/events -f event=COMMENT` (or APPROVE / REQUEST_CHANGES) when ready.

Do not auto-submit. Submission is a manual decision.
