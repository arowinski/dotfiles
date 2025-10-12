---
description: Create a pull request
allowed-tools: Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git push:*), Bash(git symbolic-ref:*), Bash(gh pr create:*), Bash(gh pr list:*), Read, Glob
---

Create a pull request following these steps:

1. **Analyze changes**:
   - Run `git fetch origin` to get latest remote state
   - Determine base branch (try master, then main, if neither exists use: `git symbolic-ref refs/remotes/origin/HEAD`)
   - Run `git diff origin/<base>...HEAD` to see changes
   - Run `git log origin/<base>...HEAD` to see commit history
   - Examine the full diff to understand what changed

2. **Generate PR title**:
   - Check for title pattern in recent PRs using `gh pr list --limit 5 --json title`
   - Detect common patterns: `[TICKET-123]`, `feature(TICKET-123):`, `fix:`, etc.
   - If pattern found, try to extract ticket number from current branch name (e.g., ENG-555, FGF-123)
   - If ticket number can't be extracted from branch name, ask user for it
   - Extract the most significant changes from the diff
   - Use imperative mood (e.g., "Add feature", "Fix bug", not "Added" or "Adds")
   - Keep it concise and descriptive
   - Focus on the primary purpose, not implementation details

3. **Check for PR template**:
   - Look for `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE.md`
   - If found, use it as base structure
   - Smart adaptation: if changes don't touch frontend code (no views, CSS, JS, React), skip/remove UI-related sections
   - Fill in relevant sections based on change analysis
   - When listing changes:
     * Use imperative language (e.g., "Add feature", not "Added feature")
     * Focus on most important things only
     * Don't mention tests unless they're a significant part of the PR
     * Use backticks for code references (variables, methods, classes, file names)

4. **Present PR for review**:
   - Show the user:
     * Generated PR title
     * Generated PR body
   - Ask: "Does this look good? Should I create the PR?"
   - Wait for user confirmation

5. **Create PR** (only after user confirms):
   - Push to remote with -u flag if needed
   - Use `gh pr create` with:
     * `--title` (generated title)
     * `--body` (from template or generated)
     * `--assignee @me` (use @me exactly, don't replace)
     * `--draft` (always create as draft)

Requirements:
- Use third person (e.g., "This adds..." not "I added...")
- DO NOT mention claude in PR description
