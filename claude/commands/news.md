---
description: Developer news feed: Elixir/Phoenix + AI first, then Ruby/Rails, security, popular tech
argument-hint: [topic or empty for general]
model: haiku
effort: high
context: fork
disable-model-invocation: true
---

News feed for a senior developer working with AI agents and developer tooling. With an argument, run WebSearch on that topic only, then steps 3 to 7.

## Steps

1. **Window.** `grep -m1 '^## ' ~/.claude/news-history.md` prints the last run's date. The window runs from that date (inclusive) to today; with no history file, the last 7 days. A candidate is an item dated inside the window, or a support end from the endoflife.date line (it prints only the next 30 days). Search engines return stale pages, so a result counts only once you have its date.

2. **Collect.** In one parallel batch, run each command below as its own Bash call, copied exactly:

   ```
   gh api repos/elixir-lang/elixir/releases --jq '[.[] | select(.tag_name | test("latest") | not)][0:4][] | "\(.tag_name)\t\(.published_at)"'
   gh api repos/erlang/otp/releases --jq '.[0:4][] | "\(.tag_name)\t\(.published_at)"'
   for p in phoenix phoenix_live_view ecto ash oban req igniter tidewave bandit plug nx; do echo "== $p"; curl -s https://hex.pm/api/packages/$p | jq -r '.releases[0:3][] | "\(.version)\t\(.inserted_at)"'; done
   gh api '/advisories?ecosystem=erlang&per_page=10' --jq '.[] | "\(.published_at)\t\(.severity)\t\(.ghsa_id)\t\(.summary)"'
   gh api 'repos/anthropics/claude-code/releases?per_page=10' --jq '.[] | "\(.tag_name)\t\(.published_at)"'
   gh api 'repos/rails/rails/releases?per_page=5' --jq '.[] | "\(.tag_name)\t\(.published_at)"'
   gh api 'repos/ruby/ruby/releases?per_page=3' --jq '.[] | "\(.tag_name)\t\(.published_at)"'
   for p in rails ruby elixir erlang postgresql; do curl -s https://endoflife.date/api/$p.json | jq -r --arg p $p '(now|strftime("%Y-%m-%d")) as $t | ((now+30*86400)|strftime("%Y-%m-%d")) as $e | .[] | (["bug fixes",.support],["security",.eol]) as [$k,$d] | select(($d|type)=="string" and $d>=$t and $d<=$e) | "\($p) \(.cycle)\t\($k) end \($d)"'; done
   curl -s https://elixirstatus.com/rss | grep -oE '<title><!\[CDATA\[[^]]*\]\]></title>|<pubDate>[^<]*</pubDate>|<guid>[^<]*</guid>' | sed -E 's/<!\[CDATA\[//; s/\]\]>//; s/<[^>]+>//g' | paste - - - | head -20
   curl -s "https://hn.algolia.com/api/v1/search?tags=front_page" | jq -r '.hits[] | "\(.points)\t\(.title)\t\(.url // ("https://news.ycombinator.com/item?id=" + .objectID))"'
   curl -s https://lobste.rs/hottest.json | jq -r '.[0:25][] | "\(.score)\t\(.title)\t\(.url // .comments_url)"'
   ```

   In the same batch, two WebSearch calls (`mode: standard`), each with the current month and year in the query: AI coding agent and MCP releases; CVEs and supply-chain incidents.

   Core releases come only from the `gh api` lines: they carry CVEs and never surface on elixirstatus. The advisory feed lags new GHSAs by days, so a CVE named in release notes counts even before the feed lists it. Thinking Elixir is not a source: the podcast ended at episode 309 on 2026-06-23.

3. **Dedupe.** Check each candidate against the history file with `grep -n -i` on its name and version, every candidate in one command (e.g. `grep -n -iE "oban 2\.24|claude code 2\.1\.29[0-9]|CVE-2026-75758"`). Grep is the check because older entries sit deep in the file. Drop candidates already listed. Nothing left: say so and stop.

4. **Read in full.** A summary comes from the source, never from a title or version number. For each remaining candidate:
   - GitHub release: `gh api repos/<owner>/<repo>/releases/tags/<tag> --jq .body`, the whole body. Hex packages publish notes on the GitHub tag `v<version>`.
   - CVE or GHSA: `gh api repos/<owner>/<repo>/security-advisories/<GHSA-id> --jq '"\(.severity)\t\(.summary)"'`, and put the severity in the summary.
   - Aggregator or elixirstatus story: WebFetch the link.

5. **Pick.** Apply the tier rules below. Up to 10 items, ordered by tier. On a quiet day the list is shorter: three solid items beat ten padded ones. At equal substance, the higher tier wins.

6. **Present** one flat numbered list, no tier headers, each item exactly three lines:

   ```
   1. <name> <version or headline> (<date>): <what changed, one line>
      Why it matters: <who is affected and what they do, one line>
      Source: <url>
   ```

   Close with one line: `Nothing in window: <source>, <source>, ...`, listing each step-2 source that errored or had nothing in the window.

7. **Log** with the Edit tool. The history file is `# News History`, then one `## YYYY-MM-DD` section per run, newest first. Insert today's section directly under `# News History` (or add to the top of today's section if it exists), one bullet per presented item: `- <name> <version> (<date>): <summary line>`.

## Tiers

**Tier 1**, always covered, every minor release counts:
- Elixir / Phoenix ecosystem: Elixir core, OTP/BEAM, Phoenix, LiveView, Ecto, and ecosystem libs/tools (Ash, Oban, Tidewave, Nx/Bumblebee, Broadway, Igniter, Req, mix/hex tooling)
- AI: Claude Code / Anthropic updates, AI coding agents and tools, MCP servers and integrations, LLM developer tooling and workflows

**Tier 2:**
- Ruby / Rails and other notable language/framework releases
- Security: notable CVEs and supply-chain incidents (beyond MCP)

**Tier 3**, from the HN and Lobsters lists only. An item qualifies by meeting one of two bars:
- Popular: HN ≥ 200 points or Lobsters ≥ 50, and the story is infra/devops tooling (CI, build, deploy, observability), a database, or major industry news.
- Actionable: a dated change the reader must act on (deprecation, support end, certificate or runtime deadline), at any score.

Tier 1 and 2 items need no aggregator presence. Every tier: technical substance only, so hype, marketing, listicles, and "best AI tools" roundups stay out.
