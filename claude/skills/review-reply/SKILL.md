---
name: review-reply
description: Reads PR review comments and helps draft and post replies. Use when replying to PR review feedback, responding to reviewer comments, or addressing code review threads.
allowed-tools: Bash(gh-comments:*), Bash(gh api:*), Bash(git diff:*), Bash(git log:*), Bash(git remote:*), Read, Glob, Grep, AskUserQuestion
---

# Reply to Review

Read PR review comments, draft replies, and post them after user approval.

## Workflow

### Step 1: Fetch comments

1. `gh-comments <pr-number>` — fetch all comments
2. Identify the three types: `==CONVERSATION==` (top-level PR thread), `==REVIEWS==` (inline review comments), `==STANDALONE==` (inline, no review)
3. Show summary: author, file/line, short excerpt per comment

### Step 2: Select comments

Ask which to address — "All unresolved" or specific ones.

### Step 3: Understand context

For each selected comment:
1. Read the relevant file and surrounding code
2. `git diff` or `git log` if needed to understand what changed and why
3. Understand the reviewer's point before drafting

### Step 4: Draft reply

Write replies that sound like a competent engineer talking to a peer.

**Tone:**
- Natural, conversational — not robotic or overly formal
- Acknowledge valid points directly ("Good catch", "Yeah, you're right")
- When disagreeing, lead with context not contradiction
- No filler phrases ("Great question!", "Thanks for the feedback!")
- Match reviewer's tone and formality level

**Content:**
- Reference code with backtick-wrapped snippets and line numbers (e.g. `` `validate_input` at L42 ``)
- Describing a fix? Show the change inline in a fenced code block
- Explaining a decision? Point to the concrete constraint (perf, API contract, existing pattern)
- Change already made? Say so, reference commit or lines
- Keep as short as the point requires — one line if enough, a paragraph if it needs explaining

**Structure for longer replies:**
- Lead with the direct answer or acknowledgment
- Follow with supporting code/context
- No bullet-point walls — prose unless listing genuinely parallel items

### Step 5: Confirm before posting (REQUIRED)

**STOP. Do NOT post yet.**

Show exact reply text for each comment. Use AskUserQuestion:
- header: "Reply"
- question: "Post this reply?" (include draft text in description)
- options:
  1. "Post" — post as shown
  2. "Edit" — user provides revised text
  3. "Skip" — don't reply to this comment

### Step 6: Post reply

Only after user selects "Post":

```bash
gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies \
  -f body="<reply text>"
```

Conversation-level comments — GitHub doesn't thread these, so post a new top-level comment (not a reply):

```bash
gh api repos/{owner}/{repo}/issues/{pr}/comments \
  -f body="<reply text>"
```
