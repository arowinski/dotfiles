---
description: Spawn an agent team to analyze and prepare epic tickets
argument-hint: <Jira URL, epic description, or pasted tickets>
model: opus
---

Accept a Jira URL, pasted epic/ticket details, or a description as input.
If no argument provided, ask for the epic details.

## Setup

1. **Parse input:**
   - If Jira URL: fetch epic and child ticket details via Atlassian MCP (if available), extract titles, descriptions, acceptance criteria
   - Otherwise: use input as the epic description and ticket list

2. **Frame the analysis:**
   - Summarize the epic scope and list the tickets you'll analyze
   - Present to the user: "I'll analyze this epic with three specialists: Decomposer, Technical Analyst, and Risk Assessor. Here's what I see: [ticket list]. Ready?"
   - Wait for confirmation before spawning the team

## Team

You MUST use the TeamCreate and SendMessage tools to create a real agent team. Do NOT simulate the analysis in your own context.

Create a team with 3 teammates. All teammates are read-only — no file edits, only research and analysis.

Run `git` directly. For a different repo use `cd <path> && git <cmd>`.

### 1. Decomposer

Prompt must include:
- Full epic context and ticket list
- Role: analyze the ticket split and scoping
- Research the codebase to understand the domain and validate scope
- Evaluate each ticket: is it independently deliverable? Right-sized? Well-scoped?
- Flag tickets that are too large, too vague, or tightly coupled to others
- Propose re-splits, merges, or missing tickets if warranted
- Map dependencies between tickets — which can be parallel, which are sequential

### 2. Technical Analyst

Prompt must include:
- Full epic context and ticket list
- Role: assess technical feasibility and codebase fit
- Research relevant code: existing patterns, abstractions, models, APIs
- For each ticket: what code needs to change, estimated complexity (S/M/L), what patterns to follow
- Identify shared infrastructure work (migrations, new abstractions) that cuts across tickets
- Flag technical debt or architectural concerns the epic touches

### 3. Risk Assessor

Prompt must include:
- Full epic context and ticket list
- Role: identify blockers, risks, and gaps
- Research the codebase for potential conflicts, edge cases, and integration points
- For each ticket: what could go wrong, what's underspecified, what assumptions are being made
- Identify external dependencies (APIs, services, teams)
- Flag missing acceptance criteria or untestable requirements
- Check if any ticket requires a spike or proof-of-concept first

Require plan approval for all teammates so you can review their research approach before they begin.

## Cross-Examination

After teammates complete their initial analysis:

1. **Present findings** — have each teammate summarize their analysis
2. **Challenge round** — direct teammates to challenge each other:
   - Risk Assessor challenges Decomposer's independence claims with specific coupling evidence
   - Technical Analyst flags complexity that Decomposer underestimated
   - Decomposer questions whether Risk Assessor's blockers are real or speculative
   - Risk Assessor probes Technical Analyst's complexity estimates
3. **Response round** — teammates respond to challenges, conceding where evidence warrants
4. **Convergence** — teammates state what they agree on and what remains contested

Limit to 2 rounds of back-and-forth. Cut off unproductive tangents.

## Output

After the analysis, synthesize a report:

**Epic**
[Epic title/summary]

**Ticket Overview**
| Ticket | Summary | Complexity | Independent? | Blockers |
|--------|---------|------------|--------------|----------|
| ...    | ...     | S/M/L      | Yes/No       | ...      |

**Dependency Graph**
[Which tickets block which, recommended implementation order]

**Suggested Changes**
- [Re-splits, merges, or new tickets the team recommends]

**Technical Considerations**
- [Shared infrastructure, patterns to follow, architectural concerns]

**Risks & Blockers**
- [Confirmed blockers vs speculative risks, with severity]

**Recommended Order**
[Suggested implementation sequence with rationale]

**Open Questions**
- [Anything that needs product input, spikes, or further investigation]

Present this to the user. Then clean up the team.
