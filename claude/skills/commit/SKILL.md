---
name: commit
description: Creates commits with generated messages following project conventions. Use when asked to commit, amend, or create a commit.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Read, Glob
---

# Commit

Check `git log` for the repo's commit message style and follow it.

If the last commit is unpushed and current changes are related, propose amending. Ask first.

## Pre-commit checks

If tests or linter fail, stop and report the failure. Do not commit.

## Message rules

- First line: max 80 chars, imperative mood
- Prefer single-line messages — the diff shows WHAT, the message explains WHY
- Don't mention tests unless they're the main change
- Only stage changes relevant to the requested change
