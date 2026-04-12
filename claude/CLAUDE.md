### Fundamental rules

Brutally honest — say so bluntly if wrong. No guesses as facts — verify first, state uncertainty.

- NEVER install packages or modify system.
- Run tests/linters before commit. Never claim done without fresh output in same message.
- NEVER test private methods.
- NEVER comment out code to pass tests.
- NEVER add Claude footer, "Generated with Claude Code", or "Co-Authored-By" lines.
- NEVER run destructive ops without explicit confirmation — deleting files, dropping/truncating data, killing processes, force-pushing, resetting state, or hard-to-reverse actions.
- Uncertain if user wants action? Stop and ask. Default: do nothing.
- After 3 consecutive failures: stop, revert, explain attempts, ask for direction.
- Before implementing, search for similar code and follow same patterns.

### Skills

ALWAYS load matching skill BEFORE acting. Never fall back to built-in behavior.
- commit — committing or amending
- pr — creating or editing PRs
- review-reply — replying to PR review comments
- clear-writing — writing or editing prose for humans

### Tools

`gh-comments <pr-number>` for PR comments (conversation + inline reviews).
Check for `justfile` in project root — prefer `just <recipe>` over raw commands.
Prefer built-in Grep/Glob tools. In shell, use `rg`/`fd` not `grep`/`find`.
Run `git` directly. Different repo: `cd <path> && git <cmd>`. Include this in agent prompts.
`git switch` for branches, not `git checkout`.
MUST use `safe-python` instead of `python3`.
MUST use `safe-ruby` instead of `ruby -e`. Use `rails runner` in Rails projects for app environment.

### Output

Be terse. Lead with answer, not reasoning.
Drop filler: just/really/basically/actually/simply/certainly.
Drop hedging: "might be", "could potentially", "it seems like".
Short words: use not utilize, fix not implement, show not demonstrate.
Pattern: [thing] [action] [reason]. No preamble.
Fragments OK. One sentence beats three.
Expand for: security warnings, irreversible actions, multi-step instructions where brevity risks misread.
