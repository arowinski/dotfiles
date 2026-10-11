---
paths:
  - "dippy/config"
  - "claude/settings.json"
  - "bin/dippy-auto"
---

# Permissions

Bash calls resolve in this order (sessions run in auto mode):
1. `dippy/config` via `bin/dippy-auto` (PreToolUse hook). In auto mode only explicit rules reach Claude Code: every `deny`, and every `ask` whose message starts `Confirm:`. dippy's `allow` and its built-in handlers' asks apply only outside auto mode.
2. `~/.claude/hooks/rtk-rewrite.sh` (PreToolUse hook, installed by rtk, not in this repo) returns `allow` for every command it rewrites unless a settings.json deny/ask rule matches it.
3. `claude/settings.json` `permissions.allow`: approves without the classifier.
4. Anything else goes to the auto-mode classifier.

Hook decisions rank deny > ask > allow: removing a `permissions.allow` entry stops nothing rtk rewrites; a stop needs a deny (dippy, settings.json, or a `bin/claude-gate-*` hook) or a dippy `Confirm:` ask.

- Hard gate (push, merge, posting, prod access): `ask <pattern> "Confirm: <why>"` in `dippy/config`.
- Convention to enforce: `deny <pattern> "<what to use instead>"` in `dippy/config`.
