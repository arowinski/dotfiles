---
description: Review code changes using the code-reviewer agent
argument-hint: [what to review]
---

Use the code-reviewer agent to perform a thorough review.

Scope:
- If argument provided: pass it to the agent (e.g., `/review the authentication logic`)
- Otherwise: review all uncommitted changes (staged + unstaged)

The agent will analyze:
- Code quality and adherence to project standards (CLAUDE.md)
- Potential bugs and issues
- Performance considerations
- Security concerns
- Best practices
