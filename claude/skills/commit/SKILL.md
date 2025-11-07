---
name: commit
description: Creates commits with generated messages following project conventions. Use when asked to commit changes or create a commit.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Read, Glob
---

# Commit

## Overview

Automates commit creation by analyzing changes, generating appropriate commit messages following project conventions, and creating commits with proper staging.

## Workflow

### Step 1: Check Status

1. Run `git status` to see modified and untracked files
2. Run `git diff` to see unstaged changes
3. Run `git diff --staged` to see staged changes
4. If no changes to commit, inform user and stop

### Step 2: Analyze Changes

1. **Identify the primary purpose** - what's the main change?
   - New feature? Which one?
   - Bug fix? What bug?
   - Refactoring? Of what?
   - Configuration change? What aspect?
2. Determine type: feature, fix, refactor, chore, docs, etc.
3. Identify scope: which files/modules are affected

### Step 3: Generate Commit Message

Follow these requirements:

**Message structure:**
- **First line**: Concise summary of primary change
  - Use imperative mood ("Add feature", "Fix bug", NOT "Added" or "Adds")
  - Keep it focused on the single most important change
  - Max 80 characters
- **Blank line**
- **Body** (if multiple significant changes):
  - Bullet points for additional changes
  - Focus only on most important changes

**Content guidelines:**
- Use third person ("This adds..." NOT "I added...")
- Focus on WHAT and WHY, not HOW
- **Don't mention tests** unless they're a significant part of the commit (e.g., new testing framework, major test infrastructure changes)
- Use backticks for code references (variables, methods, classes, file names)

### Step 4: Stage and Commit

1. Stage relevant files with `git add`:
   - Include modified files that are part of the change
   - Include new files if appropriate
   - **Don't stage files that likely contain secrets** (.env, credentials.json, etc.)
   - Warn user if trying to commit secret files

2. Create commit with generated message:
   - **NEVER add Claude footer or "Generated with Claude Code" links**
   - **NEVER add "Co-Authored-By: Claude" lines**
   - Use heredoc for proper formatting:
   ```bash
   git commit -m "$(cat <<'EOF'
   Commit message here
   EOF
   )"
   ```

3. Run `git status` after commit to verify success
