---
description: Developer news feed — Elixir/Phoenix + AI first, then Ruby/Rails, security, popular tech
argument-hint: [topic or empty for general]
---

Search for recent news relevant to a senior developer working with AI agents and developer tooling.

If argument provided, focus on that topic. Otherwise search by tier:

**Tier 1 (always covered, top of the feed):**
- Elixir / Phoenix ecosystem: Elixir core + releases, Phoenix, LiveView, Ecto, OTP/BEAM, and ecosystem libs/tools (Ash, Oban, Tidewave, Nx/Bumblebee, Broadway, Igniter, Req, mix/hex tooling)
- AI: Claude Code / Anthropic updates, AI coding agents and tools, MCP servers and integrations, LLM developer tooling and workflows

**Tier 2:**
- Ruby / Rails and other notable language/framework releases
- Security: notable CVEs and supply-chain incidents (beyond MCP)

**Tier 3 (only if genuinely popular or important):**
- General tech: infra/devops tooling (CI, build, deploy, observability), databases, major industry news

Run multiple web searches in parallel — dedicate at least one or two to the Elixir/Phoenix ecosystem every run, even when it's quiet (search elixirstatus, ElixirForum, library changelogs).

Elixir releases need a direct check, not a search — searching alone misses them. Every run, hit both:
- `gh api repos/elixir-lang/elixir/releases` and `gh api repos/erlang/otp/releases` for core (core releases carry CVEs and never surface on elixirstatus).
- `curl -s https://hex.pm/api/packages/<name>` for phoenix, phoenix_live_view, ecto, ash, oban, req, igniter, tidewave, bandit, nx — the JSON lists versions with `inserted_at`, so a two-day window is a diff, not a judgment call.

Thinking Elixir is not a source: the podcast ended at episode 309 on 2026-06-23.

Aggregator pass: fetch Hacker News front page (`https://hn.algolia.com/api/v1/search?tags=front_page`) and Lobsters hottest (`https://lobste.rs/hottest.json`) to catch what's broadly popular. Tier 3 items should come from here — popularity on aggregators is the bar for "generic tech worth including". Tier 1/2 items don't need aggregator presence.

Weighting: surface even minor Elixir/Phoenix/LiveView/Ecto/Ash releases and significant AI-tooling changes. When trimming to 5-10 items, order by tier and keep Tier 1 items over equal-substance items below.

Present 5-10 items as one flat numbered list ordered by tier — no tier headers or section labels. Each item:
- One-line summary of what happened
- Why it matters
- Source link

Skip hype, marketing, listicles, and "best AI tools" roundups. Technical substance only.

## History

After presenting, append each item's one-line summary to `~/.claude/news-history.md` with today's date.

Before presenting, read `~/.claude/news-history.md` (if it exists). Skip items already listed — only show what's new. If all results were already seen, say so and stop.
