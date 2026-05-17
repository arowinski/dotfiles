---
name: post-review
description: Posts code-review findings to a GitHub PR as a single review with inline comments. Use when reviewing someone else's PR after /review or /rr produces findings, or when fresh review needs to land on the PR. Comments are phrased as questions, not verdicts.
argument-hint: [pr-number-or-url]
allowed-tools: Bash(gh-comments:*), Bash(gh api:*), Bash(gh pr view:*), Bash(gh pr diff:*), Bash(git diff:*), Bash(git log:*), Read, Glob, Grep, Skill
---

# Post Review

Post code-review findings to a PR as a single review with inline comments.

**You do NOT:** post unsolicited reviews, post separate comment-per-finding, or post without an explicit user "post" confirmation.

## Workflow

### Step 1: Resolve PR

If $ARGUMENTS contains a PR number or URL, use that. Otherwise:

1. `gh pr view <pr-or-empty> --json number,url,baseRepository -q '"\(.baseRepository.owner.login) \(.baseRepository.name) \(.number) \(.url)"'`
2. If no PR is associated with the current branch and no arg given, stop and ask the user which PR

Capture: `{owner}`, `{repo}`, PR number from `baseRepository` (NOT `headRepository` — for cross-fork PRs the head repo is the fork; the review API needs the base repo).

### Step 2: Gather findings

Source priority:

1. If the conversation has prior `/review` or `/rr` output, use those findings as input
2. Otherwise, gather context: `gh pr view <pr>`, `gh pr diff <pr>`, read changed files, then produce findings

For each finding capture: file path, line number on the PR head ref, severity (blocker / major / nit / info), the claim, the suggested change or question.

`/rr` produces structured findings (Claim / Evidence / Reasoning / Severity / Fix). Use Evidence and Reasoning to inform the comment body — they're the raw material for a clear question.

### Step 3: Plausibility check (REQUIRED)

Before drafting any comment, double-check each finding against current state:

1. `gh pr diff <pr>` — confirm the line is actually in the diff and on the side you expect (RIGHT for added/modified, LEFT for deleted)
2. Read the full file at the cited path — confirm the surrounding context doesn't already address the concern
3. Confirm the cited code actually says what the finding claims (no off-by-one, no misread)
4. Drop findings that don't survive this check. False positives erode trust faster than missing comments add value.

### Step 4: Draft each comment as a question

**REQUIRED**: Before drafting any comment text, load the `clear-writing` skill via the Skill tool. Do not draft without it loaded. Apply its principles to every comment body and the review summary. Each comment must:

- Open with a question, not a verdict — "Should this also handle X?", "Is the intent here to swallow Y?", "Would `cast_assoc` fit?"
- Acknowledge uncertainty when relevant — "If this is intentional, ignore.", "Possibly a misread, but..."
- Reference concrete code with backticks; line numbers only when not obvious from inline placement
- Keep to 1–3 sentences unless the rationale genuinely needs more

Avoid imperatives ("you should", "this must"), praise filler ("nice, but..."), and preambles before the question.

### Step 5: Build the review payload

One payload, one POST. Not one POST per comment.

```json
{
  "event": "COMMENT",
  "body": "<optional one-line overall summary, empty if nothing to add>",
  "comments": [
    {"path": "lib/foo.ex", "line": 42, "body": "<question text>"},
    {"path": "lib/bar.ex", "line": 17, "side": "LEFT", "body": "<question text>"}
  ]
}
```

`line` refers to the line on the PR head ref (RIGHT side, default). Set `"side": "LEFT"` only when commenting on a deleted line.

### Step 6: Preview (REQUIRED — STOP HERE)

Print the review in chat in this shape:

**Summary:** `<body or "(none)">`

**Inline comments:**

- `lib/foo.ex:42` — `<full body>`
- `lib/bar.ex:17` (LEFT) — `<full body>`

Then stop. The user replies one of:

- `post` — submit as shown
- `edit` — user revises specific comments or the summary
- `skip` — discard without posting

Do not POST until the reply is `post`.

### Step 7: Post

Pipe the JSON payload via heredoc and extract the review URL:

```bash
gh api repos/{owner}/{repo}/pulls/{pr}/reviews --input - <<'POST_REVIEW_PAYLOAD' | jq -r .html_url
{ "event": "COMMENT", "body": "...", "comments": [...] }
POST_REVIEW_PAYLOAD
```

Use a long, unique heredoc sentinel (`POST_REVIEW_PAYLOAD`) so comment bodies that happen to contain `EOF` don't terminate the heredoc early. Single-quoted (`<<'...'`) prevents shell expansion inside the JSON.

If the API rejects a comment because the line isn't part of the diff: the cited line wasn't changed in this PR. Either remove that comment, move it to a line that was changed, or fall back to a top-level PR comment via `gh api repos/{owner}/{repo}/issues/{pr}/comments` — confirm with the user before falling back.
