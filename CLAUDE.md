## Project

Dotfiles repo managed by dotbot. Symlinks defined in `install.conf.yaml` — add an entry when creating new config files.

- `bin/` → `~/.bin` (scripts available system-wide)
- `claude/` → `~/.claude/` (agents, skills, commands, rules, settings)
- `dotbot/` is a git submodule — never modify it
- `dippy/config` → `~/.dippy/config` (Dippy hook allowlist)

ALWAYS edit files in this repo, never at symlink targets.

No tests or linters in this repo — skip pre-commit checks.

## Permissions

Bash calls resolve in this order (sessions run in auto mode):
1. `dippy/config` via `bin/dippy-auto` (PreToolUse hook). In auto mode only explicit rules reach Claude Code: every `deny`, and every `ask` whose message starts `Confirm:`. dippy's `allow` and its built-in handlers' asks apply only outside auto mode.
2. `~/.claude/hooks/rtk-rewrite.sh` (PreToolUse hook, installed by rtk, not in this repo) returns `allow` for every command it rewrites unless a settings.json deny/ask rule matches it.
3. `claude/settings.json` `permissions.allow` — approves without the classifier.
4. Anything else goes to the auto-mode classifier.

Hook decisions rank deny > ask > allow, so only a dippy `Confirm:` ask or `deny` stops a command; dropping its `permissions.allow` prefix does not, because rtk still allows it.

- Hard gate (push, merge, posting, prod access): `ask <pattern> "Confirm: <why>"` in `dippy/config`.
- Convention to enforce: `deny <pattern> "<what to use instead>"` in `dippy/config`.
- New script in `bin/`: a `permissions.allow` entry to skip the classifier, plus an `allow` in `dippy/config` for Manual mode.

## Commits

Prefix matches the primary changed directory: `Claude -`, `TMUX -`, `ZSH -`, `Git -`, `Karabiner -`, `Vim -`, etc.
ALWAYS check `git log` to confirm the convention before committing.
NEVER introduce a new prefix without asking first.
