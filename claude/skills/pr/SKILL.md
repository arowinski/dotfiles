---
name: pr
description: Creates pull requests with automatic title/template formatting. Use when asked to create a PR.
allowed-tools: Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git push:*), Bash(git symbolic-ref:*), Bash(git rev-parse:*), Bash(gh pr create:*), Bash(gh pr list:*), Read, Glob, AskUserQuestion
---

# PR

## Overview

Automates pull request creation by detecting repository-specific title patterns, adapting PR templates, and creating draft PRs after user confirmation.

## Workflow

### Step 1: Analyze Changes

1. Run `git diff origin/<base>...HEAD` to examine all changes
2. Run `git log origin/<base>..HEAD` to see commit history
3. **Identify the single most important change** - what's the primary purpose of this PR?
   - New feature? Which one?
   - Bug fix? What bug?
   - Refactoring? Of what?
   - Performance improvement? Where?
4. Understand scope: frontend, backend, infrastructure, tests, etc.

### Step 2: Detect Title Pattern

1. Run `gh pr list --limit 10 --json title` to examine recent PRs
2. Identify common patterns:
   - Prefix formats: `[TICKET-123]`, `feature(TICKET-123):`, `fix:`
   - Ticket number formats: `ENG-555`, `FGF-123`, `JIRA-456`
3. Extract ticket number from current branch name if pattern exists
4. If pattern detected but ticket number not found in branch name, ask user for it

### Step 3: Check for PR Template

1. Look for template at:
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`

2. If template found, adapt it:
   - Remove/skip UI-related sections if changes don't touch frontend code (no views, CSS, JS, React)
   - Fill relevant sections based on change analysis

3. Content guidelines:
   - Use imperative language ("Add feature", not "Added feature")
   - Focus only on most important changes
   - **Don't mention tests** - tests are expected and obvious. Only mention if they're a major part of the PR (e.g., new testing framework, significant test infrastructure changes)
   - Use backticks for code references (variables, methods, classes, file names)
   - Use third person ("This adds..." not "I added...")
   - Never mention Claude

### Step 4: Generate Title and Body

1. Craft title following detected pattern:
   - **Title must mention the single most important thing in the PR**
   - Apply ticket number prefix if pattern exists
   - Use imperative mood ("Add feature", "Fix bug")
   - Focus on primary purpose, not implementation details

2. Generate body from template (if found) or create summary of changes
   - Focus on why, ask for context if don't have, not what.

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
