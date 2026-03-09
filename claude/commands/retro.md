---
description: Daily retro analyzing Claude Code usage across projects
argument-hint: [today|yesterday|YYYY-MM-DD]
---

Run a daily retrospective on Claude Code usage.

1. Run `claude-retro $ARGUMENTS` (defaults to today)
2. Analyze the JSON output. Only report findings — skip anything that looks fine.

**What went wrong** — this is the retro. Use stats as evidence, not as standalone items. Look for:
- Permission friction — check `permissions.suggest_allow` for commands with 3+ asks. Only recommend allowing read-only commands; for everything else, report the friction but don't suggest allowing.
- Tool errors and repeated failures
- Short/abandoned sessions — what caused giving up?
- Repeated similar prompts — signs of retrying or struggling
- High prompt count with low commits — spinning wheels?
- Sessions with `corrections` > 0 — signs Claude misunderstood or overstepped. Read the prompts to understand what went wrong.
- High `model_calls_per_prompt` — Claude churning (doing lots of work per prompt without clear direction). Compare across sessions to spot outliers.

**Observations** — patterns worth noting: team/agent effectiveness, workflows worth repeating, automatable manual steps.

**Fixes** — concrete, actionable changes to config, rules, skills, or workflow. No vague suggestions.

Be brief — bullet points, not paragraphs. If the day was clean, say so and stop.
