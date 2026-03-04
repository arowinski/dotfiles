---
name: commit
description: Creates commits with generated messages following project conventions. Use when asked to commit, amend, or create a commit.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Read, Glob
---

# Commit

Check `git log` for the repo's commit message style and follow it.

If the last commit is unpushed and current changes are related, propose amending. Ask first.

## Message rules

- First line: max 80 chars, imperative mood
- Prefer single-line messages — the diff shows WHAT, the message explains WHY
- Don't mention tests unless they're the main change
- Use backticks for code references
- Only stage changes relevant to the requested change

## Commit format

```bash
git commit -m "$(cat <<'EOF'
Message here
EOF
)"
```
