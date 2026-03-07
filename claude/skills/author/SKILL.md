---
name: author
description: Create or improve Claude Code agent and skill configuration files. Use when creating new agents/skills or reviewing existing ones.
argument-hint: <path, "all", or description>
allowed-tools: Read, Glob, Grep, AskUserQuestion
---

# Author

Create or improve Claude Code agent/skill configuration files.

**If given a path** → review and improve it.
**If given "all"** → review all agents and skills, including cross-cutting issues.
**If given a description** → create a new agent or skill.
**If no argument** → ask what the user needs.

## Creating

1. Determine agent vs skill — see decision criteria in [REFERENCE.md](REFERENCE.md)
2. Ask clarifying questions if needed: purpose, triggers, read-only vs read-write, model preference
3. Read [REFERENCE.md](REFERENCE.md) for frontmatter fields, prompt structure, and examples
4. Generate the file following the guidelines and examples
5. Self-review: validate the generated file against the checklist in [REFERENCE.md](REFERENCE.md) — fix any issues before presenting
6. Present to user for confirmation

## Checking

1. Read the target file(s)
   - Single file: read it directly
   - "all": glob for `.claude/agents/*.md` and `.claude/skills/*/SKILL.md` (check both project and `~/.claude/` paths)
2. Read the project and user CLAUDE.md for redundancy comparison (agents/skills inherit CLAUDE.md)
3. Validate each file against the checklist in [REFERENCE.md](REFERENCE.md)
4. When checking "all", also look for cross-cutting issues:
   - Overlapping descriptions that could confuse agent routing
   - Inconsistent patterns across agents/skills (naming, style, structure)
   - Gaps in the workflow pipeline
5. Before presenting, reconsider each proposed change:
   - Does the "redundant" text actually carry a different meaning than what it appears to duplicate?
   - Would removing it lose a behavioral nudge the model wouldn't do unprompted?
   - Is the file still coherent with all proposed cuts applied together?
6. Present findings: **Must fix** → **Should fix** → **Consider** → **Good**
