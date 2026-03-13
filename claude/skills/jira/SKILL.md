---
name: jira
description: Create and manage Jira tickets with proper formatting. Use when asked to create, write, or update Jira tickets/issues/stories/bugs.
---

# Jira

Create well-structured Jira tickets through the Atlassian MCP. Apply clear-writing principles to all ticket text.

## Before creating

1. Ask for **project key** — never assume
2. Ask for **issue type** (Story, Task, Bug, Epic, Subtask) if not specified
3. Validate the project exists with `mcp__atlassian__getVisibleJiraProjects` if unsure

## Creating tickets

Use `mcp__atlassian__createJiraIssue` (or the available create tool — check MCP tools if this name doesn't match).

Write descriptions in **markdown** — the MCP server converts to ADF automatically.

### Field format gotchas

Priority and labels often silently fail when formatted wrong. Use the exact structures:

- **priority**: `{"name": "High"}` — not a bare string
- **labels**: `["backend", "auth"]` — array of strings
- **components**: `{"name": "API"}` — object with name field
- **assignee**: use accountId or email depending on the MCP server

When unsure about a field's format, check available fields with `mcp__atlassian__getJiraIssueTypeMetaWithFields` or `mcp__atlassian__getJiraProjectIssueTypesMetadata` first.

## Writing good tickets

### Summary

One clear sentence. Say what needs to happen, not how important it is.

- Good: "Add rate limiting to /api/auth/login endpoint"
- Bad: "Implement crucial security enhancement for authentication system"

### Description structure

**Context** — why this work exists. One or two sentences linking to the problem or goal.

**What** — what needs to change. Be specific about behavior, not implementation details unless they matter.

**Acceptance criteria** — concrete, testable conditions. Write as a numbered list:
1. Rate limiting returns 429 after 5 failed attempts in 15 minutes
2. Blocked users see a clear error message with retry time
3. Existing sessions are not affected

Skip sections that don't apply. A small bug fix doesn't need acceptance criteria — just describe the bug and the expected behavior.

### Bugs

- **Steps to reproduce** — numbered, specific
- **Expected vs actual** — what should happen, what happens instead
- **Environment** — only if relevant (browser, OS, API version)

## After creating

- Link to epic if one was mentioned
- Add to sprint if requested
- Report back the issue key and URL
