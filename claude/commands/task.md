---
description: Plan a task and create workspace
argument-hint: <task description or Jira URL>
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git checkout:*), Bash(git fetch:*), Bash(git rev-parse:*), Bash(mkdir:*), Read, Write, Glob, Grep, Agent, EnterPlanMode, ExitPlanMode, TaskCreate, TaskUpdate, TaskList
---

Create a comprehensive plan for the given task.

Accept task description, pasted requirements, or Jira URL.

If no argument provided, ask user for task description.

File locations (shared across worktrees):
- Run `git rev-parse --git-common-dir` to get the shared git directory
- Plan file: `<git-dir>/claude/plans/<branch-name>.md`
- Research file: `<git-dir>/claude/plans/<branch-name>-research.md`

Enter plan mode with EnterPlanMode before starting.

Process:

1. **Check for existing work:**
   - Derive branch name from current branch (`git branch --show-current`)
   - Check if plan file exists
   - If exists:
     * Read the plan to extract task title
     * Ask: "Found existing plan: '<title>'. Resume? (y/n/fresh)"
     * If yes: Skip to step 6 (resume mode)
     * If fresh: Ask for confirmation to overwrite, then continue
     * If no: Exit
   - If no plan file exists: Continue to next step

2. **Check current state:**
   - Run `git status` to see current branch and uncommitted changes
   - If uncommitted changes exist, warn user

3. **Parse input and fetch Jira details (if applicable):**
   - If input contains Jira URL (e.g., https://jira.company.com/browse/ENG-555):
     * Extract ticket ID (e.g., ENG-555)
     * Use Atlassian MCP to fetch ticket details if available
     * Extract: title, description, acceptance criteria, status, issue type
     * Store ticket ID for branch naming
   - Otherwise: use input as task description directly
   - **Save raw ticket details** (title, description, AC, status) — these will be written to the plan file in step 6 so context survives session compression

4. **Research codebase (delegate to architect agent):**

   Use the Agent tool with `subagent_type: architect` for research.

   **Prompt for architect:**
   ```
   Research this task: [task description]

   Find and report:
   1. Similar implementations - patterns to follow
   2. Affected code - files, dependencies, callers
   3. Constraints - validations, API contracts, database implications
   4. Risks - what could break, edge cases

   Be thorough. Search the codebase, read relevant files.
   Return concrete findings with file paths and evidence.
   If you find blockers or conflicts, say so clearly.
   ```

   **Wait for architect to complete**, then review findings.

   **If architect reports blockers:**
   - Present blockers to user
   - Ask how to proceed before continuing
   - Don't generate a plan based on assumptions

   Exit plan mode with ExitPlanMode.

5. **Create branch:**
   - "Create new branch? (y/n)"
     * Use lowercase ticket ID as branch name (e.g., `eng-555`), add suffix only if ticket already has branches
     * For non-Jira tasks, derive short kebab-case name from description
     * Create from latest main/master: `git fetch origin && git checkout -b <name> origin/main` (or `origin/master`)
   - If no: stay on current branch (but branch must not be main — ask for a name if it is)

6. **Generate and present plan:**

   **If resuming (from step 1):**
   - Exit plan mode with ExitPlanMode
   - Display existing plan file
   - Show progress: "X completed, Y remaining"
   - Mark first incomplete todo as in_progress
   - Ask: "Continue with: '<next task>'?"
   - Stop here

   **New plan:**
   - Save raw research to the research file
   - Write plan to plan file with structure:
     * Task title
     * Jira ticket link (if from Jira)
     * Jira ticket details (if from Jira): description, acceptance criteria, issue type — preserve these verbatim so context survives session compression
     * Goal (what we're trying to achieve)
     * Research findings (patterns found, constraints, risks)
     * Approach (high-level strategy based on research)
     * Files to modify/create (concrete list from research)
     * Edge cases and considerations
     * Implementation steps (numbered, actionable; use TDD when it makes sense)
     * Testing strategy
   - Display the plan to user
   - Create a todo task (TaskCreate) for each implementation step
   - "Start working on first step? (y/n)"
     * If yes: mark first todo as in_progress

Requirements:
- Use backticks for code references in plan file
- Consider project patterns and conventions from CLAUDE.md
- When uncertain about requirements or approach, ask — never guess
