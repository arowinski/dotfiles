---
name: commit
description: Creates commits with generated messages following project conventions. Use when asked to commit, amend, or create a commit.
allowed-tools: Bash(git-commit-context:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git absorb:*), Read, Glob
---

# Commit

## Workflow

1. Run `git-commit-context` — gets status, diffs, log in one call. Understand what to commit, match message style.
2. Verify tests green, lint clean, formatter applied. Stop and report on failure.
3. Consider amend or absorb (ask first):
   - Last commit unpushed + related? Amend.
   - Staged changes match scope of existing branch commit? `git absorb --and-rebase`.

## Rules

- First line: max 80 chars, imperative mood
- Prefer single-line — only add body when why isn't obvious
- NEVER mention tests unless they're the main change
- NEVER commit unrelated changes
- NEVER add ticket prefixes (e.g. JIRA-123, GH-456)
- NEVER use vague messages ("Address review feedback", "Fix issues", "Update based on suggestions") — describe actual change
