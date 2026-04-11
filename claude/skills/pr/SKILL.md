---
name: pr
description: Creates or edits pull requests with automatic title/template formatting. Use when asked to create or edit a PR.
allowed-tools: Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git remote:*), Bash(git push:*), Bash(git symbolic-ref:*), Bash(git rev-parse:*), Bash(gh pr create:*), Bash(gh pr edit:*), Bash(gh pr list:*), Bash(gh pr view:*), Read, Glob, AskUserQuestion, mcp__atlassian__getJiraIssue, mcp__atlassian__getAccessibleAtlassianResources
---

# PR

## Workflow

### Step 1: Analyze changes

1. `git diff origin/<base>...HEAD` — all changes
2. `git log origin/<base>..HEAD` — commit history
3. **Identify single most important change** — primary purpose?
4. Identify scope: frontend, backend, infra, tests, etc.

### Step 2: Detect title pattern

1. `gh pr list --limit 10 --json title` — recent PRs
2. Identify prefix/ticket patterns, extract ticket from branch name
3. Pattern found but no ticket in branch? Ask user.
4. Ticket found? Fetch Jira for motivation/rationale.

### Step 3: Check for PR template

1. Check `.github/pull_request_template.md` (or `PULL_REQUEST_TEMPLATE.md`) from repo root — use `git rev-parse --show-toplevel`, don't rely on cwd.
2. Found? Adapt — skip UI sections if no frontend changes.
3. Content:
   - Imperative mood, third person ("This adds...", not "I added...")
   - Focus on most important changes; don't mention tests unless main change
   - Backticks for code refs
   - Don't hard-wrap — GitHub renders single newlines as breaks. One paragraph = one line.

### Step 4: Generate title and body

1. Title (follow detected pattern):
   - **Mention single most important thing in PR**
   - Apply ticket prefix if pattern exists
   - Imperative mood ("Add feature", "Fix bug")
   - Primary purpose, not implementation details

2. Body (apply clear-writing skill — no AI prose, no filler, no hype):
   - **Focus on WHY (motivation/rationale), not WHAT (implementation)**
   - Context unclear? Ask user first.
   - Use template if found, else summary covering:
     - Why change needed
     - What problem it solves
     - Relevant context/constraints
   - Third person for motivation/context/rationale

### Step 5: Interactive confirmation (REQUIRED — DO NOT SKIP)

**STOP. Do NOT create PR yet.**

1. Display generated title and body.
2. **MUST use AskUserQuestion tool** (not conversational, don't skip to Step 6). Structure:
   - header: "Next step"
   - question: "What would you like to do?"
   - options (exactly 3):
     1. label: "Create PR", description: "Create the PR as shown above"
     2. label: "Edit title", description: "Modify the PR title"
     3. label: "Edit body", description: "Modify the PR body"
   - multiSelect: false
3. Handle response:
   - "Create PR" → proceed to Step 6
   - "Edit title" → user provides via "Other", apply, show updated PR, return to 2
   - "Edit body" → user provides via "Other", apply, show updated PR, return to 2
   - "Other" → ask which field to edit if unclear

### Step 6: Create draft PR (WAIT for Step 5 explicit confirmation — DO NOT accept empty responses)

**Only after user selected "Create PR" in Step 5.**

1. Push branch with `-u` if not tracking remote.
2. `gh pr create`:
   - `--title` (generated)
   - `--body` (generated or template)
   - `--assignee @me`
   - `--draft`
