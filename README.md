# Karpathy-Inspired Claude Code Guidelines

A single `CLAUDE.md` file to improve Claude Code behavior, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

English | [简体中文](./README.zh.md)

## The Problems

From Andrej's post:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

## The Solution

Five principles in one file that directly address these issues:

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Leverage through tests-first, verifiable success criteria |
| **Signal Uncertainty** | Inferences stated as facts, silent assumptions, confidence masking gaps |

## Changes from Upstream

This repository is a fork of [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills). The rules were refined through an 8-iteration devil's advocate review. The full analysis, decision log, and reasoning behind every change is in [RULES_REFINEMENT.md](./RULES_REFINEMENT.md).

| What changed | Summary |
|---|---|
| **Rule 5 added** | New rule: Signal Uncertainty — LLMs present inferences as facts; no original rule addressed this |
| **Rule 1** | "Push back when warranted" was circular; replaced with explicit tradeoffs + simpler-approach bullets; scope extended to mid-task decision points |
| **Rule 2** | Three instructions replaced: "impossible scenarios" (wrong semantics), 200/50 metric (arbitrary), "senior engineer" self-check (unreliable) |
| **Rule 3** | Test was self-contradictory: required orphan cleanup two lines above, then excluded it in the test |
| **Rule 4** | "Loop until verified" had no exit condition; TDD framing was implicit; added non-TDD clause and explicit blocked state |
| **Header** | "You" undefined; "trivial tasks" escape hatch unconstrained; precedence between project rules and these guidelines unspecified |

Details for each: [Rule 5](./RULES_REFINEMENT.md#i6-rule-5-grammar-error-preface-imprecision-verbatim-example-risk) · [Rule 1](./RULES_REFINEMENT.md#i2-rule-1--rule-5-overlap) · [Rule 2](./RULES_REFINEMENT.md#i3-rule-2-impossible-scenarios-and-arbitrary-metrics) · [Rule 3](./RULES_REFINEMENT.md#i4-rule-3-informal-language-and-test-contradiction) · [Rule 4](./RULES_REFINEMENT.md#i5-rule-4-loop-undefined-tdd-assumption-tension-with-rules-15) · [Header](./RULES_REFINEMENT.md#i1-header-conflict-resolution-and-trivial-escape-hatch)

## The Five Principles in Detail

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

LLMs often pick an interpretation silently and run with it. This principle forces explicit reasoning:

- **State assumptions explicitly** — If uncertain, ask rather than guess
- **Present multiple interpretations** — Don't pick silently when ambiguity exists
- **Surface tradeoffs** — If multiple valid approaches exist, present them before proceeding
- **Propose simpler approaches** — If a simpler path exists, surface it before starting
- **Stop when confused** — Name what's unclear and ask for clarification

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

Combat the tendency toward overengineering:

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No input validation in internal code — validate at entry points (user input, API responses) only

**When to pause:** If the solution introduces abstractions, new files, or new dependencies not explicitly requested, stop and verify whether they're necessary.

### 3. Surgical Changes

**Touch only what you must. Clean up only what your changes left behind.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it

When your changes create orphans:

- Remove imports/variables/functions that your changes made unused
- Don't remove pre-existing dead code unless asked

**The test:** Every changed line should trace to the user's request, or be a direct side effect of your changes (e.g., an import your changes made unused).

### 4. Goal-Driven Execution

**Define success criteria before starting. Stop when done or blocked.**

Transform imperative tasks into verifiable goals. When tests are applicable:

| Instead of... | Transform to... |
|--------------|-----------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after" |

When tests are not applicable, define an observable done condition before starting (e.g., "migration runs without errors and row count matches").

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Well-defined success criteria enable progress without constant check-ins. Weak criteria ("make it work") require constant clarification. If blocked without information needed to proceed, stop and report rather than guessing.

### 5. Signal Uncertainty

**Don't state guesses as facts. When confidence is low, say so.**

LLMs often present inferences and assumptions with the same confident tone as known facts. This erodes trust and causes developers to act on false information:

- **Never substitute tone for knowledge** — Confident delivery doesn't make uncertain claims true
- **Hedge the specific claim** — Use "possibly", "likely", "I'm not certain", or "you should verify this"
- **Mark inferences explicitly** — "Based on X, I'm inferring Y" rather than stating Y as fact
- **Name gaps, don't fill them silently** — "I don't have visibility into X, so I'm assuming Y"
- **Escalate high-stakes uncertainty** — If acting on an uncertain claim could cause irreversible harm, surface it explicitly before proceeding

**The test:** Could a developer act on this response and only discover it was wrong after the damage is done? If yes, the uncertainty wasn't signalled clearly enough.

## Install

**Option A: Global slash command (recommended)**

Installs `/karpathy_rules_add` as a global Claude Code command, available in any project:

```bash
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/karpathy_rules_add.md \
  https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_add.md
```

Then run `/karpathy_rules_add` inside any project. It will:
1. Pull the latest rules from this repo
2. Merge them into the project's `CLAUDE.md`, resolving any conflicts with existing rules
3. If the project has existing tracked files, ask whether you want a full code review against the new guidelines

**To refresh the command** (e.g. after pulling a newer version of the file): no restart needed — changes to `~/.claude/commands/` take effect immediately in Claude Code and Claude Desktop. If you're installing the directory for the first time, restart once.

**Option B: Claude Code Plugin**

From within Claude Code, first add the marketplace:
```
/plugin marketplace add lucagattoni/andrej-karpathy-skills
```

Then install the plugin:
```
/plugin install andrej-karpathy-skills@karpathy-skills
```

**Option C: CLAUDE.md (per-project, manual)**

New project:
```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/CLAUDE.md
```

Existing project (append):
```bash
echo "" >> CLAUDE.md
curl https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/CLAUDE.md >> CLAUDE.md
```

## Using with Cursor

This repository includes a committed Cursor project rule ([`.cursor/rules/karpathy-guidelines.mdc`](.cursor/rules/karpathy-guidelines.mdc)) so the same guidelines apply when you open the project in Cursor. See **[CURSOR.md](CURSOR.md)** for setup, using the rule in other projects, and how this relates to Claude Code.

## Key Insight

From Andrej:

> "LLMs are exceptionally good at looping until they meet specific goals... Don't tell it what to do, give it success criteria and watch it go."

The "Goal-Driven Execution" principle captures this: transform imperative instructions into declarative goals with verification loops.

## How to Know It's Working

These guidelines are working if you see:

- **Fewer unnecessary changes in diffs** — Only requested changes appear
- **Fewer rewrites due to overcomplication** — Code is simple the first time
- **Clarifying questions come before implementation** — Not after mistakes
- **Clean, minimal PRs** — No drive-by refactoring or "improvements"
- **Uncertainty named, not hidden** — Inferences are flagged, assumptions surfaced before acting

## Customization

These guidelines are designed to be combined with project-specific instructions. Project-specific rules take precedence on implementation choices (libraries, patterns, style). The reasoning and communication behaviors — clarifying before acting and signalling uncertainty — are protected baselines that apply unless explicitly overridden.

Add them to your existing `CLAUDE.md` or create a new one.

For project-specific rules, add sections like:

```markdown
## Project-Specific Guidelines

- Use TypeScript strict mode
- All API endpoints must have tests
- Follow the existing error handling patterns in `src/utils/errors.ts`
```

## Tradeoff Note

These guidelines bias toward **caution over speed**. For trivial tasks (simple typo fixes, obvious one-liners), use judgment — not every change needs the full rigor.

The goal is reducing costly mistakes on non-trivial work, not slowing down simple tasks.

## License

MIT
