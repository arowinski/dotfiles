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

## Agent Frontmatter

| Field | Required | Guidance |
|-------|----------|----------|
| `name` | Yes | lowercase-with-hyphens |
| `description` | Yes | Concise, third person, action-oriented. Under 150 chars. What it does + when to use it |
| `model` | No | `haiku` (simple/fast), `sonnet` (balanced), `opus` (complex reasoning). Default: `inherit` |
| `tools` | No | Allowlist. If omitted, inherits ALL tools |
| `disallowedTools` | No | Denylist. Use YAML list syntax |
| `memory` | No | `user` (cross-project), `project`, or `local` |
| `color` | No | Background color in UI |
| `maxTurns` | No | Limit agentic turns |
| `skills` | No | Preload skill content into agent context |
| `mcpServers` | No | MCP servers available to agent |
| `hooks` | No | Lifecycle hooks scoped to agent |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` |
| `background` | No | `true` to always run in background |
| `isolation` | No | `worktree` for isolated git worktree |

## Skill Frontmatter

| Field | Required | Guidance |
|-------|----------|----------|
| `name` | No | lowercase-with-hyphens, max 64 chars. Defaults to directory name |
| `description` | Recommended | What it does AND when to use it. Third person. Max 1024 chars |
| `disable-model-invocation` | No | `true` for side-effect skills (commit, deploy, PR) |
| `user-invocable` | No | `false` for background knowledge users shouldn't invoke directly |
| `allowed-tools` | No | Tools allowed without per-use approval when active |
| `model` | No | Model override when active |
| `argument-hint` | No | Hint in autocomplete (e.g., `<pr-number>`) |
| `context` | No | `fork` to run in isolated subagent |
| `agent` | No | Subagent type when `context: fork` |
| `hooks` | No | Lifecycle hooks scoped to skill |

## Prompt Structure

1. **Identity + behavioral constraints** — first paragraph
2. **Scope boundaries** — what it does NOT do
3. **Workflow** — numbered steps, clear decision points
4. **Output format** — bold headers, not code-fenced templates (model mimics formatting it sees — code fence → code block output)

Keep under 500 lines. Split to reference files if needed.

## Tool Scoping

- Read-only roles (researchers, reviewers): `disallowedTools: [Write, Edit, NotebookEdit]`
- Side-effect roles: explicitly list only `tools` needed
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
- MCP tool references include "if available" for portability

### Anti-patterns
- No code-fenced output templates (use bold headers)
- No verbose examples where one suffices
- Description doesn't start with "Use this agent to..." (action-oriented instead)
- No conflicting instructions between sections
