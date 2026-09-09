---
description: Deep parallel review by 5 specialists — guidelines conformance and discovery, plus security, architecture, correctness. Use for thorough PR review, before shipping risky changes, or when /review feels too shallow.
argument-hint: [PR link, path, or empty for uncommitted]
model: opus
allowed-tools: Bash(git:*), Bash(gh:*), Agent, Read, Glob, Grep, mcp__atlassian__getJiraIssue
---

Spawn read-only specialists in parallel. Each works blind. Synthesize their findings into one consolidated review.

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

Five agents: guidelines splits into conformance and discovery (below); security, architecture, and correctness are one each. Launch all of them in a single message via the Agent tool with `run_in_background: true`. Each gets the same scope + diff, and a different role.

### 1. guidelines (2 agents: conformance + discovery)

One role, two jobs, and they need different models. Checking a diff against stated rules is closed and verifiable — a cheaper model does it reliably. Finding what no rule names is open-ended and degrades sharply with tier. Split by role, not by document: bucketing the docs blinds each agent to everything outside its slice, and the findings that matter most are usually the ones spanning two slices.

**Doc inventory — orchestrator does this before spawning. Deterministic, no agent:**

```
find . \( -name node_modules -o -name vendor -o -name deps -o -name _build \
          -o -name worktrees -o -name .git \) -prune -o \
     \( -name 'CLAUDE.md' -o -name 'AGENTS.md' -o -name 'AGENT.md' \
        -o -path '*/.claude/rules/*.md' \
        -o -path '*docs/guidelines/*.md' -o -path '*docs/how-to/*.md' \) -print
```

Then word-count everything in one pass (`wc -w`) — this sizes the corpus and exposes duplicates: an `AGENTS.md` sitting beside a `CLAUDE.md` with an identical count is the same file under two names. Read one, drop the other. If the total is large enough that one agent cannot hold it alongside the diff, say so in the output rather than letting an agent silently sample.

Pass the resulting list, with word counts, to both agents below. Always include `~/.claude/CLAUDE.md`, repo-root `CLAUDE.md`, and repo-root `README.md`.

**1a. conformance (subagent_type: code-reviewer, model: sonnet)** — full diff plus the doc list, and it reads every doc on the list. Checks the changeset against stated rules, and nothing else.

- Quote the rule verbatim with its source path beside the offending code
- Before claiming something is missing from a config file, read that file and confirm
- Apply a rule only where it actually governs. A rule about how the agent issues Bash commands does not automatically govern the body of a committed script; check for existing code that contradicts the reading before flagging. When scope is genuinely uncertain, say so and lower the severity rather than arguing around it

**1b. discovery (subagent_type: code-reviewer, model: opus)** — full diff plus the doc list as *paths*, reading what it needs. Its job is what no rule names:

- A change satisfying one layer of a multi-layer convention but not the others
- A new file diverging from the established pattern for its file type — audit siblings to prove the pattern
- A rule that plainly does not apply despite matching keywords: say so, cite the precedent
- Claims checked against the world rather than the docs — does the cited path exist, does the referenced command resolve
- Anything the changeset gets wrong that the docs never anticipated, including a malformed diff

**Both guidelines agents:** their Coverage section lists every doc read and every doc deliberately skipped, with the reason. Repeat it in the final output. A doc nobody read is a silent false negative — the one failure the skeptic pass cannot catch — so it has to be visible rather than implied.

### 2. security (subagent_type: code-reviewer, model: opus)

Scope: auth, input validation, secrets, injection, authz, SSRF, deserialization, crypto, race conditions in security-relevant paths. Skip style, naming, architecture.

Augmentation: Reasoning must describe a concrete attack scenario (input source → vulnerable sink → impact). No "could be exploited" without a path.

### 3. architecture (subagent_type: code-reviewer, model: opus)

Scope: patterns, layering, coupling, abstractions, module boundaries, dependency direction, public API design, structural naming (modules, classes, public functions). Skip line-level bugs, local style.

### 4. correctness (subagent_type: code-reviewer, model: opus)

Scope: edge cases, off-by-one, error handling, nil/empty handling, test gaps, local naming (variables, private methods, locals). Skip security, architecture.

When ticket context is loaded: for every acceptance criterion in the ticket, identify the diff hunk that fulfills it. Flag missing or partially-met AC as findings. For every reviewer comment on the ticket that raises a concern, check whether the diff addresses or ignores it.

## Prompt requirements (every agent)

- Full scope + context + diff
- Role and explicit non-scope ("you do NOT review X")
- "Answer independently. Do not coordinate."

Finding format and severity scale (Claim / Evidence / Reasoning / Severity / Fix, blocker / major / nit / info, self-verified) are the code-reviewer agent's own; don't restate them in the prompt.

## Synthesize

After every agent completes, before presenting:

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

If multiple agents flag the same file:line with the same claim, merge into one finding citing every agent that raised it. Conformance and discovery converging on the same finding from different directions is signal — note it.

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

Open with one Coverage line: docs read, docs skipped with reason. Severity sections (Blockers, Major, Nits, Info) hold Strong findings grouped by file. Weak findings go in their own "Weak" section. Omit empty sections. If every specialist returns clean, output "No findings" and skip the handoff.

## Handoff

End with a single-letter menu. The user types the bracketed key as their next message to pick; keys sit on the Colemak home row (`t` = left index, `n` = right index).

- **No findings**: no handoff.
- **Someone else's PR** (PR in scope AND `gh pr view <pr> --json author -q .author.login` differs from `gh api user -q .login`):
  > Next: `[t]` /post-review to publish findings · `[n]` /quorum "verify these findings" to gut-check first
- **Anything else** (your own PR, uncommitted changes, or a path arg):
  > Next: `[n]` /quorum "verify these findings" to gut-check before acting

On the user's next message, map the key: `t` → run `/post-review`; `n` → run `/quorum "verify these findings"`. A typed action word (e.g. "post", "quorum") works too.
