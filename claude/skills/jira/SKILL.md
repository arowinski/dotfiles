---
name: jira
description: Write and update Jira tickets — the summary, description, acceptance criteria and fields, not just the API call. Use whenever work is being recorded in the tracker, however the user phrases it: "create a jira ticket", "file a ticket", "raise a bug", "log this as a task", "put it in the backlog", "we should track this", "write up a story", "turn these TODOs into tickets", or a request to rewrite an existing issue or add acceptance criteria to one (PDE-4412 and the like). The word "Jira" is usually absent; ticket intent is the signal. Not for reading or checking the status of an existing issue, not for a GitHub issue or a PR body, not for planning the work itself, and not for debugging the Atlassian MCP connection.
allowed-tools: mcp__atlassian__createJiraIssue, mcp__atlassian__editJiraIssue, mcp__atlassian__getJiraIssue, mcp__atlassian__getVisibleJiraProjects, mcp__atlassian__getJiraIssueTypeMetaWithFields, mcp__atlassian__getJiraProjectIssueTypesMetadata, mcp__atlassian__createIssueLink, mcp__atlassian__getIssueLinkTypes, Read, AskUserQuestion
---

# Jira

Create Jira tickets via Atlassian MCP. Apply clear-writing skill to all ticket text.

## Before creating

1. Ask for **project key**; never assume
2. **Issue type**: default to **Task** if not specified (most feature/infra/cleanup work is a Task; reserve Story for larger POC/epic-ish items, Bug for defects)
3. Validate project with `mcp__atlassian__getVisibleJiraProjects` if unsure

## Gate

- Show the full draft (summary, type, parent, body) and wait for a go before any create or edit; one ticket per go. Comments take an approved draft too.
- Touch only tickets the user reported or is assigned: never comment on, close, or repurpose anyone else's; link a replacement with Relates.
- Status changes only on request; new tickets stay in Backlog.
- When the permission hook (not the user) denies the first create or edit, re-send the identical approved payload once; never alter it to get past the hook.

## Creating tickets

Use `mcp__atlassian__createJiraIssue`.

Write descriptions in **markdown**; MCP server converts to ADF automatically.

### Field format gotchas

Priority/labels silently fail on wrong format. Use exact structures:

- **priority**: `{"name": "High"}` (not a bare string)
- **labels**: `["backend", "auth"]` (array of strings)
- **components**: `{"name": "API"}` (object with name field)
- **assignee**: accountId or email depending on MCP server

Unsure about format? Check fields with `mcp__atlassian__getJiraIssueTypeMetaWithFields` or `mcp__atlassian__getJiraProjectIssueTypesMetadata` first.

## Writing good tickets

### Summary

Short imperative, action-verb first. Say what needs to happen, not how important it is. No parenthetical glosses (`(GRE)`-style acronyms).

- Good: "Add rate limiting to /api/auth/login endpoint"
- Bad: "Implement crucial security enhancement for authentication system"

### Description structure

`###` headers, in this order, skip what doesn't apply:

**`### Context`**: 1-3 prose sentences on why this exists; link the driver ticket/PR.

**`### Acceptance criteria`**: `*` bullets (NOT numbered), terse fragments, backticked identifiers (module/field/flag names). Each bullet is one concrete, testable assertion:
* `RateLimiter` returns 429 after 5 failed `/api/auth/login` attempts in 15 min
* blocked users get a clear error with retry time
* existing sessions unaffected

**`### Risks`**: usually just "None identified". List a risk only if it clears the bar: security exposure, PII/data leakage, compliance, customer-visible effects, irreversible ops, downtime. NOT impl choices, test gaps, refactor scope, or code quality (those go in Context/AC).

**`### Notes`** (optional): deferred/out-of-scope bits, "decide during implementation" caveats.

A ticket states the outcome, not an implementation plan, and never cites unpushed local work. Reference PRs inline as `#310`, tickets as `ENG-994`; link follow-ups with a Relates issue link. No bold `**callouts**` in ticket bodies. Skip sections that don't apply: a small bug fix uses the Bugs structure below instead.

### Bugs

- **Steps to reproduce**: numbered, specific
- **Expected vs actual**: what should happen, what happens instead
- **Environment**: only if relevant (browser, OS, API version)

## After creating

- Link to epic if mentioned
- Add to sprint if requested
- Report issue key + URL

## Updating tickets

Fetch current state with `mcp__atlassian__getJiraIssue` before editing (avoids clobbering fields you didn't mean to change).

- **Field edits** (summary, description, labels, priority): `mcp__atlassian__editJiraIssue`
- **Link related tickets** (blocks, relates to, parent/child): `mcp__atlassian__createIssueLink`; discover link types with `mcp__atlassian__getIssueLinkTypes` if unsure. Dependencies are Blocks links.
