---
description: Deep parallel review by 4 specialists. Use for thorough PR review, before shipping risky changes, or when /review feels too shallow.
argument-hint: [PR link, path, or empty for uncommitted]
model: opus
allowed-tools: Bash(git:*), Bash(gh:*), Agent, Read, Glob, Grep, mcp__atlassian__getJiraIssue
---

Spawn 4 read-only specialists in parallel. Each works blind. Synthesize their findings into one consolidated review.

## Scope

Determine what to review:
- Argument is a PR link or PR number: fetch via `gh pr view` + `gh pr diff`
- Argument is a path: review files at that path
- No argument: `git diff` for uncommitted changes (staged + unstaged). If working tree clean, fall back to `git diff HEAD~1`

### Branch alignment (PR link only)

Agents read file content from the working tree. If HEAD doesn't match the PR head, findings will cite the wrong code. Require correct branch:

1. Get PR head SHA: `gh pr view <pr> --json headRefOid -q .headRefOid`
2. Compare to `git rev-parse HEAD`
3. If mismatch:
   - If `git status --porcelain` reports uncommitted changes: `git stash push -m "auto-stash before /rr review of PR #<n>"` and tell the user "Stashed uncommitted changes. Restore with `git stash pop` when done."
   - `gh pr checkout <pr>`
4. Re-verify HEAD matches after checkout

### Context for all agents

- The diff itself
- Plan file at `<git-common-dir>/claude/plans/<branch-name>.md` if it exists
- Jira ticket details via Atlassian MCP (if available), discovered from any of:
  - Plan file (if exists) — links a ticket
  - PR title (regex `ENG-\d+` or similar), via `gh pr view <pr> --json title,body`
  - PR body / description
  - Branch name (e.g., `eng-555` per project convention)
  - If found, fetch title, description, acceptance criteria, and comments

## Specialists

Launch all 4 in a single message via the Agent tool with `run_in_background: true`. Each gets the same scope + context but a different role.

### 1. project-guidelines (subagent_type: code-reviewer)

Read CLAUDE.md as a routing manifest. Check every change against stated rules.

Always read:
- `~/.claude/CLAUDE.md` (auto-loaded)
- Repo-root `CLAUDE.md` (auto-loaded)
- Repo-root `README.md`
- `.claude/rules/*.md`
- `.github/CLAUDE.md` if present

Conditional on changed paths:
- For each touched package: `packages/<pkg>/CLAUDE.md`, `README.md`, `AGENTS.md` if any
- Walk nested `CLAUDE.md` upward for deep changes (e.g., `packages/myapp/lib/web/CLAUDE.md`)
- Extract any docs paths referenced from CLAUDE.md files (treat as routing manifest)
- Read everything under `docs/guidelines/**` when present (small, always relevant)
- Read matching `docs/how-to/<topic>.md` when changes match the topic (new schemas → `adding-modules-and-business-logic.md`, PubSub work → `events.md`, etc.)
- For auth-related changes, read `@moduledoc` on cited auth modules

Skip: `node_modules/**`, `vendor/**`, `_build/**`, `deps/**`.

Augmentation: Evidence must include the rule source (file + line/section) alongside the offending code. No "follows project conventions" hand-waves; quote the rule.

### 2. security (subagent_type: code-reviewer)

Scope: auth, input validation, secrets, injection, authz, SSRF, deserialization, crypto, race conditions in security-relevant paths. Skip style, naming, architecture.

Augmentation: Reasoning must describe a concrete attack scenario (input source → vulnerable sink → impact). No "could be exploited" without a path.

### 3. architecture (subagent_type: architect)

Scope: patterns, layering, coupling, abstractions, module boundaries, dependency direction, public API design, structural naming (modules, classes, public functions). Skip line-level bugs, local style.

### 4. correctness (subagent_type: code-reviewer)

Scope: edge cases, off-by-one, error handling, nil/empty handling, test gaps, local naming (variables, private methods, locals). Skip security, architecture.

When ticket context is loaded: for every acceptance criterion in the ticket, identify the diff hunk that fulfills it. Flag missing or partially-met AC as findings. For every reviewer comment on the ticket that raises a concern, check whether the diff addresses or ignores it.

## Prompt requirements (every agent)

- Full scope + context + diff
- Role and explicit non-scope ("you do NOT review X")
- Severity scale: blocker / major / nit / info
- "Answer independently. Do not coordinate."

### Finding format (every agent)

Each finding must be structured with these fields:

- **Claim** — one sentence: what's wrong
- **Evidence** — quoted code with file:line, or quoted rule with source path:line
- **Reasoning** — how the evidence produces the claimed harm
- **Severity** — blocker | major | nit | info
- **Fix** — concrete change, code snippet, or rule reference

No prose-only reports. Self-verify before reporting:
- The cited line exists in the diff or at the cited file path
- The quoted evidence matches the actual code or rule text
- The reasoning chain connects evidence to harm without unsupported leaps

Drop findings that fail any check. Report only structured, evidenced findings — never "I think X might be wrong" or "could potentially...".

## Synthesize

After all 4 complete, before presenting:

### 1. Skeptic pass (orchestrator, no extra agents)

For each finding, evaluate three things:

- **Mechanical**: does the cited file/line exist? Does the cited line sit on the expected side of the diff (RIGHT for added/modified, LEFT for deleted)? Does the quoted evidence match the actual code or rule text?
- **Reasoning**: does the logical chain from evidence to harm hold? Or is there a gap, an unsupported assumption, a "could be exploited if..." with no concrete path?
- **Fix coherence**: does the suggested fix actually address the claim, or is it a non-sequitur?

Bucket each finding:

| bucket | criteria | treatment |
|---|---|---|
| Strong | passes all 3 | present prominently |
| Weak | mechanical passes but reasoning has gaps | present with caveat noting the gap |
| Failed | mechanical fails (wrong line, misquoted evidence) | drop, count silently |

Do not soften the skeptic. A finding that says "this MIGHT cause issues if X happens" without showing X is reachable is Weak at best. A finding citing a line that doesn't say what the agent claims is Failed.

### 2. Dedupe

If multiple agents flag the same file:line with the same claim, merge into one finding citing both agents.

### 3. Group

By severity (blocker → major → nit → info), then by file path within each severity.

### 4. Cite

Agent name on each finding. For Weak findings, cite which check they failed.

Output shape (illustrative, not a code-fenced template):

**Blockers**

- **[security] lib/auth.ex:42**
  - Claim: JWT signature not verified.
  - Evidence: `Joken.peek(token)` at line 42; no `Joken.verify` call before decode.
  - Reasoning: `Joken.peek` decodes without checking signature; attacker can forge a token with arbitrary claims that the server then trusts.
  - Fix: replace with `Joken.verify(token, signer)` and handle the error tuple.

**Weak (reasoning gap noted)**

- **[security] lib/api.ex:55** — claims rate limiting needed but did not show an exploit path. Gap: no evidence of unauthenticated reach or high-cost operation.

_(Failed: 2 findings dropped, wrong line citations.)_

Severity sections (Blockers, Major, Nits, Info) hold Strong findings grouped by file. Weak findings go in their own "Weak" section. Omit empty sections. If all 4 specialists return clean, output "No findings" and skip the handoff.

## Handoff

End with a single-letter menu. The user types the bracketed key as their next message to pick; keys sit on the Colemak home row (`t` = left index, `n` = right index).

- **No findings**: no handoff.
- **Someone else's PR** (PR in scope AND `gh pr view <pr> --json author -q .author.login` differs from `gh api user -q .login`):
  > Next: `[t]` /post-review to publish findings · `[n]` /quorum "verify these findings" to gut-check first
- **Anything else** (your own PR, uncommitted changes, or a path arg):
  > Next: `[n]` /quorum "verify these findings" to gut-check before acting

On the user's next message, map the key: `t` → run `/post-review`; `n` → run `/quorum "verify these findings"`. A typed action word (e.g. "post", "quorum") works too.
