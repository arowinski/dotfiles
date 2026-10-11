## Project

Dotbot links `~/.claude/*`, `~/.bin`, `~/.dippy/config` and the rest into this repo (`install.conf.yaml`): edit the repo path, and add a link entry with each new config file. `dotbot/` is a submodule; leave it untouched.

Tests live only in `claude/mods/*/hooks/*.test.ts`; nothing else here has tests or linters.

Log each change meant to improve Claude's behaviour or token use in `~/.claude/retro-log.md` the day it lands, under `## YYYY-MM-DD (outside a retro)`, in `claude/commands/retro.md`'s `Fixes applied` format, so the next `/retro` can judge it.

New script in `bin/`: a `permissions.allow` entry in `claude/settings.json` to skip the classifier, plus an `allow` in `dippy/config` for Manual mode.

## Commits

Commit prefix names the tool the change serves, as in `git log` (`Claude -` covers `claude/`, `dippy/`, and Claude's `bin/` scripts); a new prefix needs the user's OK.
