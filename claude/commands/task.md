---
description: Plan a task and create workspace
argument-hint: <task description or Jira URL>
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git checkout:*), Bash(git symbolic-ref:*), Read, Write, Glob, Grep, TodoWrite
---

Create a comprehensive plan for the given task.

Accept task description, pasted requirements, or Jira URL.

If no argument provided, ask user for task description.

Process:

1. **Check for existing work:**
   - Check if `PLAN.md` exists in project root
   - If exists:
     * Read the plan to extract task title
     * Ask: "Found existing plan: '<title>'. Resume? (y/n/fresh)"
     * If yes: Skip to step 7 (resume mode)
     * If fresh: Ask for confirmation to overwrite, then continue
     * If no: Exit
   - If no PLAN.md exists: Continue to next step

2. **Check current state:**
   - Run `git status` to see current branch and uncommitted changes
   - If uncommitted changes exist, warn user

3. **Parse input and fetch Jira details (if applicable):**
   - If input contains Jira URL (e.g., https://jira.company.com/browse/ENG-555):
     * Extract ticket ID (e.g., ENG-555)
     * Use Atlassian MCP to fetch ticket details if available
     * Extract: title, description, acceptance criteria, status
     * Store ticket ID for branch naming
   - Otherwise: use input as task description directly

4. **Understand the task:**
   - Analyze the task description (from Jira or direct input)
   - Identify the goal and key requirements
   - Ask clarifying questions if needed

5. **Generate plan (in memory):**
   - Create comprehensive plan with structure:
     * Task title
     * Jira ticket link (if from Jira)
     * Goal (what we're trying to achieve)
     * Approach (high-level strategy)
     * Files to modify/create
     * Implementation steps (numbered, actionable) - will be converted to TDD format if requested
     * Considerations (performance, breaking changes, security, edge cases)
     * Testing strategy

6. **Present plan to user:**
   - Display the full plan
   - Show it formatted as it would appear in PLAN.md

7. **Ask what to create (or resume existing work):**

   **If resuming (from step 1):**
   - Display existing PLAN.md
   - Check for existing todos in session
   - Identify incomplete tasks (pending or in_progress)
   - Show summary: "X completed, Y remaining"
   - Find first incomplete todo and mark as in_progress
   - Ask: "Continue with: '<next task>'? (y/n)"

   **If creating new (normal flow):**
   - "Use TDD approach? (y/n)"
     * If yes: restructure implementation steps with Red-Green-Refactor cycle
     * Each step becomes: Write test → Implement (make test pass) → Refactor
   - "Save this plan to PLAN.md? (y/n)"
     * If TDD mode: include TDD sub-steps in the plan
   - "Create new branch? (y/n)"
     * If yes: suggest branch name using ticket ID if available (e.g., `feature/ENG-555-user-auth`)
     * Get user confirmation, create with `git checkout -b <name>`
   - "Create todo tasks? (y/n)"
     * If yes: use TodoWrite with implementation steps
     * If TDD mode: create sub-tasks for each step (write test, implement, refactor)
   - "Start working on first step? (y/n)"
     * If yes: mark first todo as in_progress

Requirements:
- Use backticks for code references in PLAN.md
- Keep steps actionable and clear
- Consider project patterns and conventions from CLAUDE.md
- If user says yes to starting, mark first todo as in_progress

TDD Mode Formatting:
- When TDD is enabled, structure each implementation step as:
  ```
  1. Add user authentication
     - [ ] Write failing test for `authenticate_user`
     - [ ] Implement `authenticate_user` (minimal code to pass)
     - [ ] Refactor if needed
  ```
- In TodoWrite, create separate tasks for test/implement/refactor
- Use imperative language: "Write test for X", "Implement X", "Refactor X"
