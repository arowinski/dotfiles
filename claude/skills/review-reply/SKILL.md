---
name: review-reply
description: Reads PR review comments and helps draft and post replies. Use when replying to PR review feedback.
allowed-tools: Bash(gh-comments:*), Bash(gh api:*), Bash(git diff:*), Bash(git log:*), Bash(git remote:*), Read, Glob, Grep, AskUserQuestion
---

# Reply to Review

Read PR review comments, draft replies, and post them after user approval.

## Workflow

### Step 1: Fetch Comments

1. Run `gh-comments <pr-number>` to fetch all comments
2. Identify unresolved threads and inline review comments
3. Show a summary: author, file/line, short excerpt of each comment

### Step 2: Select Comments to Reply To

Use AskUserQuestion to ask which comments to address:
- "All" — reply to every unresolved comment
- Let user pick specific ones

### Step 3: Understand Context

For each selected comment:
1. Read the relevant file and surrounding code
2. Run `git diff` or `git log` if needed to understand what changed and why
3. Understand the reviewer's point before drafting

### Step 4: Draft Reply

Write replies that sound like a competent engineer talking to a peer.

**Tone:**
- Natural and conversational — not robotic or overly formal
- Acknowledge valid points directly ("Good catch", "Yeah, you're right")
- When disagreeing, lead with context not contradiction
- No filler phrases ("Great question!", "Thanks for the feedback!")
- Match the reviewer's tone and level of formality

**Content:**
- Reference specific code with backtick-wrapped snippets and line numbers (e.g. `` `validate_input` at L42 ``)
- When describing a fix, show the relevant code change inline with a fenced code block
- When explaining a decision, point to the concrete constraint (perf, API contract, existing pattern)
- If a change was already made in response, say so and reference the commit or lines
- Keep it as short as the point requires — one line if one line is enough, a paragraph if it needs explaining

**Structure for longer replies:**
- Lead with the direct answer or acknowledgment
- Follow with code/context supporting it
- No bullet-point walls — use prose unless listing genuinely parallel items

### Step 5: Confirm Before Posting (REQUIRED)

**STOP. Do NOT post yet.**

Show the exact reply text for each comment. Use AskUserQuestion:
- header: "Reply"
- question: "Post this reply?" (include the draft text in the description)
- options:
  1. "Post" — post as shown
  2. "Edit" — user provides revised text
  3. "Skip" — don't reply to this comment

### Step 6: Post Reply

Only after user selects "Post":

```bash
gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies \
  -f body="<reply text>"
```

For conversation-level comments (not inline review comments):

```bash
gh api repos/{owner}/{repo}/issues/{pr}/comments \
  -f body="<reply text>"
```
