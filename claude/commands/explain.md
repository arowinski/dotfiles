---
description: Explain code structure (class, method, pattern)
argument-hint: <what to explain>
allowed-tools: Bash(git log:*), Bash(git blame:*), Read, Glob, Grep
---

Explain the specified code element with full context.

Accept natural language queries (e.g., "how does the auth service work?" or just "UserService").

If no argument provided, ask user what they want explained.

Process:

1. **Parse query:**
   - Extract the actual target from natural language
   - Examples: "how does X work?" → X, "explain UserService" → UserService

2. **Find the code:**
   - Use Grep to locate the target (class, method, file, pattern)
   - If multiple matches, ask user which one

3. **Read and analyze:**
   - Read the relevant file(s)
   - Understand what the code does
   - Identify key dependencies and relationships

4. **Git history context:**
   - Use `git log --follow -p -- <file>` to see when it was created and why
   - Use `git blame <file>` to see recent changes
   - Extract commit messages for context

5. **Find usage:**
   - Use Grep to find where it's used in the codebase
   - Identify common patterns

6. **Provide explanation:**
   - **Purpose:** What it does and why it exists
   - **How it works:** Key logic and flow
   - **Usage examples:** Real examples from codebase
   - **Related code:** Other classes/methods that interact with it
   - **History:** When created, major changes, why changed
   - **Tests:** Where it's tested

Format:
- Use backticks for code references
- Keep it concise but thorough
- Focus on "why" not just "what"
- Include file paths with line numbers for easy navigation (e.g., `app/models/user.rb:42`)
