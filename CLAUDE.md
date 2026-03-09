## Project

Dotfiles repo managed by dotbot. Symlinks defined in `install.conf.yaml` — add an entry when creating new config files.

- `bin/` → `~/.bin` (scripts available system-wide)
- `claude/` → `~/.claude/` (agents, skills, commands, rules, settings)
- `dotbot/` is a git submodule — never modify it
- `dippy/config` → `~/.dippy/config` (Dippy hook allowlist)

ALWAYS edit files in this repo, never at symlink targets.

No tests or linters in this repo — skip pre-commit checks.

## Permissions

Two layers gate Bash commands — both must allow:
1. `claude/settings.json` `permissions.allow` — Claude Code's built-in permission system
2. `dippy/config` — PreToolUse hook on all Bash calls. Add `allow <command>` for new scripts.

When adding a new script to `bin/` or a new command, add a matching `allow` entry in `dippy/config`.

## Commits

Prefix matches the primary changed directory: `Claude -`, `TMUX -`, `ZSH -`, `Git -`, `Karabiner -`, `Vim -`, etc.
Scripts in `bin/` use the script name as prefix: `notify-claude -`, `claude-retro -`.

ALWAYS check `git log` to confirm the convention before committing.
NEVER introduce a new prefix without asking first.
