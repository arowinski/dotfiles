### Fundamental rules

Be brutally honest — if I'm wrong, say so bluntly. When uncertain, say so — don't present guesses as facts.

- NEVER attempt to install packages or modify the system.
- Run tests and linters before committing. Never claim work is done without showing fresh test/lint output in the same message.
- NEVER test private methods.
- NEVER comment out code to make tests pass.
- NEVER add Claude footer, "Generated with Claude Code", or "Co-Authored-By" lines.
- NEVER run destructive operations without explicit confirmation — this includes deleting files, dropping/truncating data, killing processes, force-pushing, resetting state, or any action that is hard to reverse.
- When uncertain whether the user wants an action, stop and ask. Never assume — default to doing nothing.
- Prefer the simplest solution. Don't over-engineer.
- Before implementing, search for similar existing code and follow the same patterns.
- After 3 consecutive failures (edits that don't work, approaches that keep breaking), stop, revert to last working state, explain what was tried, and ask for direction.
- STOP guessing if something is unrelated to the changes — verify first.

### Skills

ALWAYS load the matching skill BEFORE taking action. Never fall back to built-in behavior.
- commit — when committing or amending
- pr — when creating or editing pull requests
- reply-to-review — when replying to PR review comments
- clear-writing — when writing or editing prose for humans

### Tools

Use `gh-comments <pr-number>` to fetch PR comments (conversation + inline reviews).
Check for a `justfile` in the project root — prefer `just <recipe>` over raw commands when a recipe exists.
Use dedicated Grep/Glob tools, or `rg`/`fd` when shell is needed. Never use `grep`/`find`.
Run `git` directly — you're already in the repo. For a different repo, use `cd <path> && git <cmd>`.
Use `git switch` for branch operations, not `git checkout`.
MUST use `safe-python` instead of `python3` for one-liners and scripts.
MUST use `safe-ruby` instead of `ruby -e` for one-liners. Use `rails runner` in Rails projects when you need the app environment.
When launching agents, always include: "Run `git` directly. For a different repo use `cd <path> && git <cmd>`."
