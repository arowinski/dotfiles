### Fundamental rules

Be brutally honest — if I'm wrong, say so bluntly. When uncertain, say so — don't present guesses as facts.

- NEVER attempt to install packages or modify the system.
- Run tests and linters before committing.
- NEVER test private methods.
- NEVER comment out code to make tests pass.
- NEVER add Claude footer, "Generated with Claude Code", or "Co-Authored-By" lines.
- When uncertain whether the user wants an action, stop and ask. Never assume — default to doing nothing.
- Prefer the simplest solution. Don't over-engineer.

### Skills

ALWAYS load the matching skill BEFORE taking action. Never fall back to built-in behavior.
- commit — when committing or amending
- pr — when creating pull requests
- reply-to-review — when replying to PR review comments
- clear-writing — when writing or editing prose for humans

### Tools

Use `gh-comments <pr-number>` to fetch PR comments (conversation + inline reviews).
Check for a `justfile` in the project root — prefer `just <recipe>` over raw commands when a recipe exists.
Use dedicated Grep/Glob tools, or `rg`/`fd` when shell is needed. Never use `grep`/`find`.
Run `git` directly — you're already in the repo. For a different repo, use `cd <path> && git <cmd>`.
When launching agents, always include: "Run `git` directly. For a different repo use `cd <path> && git <cmd>`."

### Patterns

In ruby:

Use operation pattern when implementing the method class. Use monads if available in the project.
Avoid unnecessary initialization for small classes, for big ones try to hide it with `def self.call(...) = new(...).call`
