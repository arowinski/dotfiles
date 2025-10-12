---
description: Create a smart commit with generated message
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Read, Glob
---

Create a commit following these steps:

1. **Check status**:
   - Run `git status` to see modified and untracked files
   - Run `git diff` to see unstaged changes
   - Run `git diff --staged` to see staged changes

2. **Analyze changes**:
   - Examine the diff to understand what changed
   - Identify the primary purpose of the changes
   - Determine if this is a feature, fix, refactor, etc.

3. **Generate commit message**:
   - Use imperative mood (e.g., "Add feature", "Fix bug", not "Added" or "Adds")
   - Keep first line concise (primary change)
   - Add blank line, then bullet points for multiple changes if needed
   - Focus on most important changes only
   - Don't mention tests unless they're a significant part of the commit

4. **Stage and commit**:
   - Stage relevant files with `git add`
   - Don't stage files that likely contain secrets (.env, credentials.json, etc.)
   - Create commit with generated message
   - NEVER add Claude footer or co-authored-by

Requirements:
- Use third person (e.g., "This adds..." not "I added...")
- If no changes to commit, inform user and stop
- Warn if trying to commit secret files
- DO NOT add any Claude Code footer or co-authored-by lines
