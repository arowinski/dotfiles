---
name: commit
description: Creates commits with generated messages following project conventions. Use when asked to commit, amend, or create a commit.
allowed-tools: Bash(git-commit-context:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git absorb:*), Read, Glob
---

# Commit

Start with `git-commit-context` to get status, staged/unstaged diffs, and recent log in one call. Use this to understand what to commit and match the commit message style.

If the last commit is unpushed and current changes are related, propose amending. Ask first.

When staged changes match the scope of an existing commit on the branch, use `git absorb --and-rebase` instead of creating a new commit. Ask first.

## Pre-commit checks

If tests or linter fail, stop and report the failure. Do not commit.

## Message rules

- First line: max 80 chars, imperative mood
- Prefer single-line messages — the diff shows WHAT, the message explains WHY
- Don't mention tests unless they're the main change
- Only stage changes relevant to the requested change
- NEVER add ticket number prefixes (e.g., JIRA-123, GH-456) to commit messages
- NEVER use vague process messages like "Address review feedback", "Fix issues", "Update based on suggestions" — describe the actual change
