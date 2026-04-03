---
description: Adversarial implementation — worker builds, critic challenges each step. Runs /task first when given an argument.
disable-model-invocation: true
argument-hint: <task description, Jira URL, or empty to resume>
model: opus
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Skill, Agent, TeamCreate, TeamDelete, SendMessage, TaskCreate, TaskList, TaskUpdate
---

Execute a plan through adversarial worker-critic cycles. You are the orchestrator — you coordinate, you don't write code.

You MUST use TeamCreate, Agent, and SendMessage to create a real agent team. Do NOT simulate the worker or critic in your own context.

**Does NOT:** push to remote, or change the overall approach/goals without user approval. May adjust individual steps based on what was learned.

## Setup

1. Derive branch from `git branch --show-current`
2. Run `git rev-parse --git-common-dir` to get the shared git directory
3. If argument provided: run `/task` with the argument first (this creates the plan, branch, and optionally debates). Wait for `/task` to complete before continuing.
4. Read the plan file at `<git-common-dir>/claude/plans/<branch-name>.md`
5. If no plan file exists, tell the user to provide a task description or Jira URL and stop
6. Rebuild tasks from the plan file's implementation steps — the plan file is the source of truth, not a stale task list from a prior session

Create a team with TeamCreate. Then spawn each teammate using the Agent tool with `team_name`, `name`, and `run_in_background: true` parameters:
- **worker** (name: "worker") — general-purpose agent. Implements code, runs tests. Include in its prompt: the project's CLAUDE.md rules, "Run `git` directly", and the step context.
- **critic** (name: "critic") — general-purpose agent. Read-only: do NOT use Edit, Write, or Bash. Its job is a quick gate check: does this diff match the step requirements, follow project rules, and avoid obvious issues? NOT a full code review — scope to this step only, don't flag work planned for later steps. Must respond with a verdict (approve / request-changes / block) and cite specific file:line references.

Spawn both agents in the background (`run_in_background: true`) so they start concurrently. Do NOT use tmux for agent management.

## Execution loop

Pick up the first in_progress or incomplete task. Mark it in_progress (TaskUpdate).

For each step:

**1. Implement**
SendMessage to worker: step description, relevant plan context, files to modify, and instruction to run tests. Tell worker: "If tests fail after 2 attempts, stop and report what's failing. Stage changes with git add but do NOT commit — the orchestrator handles commits."

**2. Challenge**
When worker reports done, run `git diff HEAD` (catches both staged and unstaged).

SendMessage to critic with the diff + step requirements from the plan. Ask: "Review this diff in two parts: (1) Spec compliance — does it implement what the step requires? Anything missing or extra? (2) Code quality — patterns, edge cases, performance, readability."

Critic responds with:
- **approve** — passes both stages
- **request-changes** — specific issues with file:line references and suggested fixes
- **block** — fundamental problem that may require user input, with explanation

**3. Reconcile**
- **approve** → commit using the Skill tool (`skill: "commit"`), mark task completed (TaskUpdate)
- **request-changes** → SendMessage to worker with critic's feedback. Worker revises. Back to Challenge. Max 2 rounds.
- **block** → re-instruct worker with an alternative approach based on the critic's feedback (max 1 attempt). If still blocked, check whether remaining steps depend on this one. If they do, present the blocker to the user. If not, notify the user (short one-liner, don't wait for response), log the issue in the progress log, skip the step, and continue. Include skipped steps in the worker's context for subsequent steps so it can flag dependency issues.

After 2 rounds still contested → present the disagreement to user with both positions.

**4. Checkpoint**
- Append progress to plan file under `## Progress Log`: step completed, deviations, critic findings addressed, any plan changes made
- Review remaining steps against what was just built
- If next step still makes sense, proceed immediately
- If something changed, update the plan yourself and continue

Worker and critic never communicate directly — all routing through you.

## Completion

All steps done → summarize what was built (including any skipped steps), run final test/lint pass, ask: "Next? (rr/pr/done)"

Send shutdown_request to each teammate via SendMessage, then TeamDelete.

## Rules

- One commit per step — critic must approve before you commit
- Critic must cite specific code — no vague objections
- This is a quick per-step gate, not a substitute for `/rr` — suggest /rr at completion for thorough review
- If a step is unnecessary, mark it completed with a note and move on
- If a step is bigger than expected, split it and create new tasks before continuing
- Always clean up the team on exit, including early stops
- When uncertain about requirements or approach, ask — never guess
- If the user sends a message during execution, pause after the current step and address it before continuing
- On unrecoverable errors (git conflicts, worker permanently failing, unexpected state), present the error to user, clean up the team, and stop
