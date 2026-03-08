---
description: Daily retro analyzing Claude Code usage across projects
argument-hint: [today|yesterday|YYYY-MM-DD]
---

Run a daily retrospective on Claude Code usage.

1. Run `claude-retro $ARGUMENTS` (defaults to today)
2. Analyze the JSON output looking for:

**Productivity**
- Sessions and prompts per project — where was time spent?
- Commits made — use commit messages to describe what was shipped
- Duration patterns — long productive sessions vs short abandoned ones
- Overlapping wall clocks across projects — how much context-switching happened?

**Hurdles & Frustrations**
- Tool errors — what kept failing and why?
- Short/abandoned sessions — what caused giving up?
- Repeated similar prompts — signs of retrying or struggling
- High prompt count with low commits — spinning wheels?

**Workflow Patterns**
- Which tools were used most? Any surprising patterns?
- Team/agent usage — were debate/review/investigate used effectively?
- Model distribution — right models for right tasks?
- Note: meta prompts (/usage, /clear, etc.) are filtered from counts

**Improvements**
- Recurring errors that could be prevented with better config or rules
- Workflow gaps — steps that could be automated
- Patterns worth adding to CLAUDE.md or memory

Present the retro as a concise narrative, not raw data dumps. Be honest about what went poorly. End with 2-3 actionable takeaways.
