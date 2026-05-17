---
description: Daily retro analyzing Claude Code usage across projects
argument-hint: [today|yesterday|YYYY-MM-DD]
---

Run a daily retrospective on Claude Code usage.

1. Read the retro log at `~/.claude/retro-log.md` (if it exists) — check last 3-5 entries for recurring issues and unresolved fixes
2. Run `claude-retro $ARGUMENTS` (defaults to today)
3. Analyze the JSON output. If the day was clean, say so and stop.

## Analysis

Don't report stats. Find the 2-3 most notable sessions and explain what happened in plain language.

**Permission friction** — check `permissions.suggest_allow` for commands with 3+ asks. Only recommend allowing read-only or safe commands; for everything else, report the friction but don't suggest allowing.

**Corrections** — sessions with `corrections` > 0 are the highest-signal finding. Read the actual correction prompts, then explain: what did the user ask? What did Claude do instead? What rule, config, or workflow change would prevent it?

**Churning** — flag sessions where `model_calls_per_prompt` is notably higher than others. Cross-reference with the prompt text and commit count to judge whether the high ratio was justified (complex task) or wasteful (simple task, Claude spinning). Compare the session's `intent` (first prompt) against what was actually committed.

**Session outcomes** — sessions with many prompts but no commits (`outcome: no-commit`) deserve a look. Was it a research/analysis session (fine) or did the user give up (problem)?

**Recurring issues** — if the retro log shows the same issue appearing in past entries (e.g., same permission friction, same type of correction), flag it explicitly: "This is the Nth time X has appeared — still not addressed."

**Manual workflow patterns (cross-session)** — run `claude-retro` for each of the last 7 days and aggregate user first-prompts (the first prompt of each session is the intent signal; later prompts are follow-ups within the same task). Group by topic / verbs / target (e.g., "research module X", "write moduledoc for Y", "debug error Z").

Flag patterns repeated 3+ times where no skill auto-triggered and no slash command was invoked. For each pattern, identify the likely cause and suggest the cheapest viable fix. Default to non-skill solutions before proposing a new skill.

Fix menu, ordered cheapest first:
- **Trigger fix**: an existing skill should match the pattern but its description's keywords don't. Adjust the description.
- **Behavior fix**: an existing skill matches but does the wrong thing for this case. Tweak its workflow.
- **CLAUDE.md rule**: a one-liner instruction handles it (e.g., "when X, do Y first"). No skill needed.
- **Rule file** (`.claude/rules/*.md`): auto-loads on path glob, applies project-wide guidance.
- **Hook** (PreToolUse / PostToolUse): always-on automation tied to a tool event.
- **Bin script / shell alias**: handle the pattern outside Claude entirely (often the simplest fix).
- **New skill**: only when the pattern is non-trivial workflow that doesn't fit smaller fixes.
- **Accept manual**: sometimes the pattern is too vague or context-dependent to formalize. Do nothing.

Cost: adds 6 extra `claude-retro` calls per /retro run.

## Output

**What went wrong** — narrate the friction. Use prompts as evidence.

**Recurring** — issues from past retros that are still showing up.

**Fixes** — concrete changes to config, rules, skills, or workflow. No vague suggestions.

**Manual workflow patterns** — patterns repeated 3+ times this week with no skill auto-trigger. Format per candidate:
- `<pattern summary>` (Nx, last seen <day>)
  - Cause: `<trigger gap | behavior gap | vague intent | no tool exists>`
  - Fix: `<trigger tweak | behavior tweak | CLAUDE.md rule | rule file | hook | bin script | new skill | accept manual>`
  - Why: `<one-line rationale for choosing this fix over alternatives>`

Be brief — bullet points, not paragraphs.

## Log

After presenting, append a summary to `~/.claude/retro-log.md`:

```
## YYYY-MM-DD

- [finding 1]
- [finding 2]
- Fixes proposed: [list]
- Fixes applied: [list, if any were applied this session]
```

Keep entries concise — 3-5 bullets max per day. The log is for future retros to reference, not a full report.
