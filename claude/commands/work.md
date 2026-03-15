---
description: Execute plan steps with commits and checkpoints. Use after /task to implement the plan.
disable-model-invocation: true
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Agent, Skill, TaskCreate, TaskList, TaskUpdate
---

Execute the current plan step by step.

**Does NOT:** create branches, push to remote, or change the overall approach without user approval.

## Setup

1. Derive branch name from current branch (`git branch --show-current`)
2. Run `git rev-parse --git-common-dir` to get the shared git directory
3. Read the plan file at `<git-common-dir>/claude/plans/<branch-name>.md`
4. If no plan file exists, tell the user to run `/task` first and stop
5. Rebuild tasks from the plan file's implementation steps — the plan file is the source of truth, not a stale task list from a prior session

## Execution loop

Pick up the current in_progress task, or the first incomplete one.

For each step:

**Implement**
- Read the step description from the plan
- Implement the changes
- Run tests and linters
- If tests still fail after 2 attempts, stop and ask the user

**Commit**
- Use the `/commit` skill to commit the step
- Mark the task as completed (TaskUpdate)

**Checkpoint**
- Append a progress entry to the plan file under `## Progress Log`: step completed, any deviations from plan, decisions made
- Review the remaining steps against what was just built
- If the next step still makes sense: mark it in_progress, ask "Continue with: '<next step>'? (y/continue/adapt/stop)"
- If something changed: propose specific updates to the remaining steps, wait for approval, update the plan file and tasks, then continue

## Completion

When all steps are completed:
- Summarize what was built
- Run a final test/lint pass
- Ask: "Next? (review/rr/pr/done)"

## User responses

- **y / continue** — proceed to next step
- **adapt** — user explains what changed, update plan accordingly
- **stop** — stop here, leave remaining tasks for later

## Rules

- One commit per step — don't batch multiple steps
- If a step turns out to be unnecessary, mark it completed with a note and move on
- If a step is bigger than expected, split it and create new tasks before continuing
- When uncertain about requirements or approach, ask — never guess
