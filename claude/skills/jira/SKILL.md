---
name: jira
description: Create and manage Jira tickets with proper formatting. Use when asked to create, write, or update Jira tickets/issues/stories/bugs.
allowed-tools: mcp__atlassian__createJiraIssue, mcp__atlassian__editJiraIssue, mcp__atlassian__getJiraIssue, mcp__atlassian__getVisibleJiraProjects, mcp__atlassian__getJiraIssueTypeMetaWithFields, mcp__atlassian__getJiraProjectIssueTypesMetadata, mcp__atlassian__createIssueLink, mcp__atlassian__getIssueLinkTypes, Read, AskUserQuestion
---

# Jira

Create Jira tickets via Atlassian MCP. Apply clear-writing skill to all ticket text.

## Before creating

1. Ask for **project key** — never assume
2. Ask for **issue type** (Story, Task, Bug, Epic, Subtask) if not specified
3. Validate project with `mcp__atlassian__getVisibleJiraProjects` if unsure

## Creating tickets

Use `mcp__atlassian__createJiraIssue`.

Write descriptions in **markdown** — MCP server converts to ADF automatically.

### Field format gotchas

Priority/labels silently fail on wrong format. Use exact structures:

- **priority**: `{"name": "High"}` — not a bare string
- **labels**: `["backend", "auth"]` — array of strings
- **components**: `{"name": "API"}` — object with name field
- **assignee**: accountId or email depending on MCP server

Unsure about format? Check fields with `mcp__atlassian__getJiraIssueTypeMetaWithFields` or `mcp__atlassian__getJiraProjectIssueTypesMetadata` first.

## Writing good tickets

### Summary

One clear sentence. Say what needs to happen, not how important it is.

- Good: "Add rate limiting to /api/auth/login endpoint"
- Bad: "Implement crucial security enhancement for authentication system"

### Description structure

**Context** — why this work exists. 1-2 sentences linking to the problem or goal.

**What** — what needs to change. Specific about behavior, not implementation unless it matters.

**Acceptance criteria** — concrete, testable conditions. Numbered list:
1. Rate limiting returns 429 after 5 failed attempts in 15 minutes
2. Blocked users see a clear error message with retry time
3. Existing sessions are not affected

Skip sections that don't apply. Small bug fix? Just describe the bug and expected behavior.

### Bugs

- **Steps to reproduce** — numbered, specific
- **Expected vs actual** — what should happen, what happens instead
- **Environment** — only if relevant (browser, OS, API version)

## After creating

- Link to epic if mentioned
- Add to sprint if requested
- Report issue key + URL

## Updating tickets

Fetch current state with `mcp__atlassian__getJiraIssue` before editing — avoids clobbering fields you didn't mean to change.

- **Field edits** (summary, description, labels, priority): `mcp__atlassian__editJiraIssue`
- **Link related tickets** (blocks, relates to, parent/child): `mcp__atlassian__createIssueLink` — discover link types with `mcp__atlassian__getIssueLinkTypes` if unsure
