---
description: Adversarial implementation — worker builds, critic challenges each step. Runs /task first when given an argument.
disable-model-invocation: true
argument-hint: <task description, Jira URL, or empty to resume>
model: opus
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Skill, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskList, TaskUpdate
---

Execute a plan through adversarial worker-critic cycles. You are the orchestrator — you coordinate, you don't write code.

You MUST use TeamCreate, Agent, and SendMessage to create a real agent team. Do NOT simulate the worker or critic in your own context.

**Does NOT:** push to remote, or change the overall approach without user approval.

## Setup

1. Derive branch from `git branch --show-current`
2. Run `git rev-parse --git-common-dir` to get the shared git directory
3. If argument provided: run `/task` with the argument first (this creates the plan, branch, and optionally debates). Wait for `/task` to complete before continuing.
4. Read the plan file at `<git-common-dir>/claude/plans/<branch-name>.md`
5. If no plan file exists, tell the user to provide a task description or Jira URL and stop
6. Rebuild tasks from the plan file's implementation steps — the plan file is the source of truth, not a stale task list from a prior session

Create a team with TeamCreate. Then spawn each teammate using the Agent tool with `team_name` and `name` parameters:
- **worker** (name: "worker") — general-purpose agent. Implements code, runs tests. Include in its prompt: the project's CLAUDE.md rules, "Run `git` directly", and the step context.
- **critic** (name: "critic") — general-purpose agent with read-only instructions. Its job is a quick gate check: does this diff match the step requirements, follow project rules, and avoid obvious issues? NOT a full code review — scope to this step only, don't flag work planned for later steps. Must respond with a verdict (approve / request-changes / block) and cite specific file:line references.

## Execution loop

Pick up the first in_progress or incomplete task. Mark it in_progress (TaskUpdate).

For each step:

**1. Implement**
SendMessage to worker: step description, relevant plan context, files to modify, and instruction to run tests. Tell worker: "If tests fail after 2 attempts, stop and report what's failing. Stage changes with git add but do NOT commit — the orchestrator handles commits."

**2. Challenge**
When worker reports done, run `git diff HEAD` (catches both staged and unstaged). SendMessage to critic with the diff + step requirements from the plan.

Critic responds with:
- **approve** — change is correct, follows patterns, matches step requirements
- **request-changes** — specific issues with file:line references and suggested fixes
- **block** — fundamental problem requiring user input, with explanation

**3. Reconcile**
- **approve** → commit using the Skill tool (`skill: "commit"`), mark task completed (TaskUpdate)
- **request-changes** → SendMessage to worker with critic's feedback. Worker revises. Back to Challenge. Max 2 rounds.
- **block** → present critic's reasoning + worker's position to user, wait for direction

After 2 rounds still contested → present the disagreement to user with both positions.

**4. Checkpoint**
- Append progress to plan file under `## Progress Log`: step completed, deviations, critic findings addressed
- Review remaining steps against what was just built
- If next step still makes sense: mark it in_progress, ask "Continue with: '<next step>'? (y/continue/adapt/stop)"
- If something changed: propose updates to remaining steps, wait for approval, update plan file and tasks

Worker and critic never communicate directly — all routing through you.

## User responses

- **y / continue** — proceed to next step
- **adapt** — user explains what changed, update plan accordingly
- **stop** — stop here, clean up team, leave remaining tasks for later

## Completion

All steps done → summarize what was built, run final test/lint pass, ask: "Next? (rr/pr/done)"

Send shutdown_request to each teammate via SendMessage, then TeamDelete.

## Rules

- One commit per step — critic must approve before you commit
- Critic must cite specific code — no vague objections
- This is a quick per-step gate, not a substitute for `/rr` — suggest /rr at completion for thorough review
- If a step is unnecessary, mark it completed with a note and move on
- If a step is bigger than expected, split it and create new tasks before continuing
- Always clean up the team on exit, including early stops
- When uncertain about requirements or approach, ask — never guess
- On unrecoverable errors (git conflicts, worker permanently failing, unexpected state), present the error to user, clean up the team, and stop
