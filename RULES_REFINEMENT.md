# CLAUDE.md Rules — Refinement Plan

## Purpose
Critical analysis and iterative improvement of the behavioral rules in CLAUDE.md.
Target: rules that are unambiguous, logically consistent, and directly actionable by an AI agent in a code development context.

## Process
Each iteration applies devil's advocate analysis. All decisions are logged.
Document is updated and committed after each iteration.

---

## Iteration 1 — Issues Identified

### I1. Header: Conflict resolution and "trivial" escape hatch

**Problem A:** `"Merge with project-specific instructions as needed."` — no precedence rule defined. When project-specific instructions conflict with these, which wins? An agent has no way to resolve this deterministically.

**Problem B:** `"For trivial tasks, use judgment."` — "trivial" is undefined. This functions as an unconstrained escape hatch. An agent will over-apply it to skip rules it finds inconvenient.

Options for A:
- **A1.** Add explicit precedence: "Project-specific instructions take precedence when they conflict."
  - Pro: deterministic resolution
  - Con: may cause important general rules to be silently overridden
- **A2.** Add reverse precedence: "These rules take precedence unless project instructions explicitly override them."
  - Pro: general rules stay authoritative
  - Con: may conflict with legitimate project needs
- **A3.** Remove the sentence entirely — leave precedence to project context.
  - Pro: simpler, avoids false precision
  - Con: leaves a real ambiguity unaddressed

Options for B:
- **B1.** Remove the "trivial tasks" sentence entirely.
  - Pro: no escape hatch to abuse
  - Con: forces rigid rule application to genuinely simple tasks
- **B2.** Define "trivial" with a concrete example: "single-line fixes, renaming, formatting".
  - Pro: anchors the concept
  - Con: examples are never exhaustive; agents over-generalize from them
- **B3.** Replace with a scope statement: "These rules apply to all multi-step or irreversible tasks."
  - Pro: defines the trigger condition, not the exception class
  - Con: "multi-step" and "irreversible" also need definition

---

### I2. Rule 1 ↔ Rule 5 overlap

**Problem:** Rule 1 bullet: `"State your assumptions explicitly. If uncertain, ask."` and `"If something is unclear, stop. Name what's confusing. Ask."` — this is the same behavior Rule 5 prescribes. Two rules governing the same behavior creates ambiguity: which rule applies when? An agent may apply one and ignore the other, or apply both inconsistently.

Options:
- **C1.** Keep both rules but add explicit scope: Rule 1 = pre-coding phase; Rule 5 = during/after coding.
  - Pro: preserves current structure
  - Con: the overlap still exists; agents don't naturally phase-partition their behavior
- **C2.** Remove the uncertainty bullets from Rule 1 and have Rule 1 cross-reference Rule 5.
  - Pro: single source of truth for uncertainty behavior
  - Con: cross-references in rules are fragile; reading Rule 1 alone becomes incomplete
- **C3.** Merge Rule 1 and Rule 5 into a single rule: "Before and during coding, think and signal uncertainty."
  - Pro: eliminates redundancy
  - Con: changes rule count, disrupts the document structure, could dilute both rules

---

### I3. Rule 2: "impossible scenarios" and arbitrary metrics

**Problem A:** `"No error handling for impossible scenarios."` — "impossible" is the agent's assessment at coding time. What seems impossible (null input, auth failure mid-request) regularly happens in production. This instruction could actively harm code reliability.

**Problem B:** `"If you write 200 lines and it could be 50, rewrite it."` — 200/50 is arbitrary. An agent cannot reliably apply a 4x compression heuristic. The underlying principle is valid; the number is not.

**Problem C:** `"Would a senior engineer say this is overcomplicated?"` — asking an AI to simulate expert judgment is asking it to hallucinate a second opinion. This is an unreliable self-check, and contradicts Rule 5 ("never let confident tone substitute for confident knowledge").

Options for A:
- **D1.** Replace with: "No error handling for scenarios that cannot occur given the current system's guarantees."
  - Pro: more precise, scopes to actual impossibility
  - Con: "system's guarantees" still requires judgment to assess
- **D2.** Replace with: "Only validate at system boundaries (user input, external APIs). Trust internal code and framework contracts."
  - Pro: concrete and actionable; standard engineering practice
  - Con: slightly more prescriptive than the current style

Options for B:
- **E1.** Remove the 200/50 line entirely; the principle is already stated in the header.
  - Pro: no arbitrary numbers
  - Con: loses the concrete signal that compression is expected, not optional
- **E2.** Replace with a structural signal: "If the same logic could be expressed in significantly fewer lines without losing clarity, rewrite it."
  - Pro: removes arbitrary numbers, keeps intent
  - Con: "significantly" is still vague, just less precisely vague

Options for C:
- **F1.** Remove the self-check question entirely.
  - Pro: avoids hallucinated judgment
  - Con: loses a useful heuristic prompt
- **F2.** Replace with an objective test: "If the solution introduces new abstractions, new files, or new dependencies not implied by the task, reconsider."
  - Pro: observable, binary checks
  - Con: more verbose; still requires judgment on "implied by"

---

### I4. Rule 3: Informal language and test contradiction

**Problem A:** `"Clean up only your own mess."` — "mess" implies the existing code is bad. Neutral phrasing avoids that implicit judgment and is clearer.

**Problem B:** `"The test: Every changed line should trace directly to the user's request."` — this contradicts the orphan cleanup instruction directly above it. Removing an import your change made unused does NOT trace to the user's request; it traces to a side effect. The test is slightly too strict and self-contradictory.

**Problem C:** Capitalized `"YOUR"` in `"that YOUR changes made unused"` — informal emphasis that doesn't add precision and is inconsistent with the document's style elsewhere.

Options for A:
- **G1.** Replace "Clean up only your own mess" with "Undo only what your changes introduced."
  - Pro: precise, neutral
  - Con: none significant

Options for B:
- **H1.** Extend the test: "Every changed line should trace to the user's request or to cleanup required by your changes."
  - Pro: eliminates the contradiction
  - Con: slightly longer

Options for C:
- **I1.** Lowercase: "that your changes made unused."
  - Pro: consistent style
  - Con: none

---

### I5. Rule 4: "Loop" undefined, TDD assumption, tension with Rules 1+5

**Problem A:** `"Loop until verified."` — no exit condition defined. What happens when verification keeps failing? An agent could interpret this as infinite retry, which is dangerous and unhelpful.

**Problem B:** All three examples assume tests can be written first:
```
"Fix the bug" → "Write a test that reproduces it, then make it pass"
```
This is TDD. For infrastructure changes, config edits, UI work, database migrations, or library integrations, writing a test first is often impractical or impossible. The rule silently assumes TDD is always applicable.

**Problem C:** `"Strong success criteria let you loop independently."` — "loop independently" means proceed without checking in. This directly conflicts with Rule 1 ("if uncertain, ask") and Rule 5 ("offer to stop rather than guess"). No precedence is defined.

Options for A:
- **J1.** Add an exit condition: "If verification fails after reasonable attempts, report the failure and stop rather than continuing to loop."
  - Pro: prevents infinite loops
  - Con: "reasonable" is undefined
- **J2.** Reframe: "Define a done condition before starting. Stop when done or blocked."
  - Pro: clean binary state machine
  - Con: loses the "loop" dynamic for iterative tasks

Options for B:
- **K1.** Scope the examples: add "(when tests are applicable)" qualifier.
  - Pro: minimal change, preserves examples
  - Con: still implies TDD is the default
- **K2.** Replace test-specific examples with more general ones covering non-TDD tasks.
  - Pro: broader applicability
  - Con: examples lose concreteness
- **K3.** Separate TDD tasks from non-TDD tasks explicitly.
  - Pro: covers both cases
  - Con: adds significant length

Options for C:
- **L1.** Replace "loop independently" with "proceed to the next step" — removes the autonomy implication.
  - Pro: resolves the conflict with Rules 1+5
  - Con: changes the meaning slightly (looping vs. sequential progress)
- **L2.** Add a tie-breaker: "When success criteria are unclear, defer to Rule 1 (ask) and Rule 5 (signal uncertainty) before looping."
  - Pro: explicit precedence
  - Con: cross-references are fragile in rule documents

---

### I6. Rule 5: Grammar error, "preface" imprecision, verbatim example risk

**Problem A:** `"a hallucination inferred"` — grammatically broken. Possible intended meaning: "a claim is inferred rather than known" or "a hallucination is possible."

**Problem B:** `"Preface responses with 'possibly', 'likely'..."` — "preface" means the very start of a response. Uncertainty often arises mid-reasoning (a specific claim, not the whole response). "Preface" is too strict and will cause either mechanical hedging at the top of every response, or the rule being ignored when uncertainty is mid-sentence.

**Problem C:** The example `"I can proceed on that assumption, or you can verify first."` is given as a direct quote. An agent may repeat this verbatim every time, which becomes robotic and loses the intent.

Options for A:
- **M1.** Replace with: "a claim is inferred rather than verified" — clear, grammatical.
  - Pro: fixes grammar, preserves meaning
  - Con: none

Options for B:
- **N1.** Replace "Preface responses" with "Mark the specific claim" — scopes hedging to the uncertain statement, not the whole response.
  - Pro: precise, reduces over-hedging
  - Con: "mark" is slightly vague about how
- **N2.** Replace with: "Hedge the specific claim with 'possibly', 'likely', 'I'm not certain', or 'you should verify this'."
  - Pro: clear target (the claim), clear method (hedging words), same vocabulary
  - Con: slightly more verbose

Options for C:
- **O1.** Add "(for example)" before the quoted phrase.
  - Pro: signals it's illustrative, not a template
  - Con: minor; works

---

### I7. Cross-cutting: Closing summary and pronoun consistency

**Problem A:** The closing summary `"These guidelines are working if: fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes."` — written before Rules 3 and 5 existed in their current form. It doesn't mention uncertainty signalling or surgical changes.

**Problem B:** Rules use "you/your" inconsistently — sometimes meaning the AI agent, sometimes a generic developer. Inconsistent subject can cause an AI to interpret rules as applying to the user rather than itself.

Options for A:
- **P1.** Extend the summary to include all five rules.
  - Pro: complete
  - Con: the summary risks becoming as long as the rules themselves
- **P2.** Replace the summary with a single-sentence principle: "These guidelines are working if changes are minimal, targeted, and honest about their limits."
  - Pro: concise, covers all five
  - Con: abstract

Options for B:
- **Q1.** Replace all "you/your" with "the agent" throughout.
  - Pro: unambiguous subject
  - Con: formal and slightly robotic; changes the register of the document
- **Q2.** Add a one-line statement at the top: "In these rules, 'you' refers to the AI agent."
  - Pro: minimal change, resolves ambiguity once
  - Con: feels like a patch over a structural issue

---

## Open Decisions (Awaiting Input)

| # | Decision | Options | Impact |
|---|----------|---------|--------|
| D-A | Rule 1 + Rule 5 overlap: merge, scope, or cross-reference? | C1 / C2 / C3 | Structural — affects rule count and doc shape |
| D-B | Rule 4 test examples: keep/scope TDD examples, or generalize? | K1 / K2 / K3 | Scope — affects how broadly Rule 4 applies |
| D-C | Header escape hatch: remove "trivial", define it, or replace with scope trigger? | B1 / B2 / B3 | Behavioral — affects how broadly rules are applied |
| D-D | Header conflict resolution: add precedence or remove the sentence? | A1 / A2 / A3 | Structural — affects how these rules relate to project-specific overrides |

---

## Decisions Log

| Date | Issue | Decision | Rationale |
|------|-------|----------|-----------|
| 2026-06-02 | I4-C (Rule 3 informal language) | G1: replace "mess" with "what your changes introduced" | Neutral, precise, no information loss |
| 2026-06-02 | I4-C (Rule 3 "YOUR" caps) | I1: lowercase | Style consistency; caps add no precision |
| 2026-06-02 | I6-A (Rule 5 grammar) | M1: "a claim is inferred rather than verified" | Fixes grammar, preserves intent |
| 2026-06-02 | I7-B (pronoun consistency) | Q2: add "In these rules, 'you' refers to the AI agent" | Minimal-change fix; avoids pervasive rewrite |

---

## Pending Iterations

- **Iteration 2:** Devil's advocate review of the solutions proposed in Iteration 1.
- **Iteration 3:** Convergence — finalize recommendations per issue; update Decisions Log.
- **Iteration 4:** Final consistency pass — check that proposed changes don't introduce new contradictions.
