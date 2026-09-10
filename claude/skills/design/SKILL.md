---
name: design
description: Plan a feature or change. Spawn three architect agents under opposing design constraints, compare, then produce a one-page plan with goal, approach, files, risks, alternatives, and open questions. Save to `<git-common-dir>/claude/plans/<branch>.md`. Use when the next step is deciding HOW to build something rather than building it — "design this", "plan the X work", "scope this out", a Jira URL to work from, and equally the phrasings that never say plan: "how should we approach X", "what's the plan for X", "which way should we go, A or B", "what would actually change if we moved X", "before I touch this, work out what it takes". Any non-trivial change spanning several files or modules qualifies. Not for implementing a decision already made, debugging, reviewing, or explaining existing code.
allowed-tools: Bash(git:*), Bash(mkdir:*), Read, Glob, Grep, Agent, AskUserQuestion, Write, mcp__atlassian__getJiraIssue, mcp__atlassian__getAccessibleAtlassianResources
argument-hint: [Jira URL, description, or empty]
---

# Design

Produce a one-page plan for a feature or change. Three architect agents design under opposing constraints; this skill orchestrates input, branch setup, the comparison, and the plan artifact.

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

### 4. Spawn three architects

Design it twice, then once more: the first idea is rarely the best, and one agent asked for alternatives produces strawmen. Spawn three `architect` agents in parallel (one message, three Agent calls) with the same brief and one differing constraint each:

- **Minimal interface**: 1–3 entry points, the most behaviour per entry point.
- **Common caller first**: the default case is trivial for the caller who hits it most.
- **Smallest diff**: reuse existing seams and patterns, fewest new modules and files.

Each prompt must include:

- Full task description (and Jira details if any: title, description, AC verbatim)
- **Decisions already made**: every choice the user stated in this conversation, the plan file's `## Decisions` section (written by /nag-me), the ticket, or project memory (storage location, module placement, naming, what stays as is). Quote each in one line. The architect must not propose their opposite; a plan that contradicts one is rejected at self-review.
- Current branch
- Its constraint, then: "Design under this constraint only; two other designs run in parallel and the comparison happens upstream."
- "Cover: high-level approach, files to touch, key risks, open questions you can't resolve from the code."
- "Be concrete. Cite file paths. Flag blockers explicitly."

Wait for all three. If any reports a blocker (missing info, broken assumption), present it to the user and ask how to proceed before comparing.

### 5. Compare, pick, self-review

Contrast the three by **depth** (behaviour a caller gets per unit of interface learned), **locality** (where change and future bugs concentrate), and **change size**. Pick one, or a hybrid when parts combine cleanly. Be opinionated: the plan carries one approach. The two not chosen become the Alternatives considered, with the real reason each lost.

Then scan the chosen design for:

- **Placeholders**: TBD, TODO, XXX, "fill in later"
- **Contradictions**: sections that say opposite things, or an approach that reverses a decision already made
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
- **## Alternatives considered**: the two designs not chosen, one sentence each on their shape and why the chosen one beats them
- **## Open questions**: anything that needs user input, a spike, or that no architect could resolve

For Jira tasks, include the ticket's verbatim description and AC near the top so context survives session compression.

### 7. Present

Show the plan content. End with:

> Plan saved at `<path>`. Ready to implement when you are.

No commit. No chain handoff.
