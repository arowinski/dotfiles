---
description: Reviewed review — reviewer proposes findings, two verifiers validate before fixes are applied
argument-hint: [what to review]
model: opus
---

Accept a review scope or default to all uncommitted changes (staged + unstaged).

## Setup

1. Determine review scope:
   - If argument provided: use it as scope
   - Otherwise: run `git diff` to get all uncommitted changes
2. Gather context:
   - Check for a plan file at `<git-common-dir>/claude/plans/<branch-name>.md` — if it exists, extract the Jira ticket link and acceptance criteria
   - If a Jira ticket is linked, fetch it via Atlassian MCP (if available) — pull title, description, acceptance criteria, and comments
   - Pass this context to the reviewer so findings can be validated against requirements, not just code quality

## Team

You MUST use TeamCreate + SendMessage to create a real agent team. NEVER simulate in your own context.

Create a team with 3 teammates:

**reviewer** (agent:code-reviewer)
- Performs a full code review of the scope
- Produces numbered findings with severity, location, and suggested fix

**verifier-a** (agent:architect)
- Receives the reviewer's findings
- Independently checks each finding: is it valid? Is the suggested fix correct?
- Researches the codebase for evidence

**verifier-b** (agent:architect)
- Same task as verifier-a, independently

## Workflow

### 1. Review

Tell the reviewer what to review and let it gather context itself (read files, run git diff). If the reviewer finds zero issues, report clean and skip verifiers.

The reviewer should produce output in this format:

**Finding 1** — [severity]
- File: [path:line]
- Issue: [what's wrong]
- Fix: [suggested change]

### 2. Verify

Send the reviewer's findings to both verifiers **in parallel**. Each verifier independently assesses every finding:
- **Agree** — the finding is valid and the fix is correct
- **Disagree** — the finding is wrong, irrelevant, or the fix would cause harm
- **Partial** — the finding is valid but the fix needs adjustment (must suggest alternative)

Verifiers must not communicate with each other.

### 3. Reconcile

For each finding, compare verifier assessments:

**Both agree** → mark as confirmed
**Both disagree** → drop the finding
**Disagree with each other or partial** → mark as contested

### 4. Present

Show results to the user:

**Confirmed** (will apply)
- [finding + both verifiers' reasoning]

**Dropped** (both verifiers rejected)
- [finding + why rejected]

**Contested** (need your call)
- [finding + each verifier's position]

For contested findings, ask the user to decide: apply, skip, or modify.

### 5. Apply

Apply only confirmed fixes and user-approved contested fixes. After applying, show a summary of what changed.

Then clean up the team.
