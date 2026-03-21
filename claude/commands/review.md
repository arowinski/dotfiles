---
description: Review code changes using the code-reviewer agent
argument-hint: [what to review]
---

Use the code-reviewer agent to perform a thorough review.

Scope:
- If argument provided: pass it to the agent (e.g., `/review the authentication logic`)
- Otherwise: review all uncommitted changes (staged + unstaged)

Context:
- Check for a plan file at `<git-common-dir>/claude/plans/<branch-name>.md` — if it exists, extract the Jira ticket link and acceptance criteria
- If a Jira ticket is linked, fetch it via Atlassian MCP (if available) and pass title, description, AC, and comments to the reviewer
