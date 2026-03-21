---
name: pr
description: Creates or edits pull requests with automatic title/template formatting. Use when asked to create or edit a PR.
allowed-tools: Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git remote:*), Bash(git push:*), Bash(git symbolic-ref:*), Bash(git rev-parse:*), Bash(gh pr create:*), Bash(gh pr edit:*), Bash(gh pr list:*), Bash(gh pr view:*), Read, Glob, AskUserQuestion, mcp__atlassian__getJiraIssue, mcp__atlassian__getAccessibleAtlassianResources
---

# PR

## Workflow

### Step 1: Analyze Changes

1. Run `git diff origin/<base>...HEAD` to examine all changes
2. Run `git log origin/<base>..HEAD` to see commit history
3. **Identify the single most important change** - what's the primary purpose of this PR?
4. Understand scope: frontend, backend, infrastructure, tests, etc.

### Step 2: Detect Title Pattern

1. Run `gh pr list --limit 10 --json title` to examine recent PRs
2. Identify common prefix/ticket patterns and extract ticket number from branch name
3. If pattern detected but ticket number not found in branch name, ask user for it
4. If ticket number found, use the Jira ticket for full context on motivation/rationale

### Step 3: Check for PR Template

1. Look for `.github/pull_request_template.md` (or `PULL_REQUEST_TEMPLATE.md`) from the repo root — use `git rev-parse --show-toplevel` to find it, don't rely on the current working directory
2. If found, adapt it — skip UI-related sections if changes don't touch frontend
3. Content guidelines:
   - Imperative mood, third person ("This adds..." not "I added...")
   - Focus on most important changes, don't mention tests unless they're the main change
   - Use backticks for code references
   - Don't hard-wrap lines — GitHub renders single newlines as line breaks. Write each paragraph as one continuous line.

### Step 4: Generate Title and Body

1. Craft title following detected pattern:
   - **Title must mention the single most important thing in the PR**
   - Apply ticket number prefix if pattern exists
   - Use imperative mood ("Add feature", "Fix bug")
   - Focus on primary purpose, not implementation details

2. Generate body:
   - **Focus on context/motivation/rationale (WHY), not implementation details (WHAT)**
   - If context is unclear, ask user for background before proceeding
   - Use template if found, otherwise create summary emphasizing:
     - Why the change is needed
     - What problem it solves
     - Any relevant context or constraints
   - Use third person to describe motivation/context/rationale

### Step 5: Interactive Confirmation (REQUIRED - DO NOT SKIP)

**STOP. Do NOT create the PR yet.**

1. Display the generated PR title and body

2. **MUST use AskUserQuestion tool** (do NOT ask conversationally, do NOT proceed to Step 6 without this). Use this exact structure:
   - header: "Next step"
   - question: "What would you like to do?"
   - options (exactly 3):
     1. label: "Create PR", description: "Create the PR as shown above"
     2. label: "Edit title", description: "Modify the PR title"
     3. label: "Edit body", description: "Modify the PR body"
   - multiSelect: false

3. Handle response:
   - "Create PR" → NOW proceed to Step 6
   - "Edit title" → user provides new title via "Other", apply it, show updated PR, return to step 2
   - "Edit body" → user provides new body via "Other", apply it, show updated PR, return to step 2
   - "Other" text → treat as edited content for whichever edit option user intended

### Step 6: Create Draft PR (WAIT FOR STEP 5 TO BE EXPLICITLY CONFIRMED, DON'T ACCEPT EMPTY RESPONSES)

**Only execute this step after user selected "Create PR" in Step 5.**

1. Push branch to remote with `-u` flag if not tracking remote
2. Run `gh pr create` with:
   - `--title` (generated title)
   - `--body` (generated or template-based body)
   - `--assignee @me`
   - `--draft`
