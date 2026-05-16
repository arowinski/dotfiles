---
name: design
description: Plan a feature or change. Spawn the architect agent to research, then produce a one-page plan with goal, approach, files, risks, alternatives, and open questions. Save to `.git/claude/plans/<branch>.md`. Use when starting non-trivial work, given a Jira URL, or asked to design, plan, or scope an approach.
allowed-tools: Bash(git:*), Bash(mkdir:*), Read, Glob, Grep, Agent, AskUserQuestion, Write, mcp__atlassian__getJiraIssue, mcp__atlassian__getAccessibleAtlassianResources
argument-hint: [Jira URL, description, or empty]
---

# Design

Produce a one-page plan for a feature or change. Architect agent does the research; this skill orchestrates input, branch setup, and the plan artifact.

**You do NOT:** create branches without asking, commit anything, push, or hand off to an implementation skill. The user reads the plan and starts implementing.

## Workflow

### 1. Parse input

- **Jira URL** in argument or conversation (e.g., `https://<host>/browse/ENG-555`): extract ticket ID, fetch via `mcp__atlassian__getJiraIssue` if available (title, description, acceptance criteria, comments). Otherwise, ask the user to paste ticket details.
- **Free text**: use as the task description
- **Empty**: ask the user for the task description or Jira link

### 2. Scope decomposition pre-flight

If the task spans multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), stop and propose a split. Each subsystem gets its own /design run. Ask which to design first.

For single-subsystem tasks, skip.

### 3. Branch handling

Run `git rev-parse --abbrev-ref HEAD`.

- If on `main` or `master`: ask "Create new branch? (y/n)"
  - If yes: derive name (Jira: lowercase ticket ID like `eng-555`, no suffix; non-Jira: kebab-case from description, 3-5 words). If a branch with that name already exists locally or on origin, ask user how to proceed (use existing, pick new name, or stay).
  - If no: stay on current branch.
- If on a feature branch: stay. Assume user prepped.

When creating: `git fetch origin && git switch -c <name> origin/main` (or `origin/master`).

### 4. Spawn architect

Use the Agent tool with `subagent_type: architect`. Prompt must include:

- Full task description (and Jira details if any: title, description, AC verbatim)
- Current branch
- "Recommend one approach. Also list 1-3 alternatives you seriously considered, with a one-sentence rejection reason each. No strawman alternatives. If you can't name a coherent alternative, the recommendation may be weak — say so."
- "Cover: high-level approach, files to touch, key risks, alternatives considered, open questions you can't resolve from the code."
- "Prefer introspection over guessing. Use Tidewave (`mcp__tidewave__*`) for Ecto schemas, source location, package docs, and live behavior in Phoenix projects. Use Sentry (`mcp__sentry__*`) for current error state in the area you're touching. Use context7 for up-to-date library API docs when designing with a library."
- "Be concrete. Cite file paths. Flag blockers explicitly."

Wait for architect to complete. If it reports blockers (missing info, broken assumption), present them to the user and ask how to proceed before generating the plan.

### 5. Self-review pass

Before writing the plan, scan the architect's output for:

- **Placeholders**: TBD, TODO, XXX, "fill in later"
- **Contradictions**: sections that say opposite things
- **Vague requirements**: "handle errors appropriately", "as needed"
- **AC gaps** (Jira tasks only): every acceptance criterion should map to something in the approach or be explicitly out of scope

Fix these inline before showing the user. Don't punt them downstream.

### 6. Write plan file

Compute path: `<git-common-dir>/claude/plans/<branch-name>.md` where `<git-common-dir>` comes from `git rev-parse --git-common-dir`.

`mkdir -p` the parent directory. The file has a title, optional Jira link, and six sections in this order:

- **Title** (H1): task title or Jira ticket ID
- **Jira link** (if applicable): one line below the title
- **## Goal**: what we're trying to achieve, one paragraph
- **## Approach**: high-level strategy, 3-7 sentences, including the why
- **## Files**: concrete list of files to create or modify, one line per file with what changes
- **## Risks**: what could break, edge cases, assumptions, things to watch
- **## Alternatives considered**: 1-3 paths architect weighed, one sentence each on what they were and why rejected
- **## Open questions**: anything that needs user input, a spike, or that architect couldn't resolve

For Jira tasks, include the ticket's verbatim description and AC near the top so context survives session compression.

### 7. Present

Show the plan content. End with:

> Plan saved at `<path>`. Ready to implement when you are.

No commit. No chain handoff.
