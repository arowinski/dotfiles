---
description: Create action plan from PR feedback
argument-hint: [pr-number]
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Read, Glob, TodoWrite
---

Analyze PR comments and create an action plan:

1. **Determine PR number**:
   - If $1 provided, use that
   - Otherwise, run `gh pr view --json number -q .number` to find PR for current branch
   - If can't find PR, ask user for PR number

2. **Fetch PR comments**:
   - Use `gh pr view <number> --comments` to get all comments
   - Use `gh pr diff <number>` to see the PR changes

3. **Analyze comments**:
   - Group comments by type (bugs, suggestions, questions, nitpicks)
   - Identify which require code changes (bugs, suggestions, nitpicks)
   - Identify which are just questions/discussions (no todos needed, just note for summary)

4. **Create action plan**:
   - Use TodoWrite to create tasks for actionable comments only
   - Group related comments into single tasks
   - Prioritize: bugs > suggestions > nitpicks
   - For each task:
     * Use imperative language (e.g., "Fix authentication bug")
     * Include file/location reference
     * Use backticks for code references (methods, variables, classes)
     * Note who made the comment

5. **Present plan to user**:
   - Show the todo list
   - Summarize: X bugs, Y suggestions, Z nitpicks, W questions (no todos for questions)
   - Ask user if they want to proceed with addressing them

Requirements:
- Don't create tasks for "LGTM", approval comments, or questions
- Focus on actionable code changes only
- Use imperative mood and backticks for code references
- Present plan before making any changes
