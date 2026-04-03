---
description: Plan a task and create workspace. Use before starting non-trivial feature work.
disable-model-invocation: true
argument-hint: <task description or Jira URL>
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git switch:*), Bash(git fetch:*), Bash(git rev-parse:*), Bash(mkdir:*), Read, Write, Glob, Grep, Agent, Skill, EnterPlanMode, ExitPlanMode, TaskCreate, TaskUpdate, TaskList, TeamCreate, SendMessage
---

Plan the given task.

Accept task description, pasted requirements, or Jira URL.

If no argument provided, ask user for task description.

File locations (shared across worktrees):
- Run `git rev-parse --git-common-dir` to get the shared git directory
- Plan file: `<git-dir>/claude/plans/<branch-name>.md`
- Research file: `<git-dir>/claude/plans/<branch-name>-research.md`

## Resume

Before starting, check for existing work:
- Derive branch name from current branch (`git branch --show-current`)
- Check if plan file exists
- If exists:
  * Read the plan to extract task title
  * Ask: "Found existing plan: '<title>'. Overwrite? (y/n)"
  * If yes: continue to Process
  * If no: tell the user to run `/work` to continue implementing, then exit
- If no plan file exists: continue to Process

## Process

1. **Check current state:**
   - Run `git status` to see current branch and uncommitted changes
   - If uncommitted changes exist, warn user

2. **State intent:** Before diving in, verbalize: "I detect [research/implementation/fix/refactor] intent. My approach: [brief plan]." — makes routing visible and correctable before work begins.

3. **Parse input and fetch Jira details (if applicable):**
   - If input contains Jira URL (e.g., https://jira.company.com/browse/ENG-555):
     * Extract ticket ID (e.g., ENG-555)
     * Use Atlassian MCP to fetch ticket details if available
     * Extract: title, description, acceptance criteria, status, issue type
     * Store ticket ID for branch naming
   - Otherwise: use input as task description directly
   - **Save raw ticket details** (title, description, AC, status) — these will be written to the plan file so context survives session compression

4. **Create branch:**
   - "Create new branch? (y/n)"
     * Use lowercase ticket ID as branch name (e.g., `eng-555`), add suffix only if ticket already has branches
     * For non-Jira tasks, derive short kebab-case name from description
     * Create from latest main/master: `git fetch origin && git switch -c <name> origin/main` (or `origin/master`)
   - If no: stay on current branch (but branch must not be main — ask for a name if it is)

Enter plan mode with EnterPlanMode before researching.

5. **Research codebase (delegate to architect agent):**

   Use the Agent tool with `subagent_type: architect` for research.

   Tell the architect to research the task and find:
   - Similar implementations — patterns to follow
   - Affected code — files, dependencies, callers
   - Constraints — validations, API contracts, database implications
   - Risks — what could break, edge cases
   - 2-3 possible approaches with trade-offs, simplest first

   Include the full task description and any Jira details. Ask for concrete findings with file paths and evidence, and to clearly flag any blockers or conflicts.

   **Wait for architect to complete**, then review findings.

   **If architect reports blockers:**
   - Present blockers to user
   - Ask how to proceed before continuing
   - Don't generate a plan based on assumptions

6. **Present approaches and pick one:**

   Show the architect's 2-3 approaches with trade-offs. Ask the user which direction to take. Generate the plan based on the chosen approach.

7. **Generate and present plan:**

   Exit plan mode with ExitPlanMode.

   - Save raw research to the research file
   - Write plan to plan file with structure:
     * Task title
     * Jira ticket link (if from Jira)
     * Jira ticket details (if from Jira): description, acceptance criteria, issue type — preserve these verbatim so context survives session compression
     * Goal (what we're trying to achieve)
     * Research findings (patterns found, constraints, risks)
     * Approach (high-level strategy based on research)
     * Decision rationale (why this approach over alternatives, key trade-offs, what the user clarified)
     * Files to modify/create (concrete list from research)
     * Edge cases and considerations
     * Implementation steps (numbered, actionable; use TDD when it makes sense)
     * Testing strategy
   - Display the plan to user
   - Create a todo task (TaskCreate) for each implementation step

8. **Verify plan against codebase:**

   Dispatch a subagent (architect) to verify the plan's assumptions:
   - Do all file paths in the plan actually exist and have the expected structure?
   - Are all acceptance criteria from the ticket covered by implementation steps?
   - Are there dependencies between steps that aren't declared?
   - Does the plan assume patterns that don't match the actual code?
   - YAGNI: could any step be removed without breaking acceptance criteria? Is anything built for hypothetical future requirements?

   If issues found, fix the plan before continuing.

9. **Debate the plan (optional):**

   "Debate this plan? (y/n)" — if yes, invoke `/debate` with the plan file content and 4 perspectives: Pragmatist (simplest way to ship), Skeptic (what will break), Advocate (why this approach is right), Architect (long-term codebase impact).

   After debate completes, if changes are warranted, update the plan file and tasks.

Tell the user to run `/work` or `/team` to start implementing.

**Tip:** If the approach wasn't explored upfront, suggest `/brainstorm` before planning next time.

## Requirements

- Use backticks for code references in plan file
- Consider project patterns and conventions from CLAUDE.md
- When uncertain about requirements or approach, ask — never guess
