# Agent & Skill Reference

## Agent vs Skill

| Question | Agent | Skill |
|----------|-------|-------|
| Produces verbose output that would bloat main context? | Yes | |
| Needs main conversation history? | | Yes |
| Should run in background? | Yes | |
| User invokes as a command? | | Yes (with `disable-model-invocation: true`) |
| Needs its own model (cheaper or more capable)? | Yes | |
| Benefits from cross-session memory? | Yes (with `memory`) | |
| Provides background knowledge/conventions? | | Yes (with `user-invocable: false`) |

Skills can also fork to a subagent with `context: fork` + `agent:` — getting isolation like an agent but invoked as a slash command.

Slash commands are merged into skills: `.claude/commands/foo.md` and `.claude/skills/foo/SKILL.md` both create `/foo` with the same frontmatter. Prefer the skill (directory) form for new work — it supports supporting files — and a skill wins a name clash.

A model-invocable skill can also dispatch a subagent mid-workflow by listing `Agent` in `allowed-tools` and calling the Agent tool with a `subagent_type` (e.g. `design` spawns `architect`). The skill keeps running and orchestrates the result — distinct from `context: fork`, where the whole body runs as one forked subagent. `Agent(type1, type2)` allowlist syntax only applies to a main-thread agent run via `--agent`; it's ignored inside a normal subagent.

## Agent Frontmatter

| Field | Required | Guidance |
|-------|----------|----------|
| `name` | Yes | lowercase-with-hyphens |
| `description` | Yes | Third person, action-oriented; what it does + when. Favor concrete trigger phrases over brevity — no fixed char cap on agent descriptions |
| `model` | No | Aliases `haiku`/`sonnet`/`opus`/`fable` (+ `best`/`opusplan`) auto-resolve to the current build; pin a build with a full ID (`claude-opus-4-8`, `claude-sonnet-4-6`, `claude-haiku-4-5`) or `[1m]` context variant. Default `inherit` = main-conversation model. Task-fit under Model Selection; for exact current IDs consult the `/claude-api` skill, don't hardcode |
| `tools` | No | Allowlist. If omitted, inherits ALL tools |
| `disallowedTools` | No | Denylist. Use YAML list syntax |
| `memory` | No | `user` (cross-project), `project`, or `local` |
| `color` | No | Background color in UI |
| `maxTurns` | No | Limit agentic turns |
| `effort` | No | `low`/`medium`/`high`/`xhigh`/`max`; overrides session effort while the agent runs |
| `initialPrompt` | No | Auto-submitted first turn — ONLY when the agent runs as the main session (`--agent`/`agent` setting), not as a spawned subagent |
| `skills` | No | Preload skill content into agent context |
| `mcpServers` | No | MCP servers available to agent |
| `hooks` | No | Lifecycle hooks scoped to agent |
| `permissionMode` | No | `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan` |
| `background` | No | `true` to always run in background |
| `isolation` | No | `worktree` runs the agent in a temp git worktree branched from your DEFAULT branch (not current HEAD); auto-removed if it makes no changes |

**Plugin-shipped agents/skills are namespaced** (`plugin-name:agent`, `/plugin-name:skill`). Plugin agents CANNOT use `hooks`, `mcpServers`, or `permissionMode` — silently ignored for security; copy the file into `.claude/agents/` to use those.

## Skill Frontmatter

| Field | Required | Guidance |
|-------|----------|----------|
| `name` | No | lowercase-with-hyphens, max 64 chars. Defaults to directory name |
| `description` | Recommended | What it does AND when. Third person. With `when_to_use`, truncated at ~1,536 chars in the listing (configurable via `maxSkillDescriptionChars`); lead with the key trigger |
| `when_to_use` | No | Extra trigger phrases/example contexts; appended to `description`, counts toward the same ~1,536-char cap |
| `disable-model-invocation` | No | `true` for side-effect skills (commit, deploy, PR) |
| `user-invocable` | No | `false` for background knowledge users shouldn't invoke directly |
| `allowed-tools` | No | Pre-approves tools (no per-use prompt) when active; does NOT restrict the pool — use `disallowed-tools` to remove tools |
| `disallowed-tools` | No | Remove tools from the available pool while the skill is active |
| `model` | No | Model override when active |
| `argument-hint` | No | Hint in autocomplete (e.g., `[pr-number]`) |
| `arguments` | No | Named positional args for `$name` substitution (YAML list or space-separated; order maps to positions) |
| `paths` | No | Glob patterns gating auto-activation to matching files |
| `effort` | No | Override session effort while active (`low`…`max`; availability per model) |
| `shell` | No | `bash` (default) or `powershell` (needs `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`) |
| `context` | No | `fork` to run in isolated subagent |
| `agent` | No | Subagent type when `context: fork` |
| `hooks` | No | Lifecycle hooks scoped to skill |

**Skills do NOT support `skills:` preloading.** That field is agent-only (see Agent table). A `skills:` key in a SKILL.md is silently ignored. For one skill to reuse another's rules: invoke the other skill via the `Skill` tool (add `Skill` to `allowed-tools`), reference it in the body, or `context: fork` to a subagent that preloads both. Don't copy the other skill's content inline.

## Prompt Structure

1. **Load-bearing constraint first** — open with the highest-priority behavioral constraint or the workflow. An identity/role line ("You are a…") is optional and often cut as filler; the repo's agents open straight into the constraint
2. **Scope boundaries** — what it does NOT do
3. **Workflow** — numbered steps, clear decision points
4. **Output format** — bold headers, not code-fenced templates (model mimics formatting it sees — code fence → code block output)

Keep SKILL.md under 500 lines — its body reloads into context every turn, so trim it to the workflow + decisions and move long tables/examples/checklists to a companion (e.g. REFERENCE.md) linked from the body and read on demand. (This skill is split that way.)

## Dynamic context & supporting files

- Inline shell output into the skill body before Claude reads it: `` !`command` `` (at line start or after whitespace) or a ` ```! ` fenced block — runs once, output not re-scanned. How a /commit-style skill pre-loads `git status`.
- Reference bundled scripts via `${CLAUDE_SKILL_DIR}` (the skill's own dir). Put long reference text in supporting files and scripts in `scripts/`, called on demand — not loaded into context — for progressive disclosure; keeps the always-loaded body small.

## Tool Scoping

- Read-only roles (researchers, reviewers): `disallowedTools: [Write, Edit, NotebookEdit]`
- Side-effect roles: explicitly list only `tools` needed
- Scope Bash to specific commands, not bare `Bash`: `allowed-tools: Bash(git:*), Bash(gh-comments:*)` — each entry is one command pattern (space/comma-separated)
- No `tools` or `disallowedTools` = inherits ALL tools. Flag for any agent that shouldn't write

## Model Selection

- **Haiku**: CI monitoring, simple lookups, high-frequency tasks (cheap, fast)
- **Sonnet**: Balanced work, code generation, moderate complexity
- **Opus**: Architecture decisions, complex reasoning, code review

## Examples

### Agent

```yaml
---
name: security-reviewer
description: Scan code changes for security vulnerabilities. Use after implementing auth, input handling, or API endpoints.
model: sonnet
disallowedTools:
  - Write
  - Edit
  - NotebookEdit
---

You are a security-focused code reviewer. Analyze changes for OWASP Top 10 vulnerabilities, auth bypasses, and data exposure.

**You do NOT:** suggest feature improvements or style changes. Security only.

## Workflow

### 1. Scope
Run `git diff` to identify changed files. Focus on auth, user input, database queries, API responses.

### 2. Analyze
For each file check: SQL injection, XSS, auth bypasses, data exposure, input validation.

### 3. Report

**Critical** (exploit risk)
- [issue with file:line and fix]

**Warning** (potential risk)
- [issue with context]

**Clear**
- [what was checked and found safe]
```

### Skill

```yaml
---
name: changelog
description: Generate changelog entries from recent commits. Use when preparing releases or documenting changes.
disable-model-invocation: true
argument-hint: [since-tag]
allowed-tools: Read, Glob, Grep
---

Generate a changelog from commits since $ARGUMENTS (default: last tag).

1. Run `git log --oneline <since>..HEAD`
2. Group by type: Features, Fixes, Other
3. Write concise, user-facing descriptions (not raw commit messages)
4. Output as markdown under `## [Unreleased]`
```

## Checklist

### Structural
- Required frontmatter fields present
- Description is concise, third-person, action-oriented
- Description includes both WHAT and WHEN
- Tool scoping matches the role
- Model appropriate for task complexity
- File ends with newline
- Under 500 lines

### Quality
- No instructions duplicated from CLAUDE.md (inherited automatically)
- No internal redundancy (same concept in multiple sections)
- No generic filler an LLM already knows
- No motivational closers ("Remember: you are the last line of defense...")
- Output format defined and practical
- Concrete examples over abstract descriptions
- MCP refs in prose/body hedge with "if available" for portability; `allowed-tools`/`tools` frontmatter list MCP patterns directly (`mcp__server__*`, no hedge)

### Anti-patterns
- No code-fenced output templates (use bold headers)
- No verbose examples where one suffices
- Description doesn't start with "Use this agent to..." (action-oriented instead)
- No conflicting instructions between sections
