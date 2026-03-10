# Dev Session

Development processes run in a tmux session managed by `dev`.

## Commands

- `dev status` — check all processes (exit code 1 = something stopped)
- `dev logs <process>` — read logs (default 100 lines)
- `dev logs <process> 500` — more scrollback
- `dev restart <process>` — restart one process
- `dev restart` — restart all

Process names match window names in the dev session. Run `dev status` to see them.

## When to use

- Before debugging server errors, check `dev status`
- When tests fail with connection errors, check logs for the relevant process
- After modifying dependencies/migrations, restart the affected process
- Crashed process shows `[<name> exited <code>]` in logs
