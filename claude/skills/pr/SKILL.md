---
name: pr
description: Creates or edits pull requests with automatic title/template formatting. Use when asked to create or edit a PR — "create a PR", "let's have a PR", "open/draft a PR", "make a PR for this", "create drafts for the others" — or to change an existing one — "update the PR desc/title/body", "rework the description".
allowed-tools: Bash(git fetch:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git remote:*), Bash(git push:*), Bash(git symbolic-ref:*), Bash(git rev-parse:*), Bash(gh pr create:*), Bash(gh pr edit:*), Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh repo view:*), Read, Glob, AskUserQuestion, Skill, mcp__atlassian__getJiraIssue, mcp__atlassian__getAccessibleAtlassianResources
---

# PR

## Workflow

### Step 0: Create or edit?

`gh pr view --json number,state,title,body,url` on the current branch.

- Errors, or `state` is `MERGED`/`CLOSED` → **create mode**. Steps 1-6. `gh pr view` returns the branch's
  most recent PR whatever its state, so a merged one must not route to edit — check `state`, not just
  whether the call succeeded.
- `state` is `OPEN` → **edit mode**. Capture the number and the current title and body, then steps 1-6. Read
  the existing body before regenerating: it may hold template sections or reviewer-facing notes a human
  wrote, and those survive unless the user says otherwise.

An explicit PR number or URL in the request overrides this — edit that one.

### Step 1: Analyze changes

1. Resolve `<base>` — the branch this PR targets. Repo default: `git symbolic-ref --short refs/remotes/origin/HEAD` (strip the `origin/` prefix); if that ref is unset, `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`. If the PR stacks on another branch, ask the user for the target (AskUserQuestion). Reuse this `<base>` in the diff/log below and in Step 6.
2. `git diff origin/<base>...HEAD` — all changes
3. `git log origin/<base>..HEAD` — commit history
4. **Identify single most important change** — primary purpose?
5. Identify scope: frontend, backend, infra, tests, etc.

### Step 2: Detect title pattern

1. `gh pr list --limit 10 --json title` — recent PRs
2. Identify prefix/ticket patterns, extract ticket from branch name
3. Pattern found but no ticket in branch? Ask user.
4. Ticket found? Fetch Jira for motivation/rationale.

### Step 3: Check for PR template

1. Check `.github/pull_request_template.md` (or `PULL_REQUEST_TEMPLATE.md`) from repo root — use `git rev-parse --show-toplevel`, don't rely on cwd.
2. Found? Adapt — fill sections tersely, delete sections that don't apply (e.g. UI sections with no frontend changes).

### Step 4: Generate title and body

1. Title (follow detected pattern):
   - **Mention single most important thing in PR**
   - Apply ticket prefix if pattern exists
   - Imperative mood ("Add feature", "Fix bug")
   - No code identifiers — file paths, atoms, module/function names, snake_case, backtick tokens. Paraphrase to prose (`:retry_outbox` → "the outbox retry flag"); code tokens belong in the body where context exists
   - Primary purpose, not implementation details

2. Body — **invoke `Skill(clear-writing)` and `Skill(human-writing)` before drafting**. Body must follow both: clear-writing for sentence-level quality (no AI prose, no filler, no hype, no banned vocabulary), human-writing for voice (reads like a colleague wrote it, not an AI). Context unclear? Ask user first.

   The body exists to make review faster and to answer WHY when someone reaches this PR via git blame later. The diff shows WHAT — the body may contain only what the diff can't show:
   - The problem and why now (mandatory, 1-3 sentences; this opens the body)
   - An approach decision and its tradeoff
   - Breaking change + migration path
   - Deliberate non-goals ("X deferred to follow-up") — but only a design choice a reader would be surprised by from the diff; "not built yet" / placeholders are scope the diff already shows, cut them
   - For big diffs, a reading guide ("the real change is `foo.ex`; the rest is mechanical rename")

   Banned:
   - File-by-file change inventories, restating the diff, implementation narration ("first extracted, then...")
   - "Also updates tests/formatting" — never mention tests unless they're the main change
   - Meta-headers that address the reviewer ("Worth a reviewer's eye", "Note for reviewers", "Please pay attention to"). State the decision directly; whether it deserves attention is the reviewer's call. The reading guide is the one exception, and it reads best as a plain fact (as phrased in the reading-guide bullet above), never as a heading aimed at the reviewer.
   - A leading H1 (`# Title`) that repeats the PR title — GitHub renders the title already; open with the first real section
   - "Part N / roadmap" sequencing ("Part 2 adds X, Part 3 wires it in") and "Stacked on #N" / base-branch plumbing — name the concrete consumer instead ("the importer will map them to…"); stacking goes in `--base`, not the body
   - Private/local/spike branch names reviewers can't see — describe the design without anchoring it to the branch

   Example:
   - Not: "This PR adds FooWorker, updates the schema, refactors bar.ex, and adds tests."
   - Yes: "Events stuck in the outbox after deploys because the drain job died with the pod. This moves draining to FooWorker (Oban, unique per aggregate) so retries survive restarts. Schema change is additive; safe to roll back."

   Form:
   - Default ~100 words; exceed only for breaking changes, migration notes, or the reading guide
   - Bullets only when 3+ of the facts above exist; otherwise prose
   - Third person, present tense ("This adds...", not "I added...")
   - Backticks for code refs
   - Don't hard-wrap — GitHub renders single newlines as breaks. One paragraph = one line.
   - Jira fetched? Don't restate the ticket — the link carries it. Describe what the diff actually did and why, not what the ticket assumed would be done: when the implementation diverged from the ticket's planned approach or ACs, the body follows the diff, not the ticket.

### Step 5: Interactive confirmation (REQUIRED — DO NOT SKIP)

**STOP. Do NOT create or edit the PR yet.** This gate applies to `gh pr edit` exactly as to
`gh pr create` — an updated body is a new draft and needs its own confirmation.

1. Display generated title and body. When editing an existing PR, show the full proposed body
   (not a description of the changes).
2. Ask in text, one line: "Draft ready. Reply `create` to open it." (create mode) / "Reply `update` to
   apply it." (edit mode). Not a yes/no question — a plain "yes" has no defined meaning here.
   An explicit imperative ("create", "update", "go", "push it", "do it") = confirmed.
   Assent ("ok", "sure", "yes", "looks fine") is not a go; ask once more.
   Any other reply = edit request: apply it to the title or body, re-show, return to 2.
   Don't use AskUserQuestion here.

### Step 6: Create or update the PR (WAIT for Step 5 explicit confirmation — DO NOT accept empty responses)

**Only after an explicit imperative in Step 5.**

Creating:
1. Push branch with `-u` if not tracking remote.
2. `gh pr create`:
   - `--title` (generated)
   - `--body` (generated or template)
   - `--base <base>` only if `<base>` differs from the repo default (a stacked PR); omit otherwise so gh defaults correctly
   - `--assignee @me`
   - `--draft`

Editing: `gh pr edit <number> --title/--body` with the confirmed values only, using the number captured in
Step 0. Pass only the fields that changed.
