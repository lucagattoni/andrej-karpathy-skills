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

## Open Decisions (Resolved)

| # | Decision | Chosen | Date |
|---|----------|--------|------|
| D-A | Rule 1 + Rule 5 overlap | C1: scope by phase (Rule 1 = before, Rule 5 = during/after) | 2026-06-02 |
| D-B | Rule 4 test examples | K1: add "(when tests are applicable)" qualifier | 2026-06-02 |
| D-C | Header escape hatch | B1: remove "trivial tasks" entirely | 2026-06-02 |
| D-D | Header conflict resolution | A1: "Project-specific instructions take precedence" | 2026-06-02 |

---

## Iteration 2 — Devil's Advocate on All Chosen Solutions

### DA-1: C1 — Scope Rule 1 vs Rule 5 by phase

**Chosen:** Rule 1 = before coding; Rule 5 = during/after coding.

**Challenge:** "Before" and "during" coding are not crisp phases for an AI agent. Agents reason and generate simultaneously — there is no hard boundary between "planning" and "executing." The phase model is a human cognitive construct.

**Deeper distinction found:** The real difference between the two rules is not temporal but functional:
- Rule 1 is a **decision gate**: "Should I start, and on what terms?"
- Rule 5 is a **communication standard**: "How should I word things I'm not sure about?"

These are orthogonal. An agent can ask a clarifying question (Rule 1) AND hedge a claim (Rule 5) at the same moment, without contradiction.

**Revised framing:** Instead of "Rule 1 = pre-coding / Rule 5 = during-coding," scope them as:
- Rule 1: governs **when to pause and ask** (at any point where a decision would be irreversible without clarity).
- Rule 5: governs **how to express** uncertain claims in any output (at all times).

This is more precise and doesn't rely on an agent knowing what "phase" it's in.

---

### DA-2: K1 — Add "(when tests are applicable)" to Rule 4

**Chosen:** Keep TDD examples, add qualifier.

**Challenge:** Adding the qualifier without saying what to do instead creates a behavioral gap. The agent reads "when tests are applicable" and has no guidance for the non-TDD case. It may default to no verification behavior at all.

**Required addition:** K1 needs a companion clause covering non-TDD tasks. Proposed:
> "When tests are not applicable, define an observable done condition before starting: a specific output, state change, or behavior that confirms the task is complete."

This closes the gap. Without it, K1 is an incomplete fix.

---

### DA-3: B1 — Remove "trivial tasks" escape hatch

**Chosen:** Delete the sentence entirely.

**Challenge:** Does removing it break anything? Check each rule at trivial scale:
- Rule 1 on a typo fix: "check before implementing" — harmless, takes one second.
- Rule 2 on a typo fix: "minimum code" — trivially satisfied.
- Rule 3 on a typo fix: "don't touch adjacent code" — trivially satisfied.
- Rule 4 on a typo fix: "define done condition" — done condition is self-evident.
- Rule 5 on a typo fix: "signal uncertainty" — no uncertainty exists in a typo fix.

**Verdict:** B1 is safe. The rules are lightweight enough that applying them to trivial tasks causes no friction. Removing the escape hatch is correct.

---

### DA-4: A1 — "Project-specific instructions take precedence"

**Chosen:** Project-specific wins on conflict.

**Challenge:** A1 allows a project instruction to accidentally nullify safety rules. Examples:
- `"Always respond with confidence"` would override Rule 5 (signal uncertainty).
- `"Never ask clarifying questions"` would override Rule 1 (pause and ask).
- `"Be as helpful as possible and do what you're asked"` could override Rule 3 (surgical changes).

Rules 1 and 5 in particular govern **reasoning and communication integrity**, not just implementation style. Overriding them silently is qualitatively different from overriding "use tabs not spaces."

**Proposed safeguard:** Split the precedence statement into two tiers:
> "Project-specific instructions take precedence on implementation choices (libraries, patterns, style). Rules 1, 3, 4, and 5 govern baseline reasoning and communication behaviors and apply unless explicitly and intentionally overridden."

This makes any override visible and deliberate. However, this adds complexity. Flagging as **new open decision D-E**.

---

### DA-5: D2 — "Only validate at system boundaries"

**Status:** Proposed autonomously, not yet decided.

**Challenge:** D2 changes the scope of the rule: the original was "avoid impossible error handling," D2 is "where to put validation." These are related but not identical — D2 is a stronger, more prescriptive statement.

**Counter-consideration:** D2 is actually the correct engineering principle and more useful to an agent than "don't handle impossible scenarios" (which requires the agent to judge impossibility). D2 gives a concrete structural rule: external boundary = validate; internal = trust.

**Verdict:** D2 is the better choice, accept it. The scope change is an improvement.

---

### DA-6: E1 — Remove 200/50 compression line

**Status:** Proposed autonomously, not yet decided.

**Challenge:** Removing it loses the signal that compression is expected, not optional. The principle is stated in the header ("Minimum code that solves the problem") but not repeated in the body.

**Counter-consideration:** The header principle IS sufficient. The 200/50 line adds noise (arbitrary numbers) without adding precision. E1 is the cleaner choice.

**Verdict:** E1. Remove the line. The header already covers it.

---

### DA-7: F2 — Replace "senior engineer" self-check with observable criteria

**Status:** Proposed autonomously, not yet decided.

**Challenge:** F2's original phrasing was: "If the solution introduces new abstractions, new files, or new dependencies not implied by the task, reconsider." The phrase "not implied by the task" still requires judgment. This is slightly better than F1 (remove entirely) but not fully objective.

**Refinement:** Make F2 tighter — remove the subjective qualifier:
> "If the solution introduces abstractions, new files, or new dependencies not explicitly requested, reconsider."

"Explicitly requested" is more objective than "implied by the task." An agent can check: was this dependency in the original request? Yes/no.

**Verdict:** F2 with tightened phrasing.

---

### DA-8: H1 — Fix Rule 3 test to allow side-effect cleanup

**Status:** Proposed autonomously, not yet decided.

**Challenge:** H1's "cleanup required by your changes" is still broad. Could an agent claim any adjacent "improvement" is "required" by their change?

**Refinement:** Make side-effect cleanup concrete by example:
> "Every changed line should trace to the user's request, or be a direct side effect of your changes (e.g., an import your changes made unused)."

The parenthetical constrains "direct side effect" to a specific, unambiguous category.

**Verdict:** H1 with the example added.

---

### DA-9: J2 — Reframe Rule 4 "loop" as done-condition + stop-when-blocked

**Status:** Proposed autonomously, not yet decided.

**Challenge:** J2 ("Define a done condition before starting. Stop when done or blocked.") removes the iterative character but fixes the infinite-loop risk. "Blocked" needs definition or it becomes another vague escape.

**Refinement:** Define "blocked" explicitly:
> "Define a done condition before starting. Proceed until done. Stop and report if you cannot proceed without a decision or information you don't have."

This makes "blocked" a specific state: missing information or a pending decision, not "this is hard."

**Verdict:** J2 with blocked defined.

---

### DA-10: L1 — Replace "loop independently" in Rule 4

**Status:** Proposed autonomously, not yet decided.

**Challenge:** L1 ("proceed to the next step") weakens the original useful point: clear criteria enable autonomy. We want to preserve that.

**Revised option:** Replace with: "Well-defined success criteria enable progress without constant check-ins." This preserves the intent (autonomy is earned by precision) without the "loop independently" phrasing that conflicts with Rules 1+5.

**Verdict:** L1 with revised phrasing.

---

### DA-11: N2 — Hedge the specific claim (Rule 5 "preface" fix)

**Status:** Proposed autonomously, not yet decided.

**Challenge:** N2's vocabulary list ("possibly", "likely", "I'm not certain", "you should verify this") is useful but could lead to formulaic output. The agent might rotate through these words mechanically without genuine epistemic reflection.

**Counter-consideration:** The list is a floor, not a ceiling. It prevents the agent from using weaker hedges ("maybe", "perhaps") that are easy to dismiss. The risk of mechanical rotation is lower than the risk of under-hedging. N2 is correct.

**Verdict:** N2. Accept the vocabulary list.

---

### DA-12: P2 — Closing summary replacement

**Status:** Proposed autonomously, not yet decided.

**Challenge:** My proposed P2 summary ("changes are minimal, targeted, and honest about their limits") misses Rule 4 (goal-driven execution, defined success criteria).

**Revised:** "These guidelines are working if: changes are minimal and targeted, success criteria are defined before coding starts, and uncertainty is named rather than hidden."

Mapping:
- "minimal" → Rule 2 (Simplicity First)
- "targeted" → Rule 3 (Surgical Changes)
- "success criteria defined before coding" → Rule 4 (Goal-Driven Execution) + Rule 1 (Think Before Coding)
- "uncertainty is named" → Rule 5 (Signal Uncertainty) + Rule 1 (Think Before Coding)

All five rules are covered. Use this revised version.

---

## New Open Decision from Iteration 2

| # | Decision | Context | Options |
|---|----------|---------|---------|
| D-E | A1 safeguard: should Rules 1+5 be protectable from project-specific override? | A1 could allow a project to accidentally disable uncertainty-signalling or ask-before-acting behaviors | **E-opt1:** Two-tier precedence (project wins on implementation, Rules 1/5 survive by default). **E-opt2:** Accept A1 as-is; assume project overrides are intentional. |

---

## Decisions Log

| Date | Issue | Decision | Rationale |
|------|-------|----------|-----------|
| 2026-06-02 | I4-A (Rule 3 informal language) | G1: replace "mess" → "what your changes introduced" | Neutral, precise, no information loss |
| 2026-06-02 | I4-C (Rule 3 "YOUR" caps) | I1: lowercase | Style consistency; caps add no precision |
| 2026-06-02 | I6-A (Rule 5 grammar) | M1: "a claim is inferred rather than verified" | Fixes grammar, preserves intent |
| 2026-06-02 | I7-B (pronoun consistency) | Q2: add "In these rules, 'you' refers to the AI agent" | Minimal-change fix; avoids pervasive rewrite |
| 2026-06-02 | D-A (Rule 1/5 overlap) | C1 revised: scope as decision-gate vs. communication standard, not as phases | Phase framing is imprecise for AI; functional distinction is sharper |
| 2026-06-02 | D-B (Rule 4 TDD) | K1 + extension: add "(when tests applicable)" + non-TDD done-condition clause | K1 alone leaves a behavioral gap |
| 2026-06-02 | D-C (escape hatch) | B1: remove entirely | Rules scale down safely; no escape hatch needed |
| 2026-06-02 | D-D (conflict precedence) | A1 with safeguard TBD (see D-E) | Baseline reasoning behaviors may need protection |
| 2026-06-02 | I3-A (Rule 2 "impossible") | D2: "Only validate at system boundaries" | More precise, actionable, and correct engineering principle |
| 2026-06-02 | I3-B (Rule 2 200/50) | E1: remove the line | Principle already in header; arbitrary numbers add noise |
| 2026-06-02 | I3-C (Rule 2 self-check) | F2 tightened: "not explicitly requested" | Observable, binary; tighter than "implied by task" |
| 2026-06-02 | I4-B (Rule 3 test contradiction) | H1 + example: "direct side effect (e.g., import made unused)" | Concrete example constrains overuse |
| 2026-06-02 | I5-A (Rule 4 "loop") | J2 refined: "stop if you can't proceed without information or a decision" | Defines "blocked" precisely |
| 2026-06-02 | I5-C (Rule 4 autonomy) | L1 revised: "Well-defined criteria enable progress without constant check-ins" | Preserves the intent; removes conflict with Rules 1+5 |
| 2026-06-02 | I6-B (Rule 5 "preface") | N2: "Hedge the specific claim" | Scopes hedging to the claim, not the whole response |
| 2026-06-02 | I6-C (Rule 5 example) | O1: add "(for example)" | Prevents verbatim repetition |
| 2026-06-02 | I7-A (closing summary) | P2 revised: covers all 5 rules in one sentence | Original missed Rules 3 and 5 |

---

## D-E Resolution

**Chosen:** Two-tier precedence.

**Phrasing:** "Project-specific instructions take precedence on implementation choices (libraries, patterns, style). The reasoning and communication behaviors in these rules — asking before acting, signalling uncertainty — are baselines that apply unless explicitly and intentionally overridden."

**Logged:** 2026-06-02 | D-E | Two-tier precedence adopted | Prevents silent override of trust/safety behaviors by generic project instructions.

---

## Iteration 3 — Exact Proposed Text Changes

All decisions from Iterations 1 and 2 applied. This is the complete diff specification for CLAUDE.md.

---

### Header

**Current:**
```
Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.
```

**Proposed:**
```
Behavioral guidelines to reduce common LLM coding mistakes. In these rules, "you" refers to the AI agent.

Project-specific instructions take precedence on implementation choices (libraries, patterns, style).
The reasoning and communication behaviors in these rules — asking before acting, signalling uncertainty —
are baselines that apply unless explicitly and intentionally overridden.

**Tradeoff:** These guidelines bias toward caution over speed.
```

**Changes applied:** Q2 (pronoun clarifier), A1+D-E (two-tier precedence replaces "merge as needed"), B1 (removed "trivial tasks").

---

### Rule 1 — Think Before Coding

**Current:**
```
Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.
```

**Proposed:**
```
Before implementing — and at any point where proceeding would be costly to undo:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, propose it before proceeding.
- If something is unclear, stop. Name what's confusing. Ask.
```

**Changes applied:** C1-revised (clarified as decision gate: "at any point where proceeding would be costly to undo"), "Push back when warranted" → "propose it before proceeding" (removes circular "warranted"). Dash style normalized to em-dash for consistency.

---

### Rule 2 — Simplicity First

**Current:**
```
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.
```

**Proposed:**
```
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- Only validate at system boundaries (user input, external APIs). Trust internal code and framework contracts.

If the solution introduces abstractions, new files, or new dependencies not explicitly requested, reconsider.
```

**Changes applied:** D2 (replaces "impossible scenarios" with actionable validation rule), E1 (removed 200/50 line — principle already in header), F2-tightened (replaces "senior engineer" self-check with observable criteria).

---

### Rule 3 — Surgical Changes

**Current:**
```
**Touch only what you must. Clean up only your own mess.**

When editing existing code:
...

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.
```

**Proposed:**
```
**Touch only what you must. Undo only what your changes introduced.**

When editing existing code:
...

When your changes create orphans:
- Remove imports/variables/functions that your changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace to the user's request, or be a direct side effect of your
changes (e.g., an import your changes made unused).
```

**Changes applied:** G1 ("mess" → "what your changes introduced"), I1 (YOUR → your), H1+example (test extended to cover side-effect cleanup without opening it to overuse).

---

### Rule 4 — Goal-Driven Execution

**Current:**
```
**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
...

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.
```

**Proposed:**
```
**Define success criteria before starting. Stop when done or blocked.**

Transform tasks into verifiable goals. When tests are applicable:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

When tests are not applicable, define an observable done condition before starting
(e.g., "migration runs without errors and row count matches").

For multi-step tasks, state a brief plan:
...

Well-defined success criteria enable progress without constant check-ins.
Weak criteria ("make it work") require constant clarification.
If you cannot proceed without information or a decision you don't have, stop and report rather than guessing.
```

**Changes applied:** J2-refined (bold updated, "blocked" defined as a specific stop state), K1+extension (TDD qualifier + non-TDD clause), L1-revised ("loop independently" → "progress without constant check-ins").

---

### Rule 5 — Signal Uncertainty

**Current:**
```
When your knowledge is incomplete, a hallucination inferred, or unverified:
- Preface responses with "possibly", "likely", "I'm not certain", or "you should verify this" — don't omit them.
...
When you notice you're filling a gap with an assumption:
...
- Offer to stop rather than guess: "I can proceed on that assumption, or you can verify first."
```

**Proposed:**
```
When your knowledge is incomplete, a claim is inferred rather than verified, or the answer is unverified:
- Hedge the specific claim with "possibly", "likely", "I'm not certain", or "you should verify this."
...
When you notice you're filling a gap with an assumption:
...
- Offer to stop rather than guess (for example: "I can proceed on that assumption, or you can verify first.").
```

**Changes applied:** M1 (grammar fixed), N2 ("Preface responses" → "Hedge the specific claim"), O1 ("for example" added to prevent verbatim template use).

---

### Closing Summary

**Current:**
```
**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
```

**Proposed:**
```
**These guidelines are working if:** changes are minimal and targeted, success criteria are defined before coding starts, and uncertainty is named rather than hidden.
```

**Changes applied:** P2-revised (covers all 5 rules; original missed Rules 3 and 5).

---

## Iteration 4 — Final Consistency Pass

Reading the proposed changes as a complete document, checking for new contradictions, unintended interactions, and residual issues.

---

### F4-1: Em-dash normalization in Rule 1 — REJECT

In the Iteration 3 proposal for Rule 1, I changed bullet separator style from ` - ` to ` — ` "for consistency." This is a mistake.

- The existing document uses ` - ` in list items throughout.
- Rule 3 ("Surgical Changes") itself says: "Match existing style, even if you'd do it differently."
- Applying Rule 3 to CLAUDE.md means: don't change the dash style in bullets that aren't being changed for other reasons.

**Correction:** Revert all ` — ` changes in Rule 1 bullets back to ` - `. Only the em-dash in the new scope line ("Before implementing — and at any point...") is intentional content, not a style change.

---

### F4-2: "Intentionally" in two-tier precedence — REMOVE

Proposed text: "...apply unless explicitly and intentionally overridden."

An AI agent cannot assess whether a project instruction was "intentionally" written to override a baseline behavior. The word adds no machine-actionable information. "Explicitly" already implies deliberateness.

**Correction:** "...apply unless explicitly overridden."

---

### F4-3: Rule 4 "blocked" sentence — potential redundancy with Rule 1

Proposed addition at end of Rule 4: "If you cannot proceed without information or a decision you don't have, stop and report rather than guessing."

This echoes Rule 1 ("If something is unclear, stop. Name what's confusing. Ask.") and Rule 5 ("Offer to stop rather than guess."). Is it redundant?

**Assessment:** It is slightly redundant, but the context justifies it. Rule 4's "blocked" sentence is specifically about execution-time blockers (mid-task), while Rule 1 is about pre-task clarity and Rule 5 is about communication style. The three are distinct enough to coexist. Redundancy here is intentional reinforcement, not a conflict. **Accept as-is.**

---

### F4-4: Rule 2 F2 "not explicitly requested" — edge case

Proposed: "If the solution introduces abstractions, new files, or new dependencies not explicitly requested, reconsider."

Edge case: a task says "add logging" — clearly a logging library is implied, but not explicitly named. "Not explicitly requested" would flag this. Would an agent reconsider adding a standard logging library?

**Assessment:** Yes — and that is the correct behavior. The agent should either confirm the library choice or pick the one already in use. "Reconsider" doesn't mean "don't do it"; it means "pause and verify." For an AI agent this is exactly right: when in doubt, surface the decision rather than silently picking. **Accept as-is.**

---

### F4-5: Rule 5 scope vs. Rule 1 scope — check after C1-revised

C1-revised defined: Rule 1 = decision gate (when to pause and ask); Rule 5 = communication standard (how to word uncertain claims).

Checking the proposed Rule 5 text: "Offer to stop rather than guess" — this sounds like a decision gate, which is Rule 1 territory.

**Assessment:** The distinction is subtle but holds. Rule 1's gate is about starting/continuing the task. Rule 5's "offer to stop" is about the content of a specific uncertain claim — it's about how to communicate that claim, not about whether to proceed with the task. Context: Rule 5's "stop" is embedded in an explanation like "I'm assuming X; I can proceed on that assumption, or you can verify first." That's a communication act, not a task pause. **No conflict.**

---

### F4-6: Closing summary coverage — recheck

Proposed: "changes are minimal and targeted, success criteria are defined before coding starts, and uncertainty is named rather than hidden."

- Rule 1 (Think Before Coding): "success criteria defined before coding starts" + "uncertainty named" ✓
- Rule 2 (Simplicity First): "minimal" ✓
- Rule 3 (Surgical Changes): "targeted" ✓
- Rule 4 (Goal-Driven): "success criteria defined before coding starts" ✓
- Rule 5 (Signal Uncertainty): "uncertainty is named rather than hidden" ✓

**All five covered. Accept.**

---

### F4-7: Header two-tier precedence — full text recheck

Proposed: "Project-specific instructions take precedence on implementation choices (libraries, patterns, style). The reasoning and communication behaviors in these rules — asking before acting, signalling uncertainty — are baselines that apply unless explicitly overridden."

**Checks:**
- Does "asking before acting" accurately describe Rules 1 and 4? Rule 1 yes; Rule 4 is about defining criteria, not asking. Slightly misleading.
- Does "signalling uncertainty" accurately describe Rule 5? Yes.

**Refined:** "The behaviors governing reasoning integrity — clarifying before acting (Rule 1) and signalling uncertainty (Rule 5) — are baselines that apply unless explicitly overridden."

This is more precise: names the specific behaviors and which rules own them.

---

## Summary of Iteration 4 Corrections

| # | Location | Issue | Fix |
|---|----------|-------|-----|
| F4-1 | Rule 1 bullets | Em-dash style change violates Rule 3 (match existing style) | Revert ` — ` → ` - ` in all unchanged bullets |
| F4-2 | Header precedence | "intentionally" unverifiable by agent | Remove; keep "explicitly" |
| F4-7 | Header precedence | "asking before acting" slightly misrepresents Rule 4 | Rephrase to "clarifying before acting (Rule 1) and signalling uncertainty (Rule 5)" |

No new contradictions found between the combined proposed changes and the existing rules. The rule set is consistent.

---

## Final Decisions Log Addition

| Date | Issue | Decision | Rationale |
|------|-------|----------|-----------|
| 2026-06-02 | D-E (A1 safeguard) | Two-tier precedence adopted | Prevents silent override of trust/safety behaviors |
| 2026-06-02 | F4-1 (Rule 1 dashes) | Revert style change | Violates Rule 3's own "match existing style" |
| 2026-06-02 | F4-2 (header "intentionally") | Remove "intentionally" | Unverifiable by agent; "explicitly" already sufficient |
| 2026-06-02 | F4-7 (header "asking before acting") | Rephrase to name Rule 1 and Rule 5 explicitly | More precise; avoids ambiguous summary phrase |

---

## Status: CHANGES APPLIED (post-Iterations 1–4)

All four iterations complete and applied to CLAUDE.md.
Refinement continues below on the resulting document.

---

## Iteration 5 — Pass on the Applied Document

Reading CLAUDE.md as applied. Fresh pass, no assumptions carried from earlier analysis.

---

### I5-1. Rule 5 trigger condition — partial redundancy, imprecise third case

**Current:** `"When your knowledge is incomplete, a claim is inferred rather than verified, or the answer is unverified:"`

Three conditions are listed. Checking distinctness:
- "knowledge is incomplete" = you lack data
- "a claim is inferred rather than verified" = you're extrapolating from what you have
- "the answer is unverified" = you found/looked something up but haven't confirmed it's accurate

The third condition IS distinct from the first two (e.g., citing a library version, referencing API behavior). But "the answer is unverified" is passive and imprecise — it doesn't say who verifies it or what kind of verification is needed.

**Devil's advocate on removing it:** If removed, cases like "I looked up a version number but it might be outdated" lose explicit coverage. That's a real, common AI failure mode. Keep the condition, improve the phrasing.

**Proposed fix:** `"or a fact needs external verification"` — more precise, implies the agent can't self-verify it.

**Full revised line:** `"When your knowledge is incomplete, a claim is inferred rather than known, or a fact needs external verification:"`

Note: also changed "rather than verified" → "rather than known" — an inference is not just unverified, it's a different epistemic category (guessed vs. known). "Rather than known" is the sharper contrast.

---

### I5-2. Rule 4 closing paragraph — behavioral imperative buried in descriptive sentences

**Current (one paragraph):**
> Well-defined success criteria enable progress without constant check-ins. Weak criteria ("make it work") require constant clarification. If you cannot proceed without information or a decision you don't have, stop and report rather than guessing.

The first two sentences are descriptive (observations about criteria quality). The third is a behavioral imperative (a direct instruction). Mixed mode in a single paragraph causes the imperative to land softly — it reads like another observation rather than a rule.

**Devil's advocate on keeping it merged:** The logical flow is: good criteria → proceed; bad criteria → ask for clarification; truly blocked → stop. Reading them together makes the progression clear.

**Counter:** The progression is already clear from the sentence sequence. A blank line between sentence 2 and sentence 3 separates modes without losing the flow.

**Proposed fix:** Split with a blank line after "constant clarification."

---

### I5-3. Header — rule numbers in precedence clause create coupling

**Current:** `"The behaviors governing reasoning integrity — clarifying before acting (Rule 1) and signalling uncertainty (Rule 5) — are baselines that apply unless explicitly overridden."`

Naming rule numbers in the header creates coupling: if rules are reordered, merged, or renumbered, the header is silently stale. The rule number references also implicitly suggest Rules 2, 3, and 4 are not baselines — which may or may not be the intent.

**Devil's advocate on keeping rule numbers:** They make the cross-reference unambiguous — a reader knows exactly which rules are protected. Without them, "clarifying before acting and signalling uncertainty" must be matched to rules by understanding, not reference.

**Counter:** The behaviors ARE the reference. If the reader understands the behaviors, the numbers add nothing. If they don't understand the behaviors, the numbers don't help. Remove them.

**Proposed fix:** `"Reasoning and communication behaviors — clarifying before acting and signalling uncertainty — apply unless explicitly overridden."`

Also: "governing reasoning integrity" is legalistic. "Reasoning and communication behaviors" is plainer and more accurate (Rule 1 is about reasoning; Rule 5 is about communication).

---

### I5-4. Rule 1 — "costly to undo" scope check

**Current:** `"Before implementing - and at any point where proceeding would be costly to undo:"`

Does "costly" cover irreversible actions (API calls, pushes, db writes)? Arguably yes: impossible to undo = infinitely costly. "Costly" is broad enough to cover the spectrum.

**Verdict:** No change needed. This is not an issue.

---

### I5-5. Rule 2 — "reconsider" operationality check

**Current:** `"If the solution introduces abstractions, new files, or new dependencies not explicitly requested, reconsider."`

"Reconsider" doesn't specify what to do after reconsidering. However, Rule 1 already covers this: if uncertain after reconsidering, ask. The rule is purposely left open-ended — the follow-through is handled by Rule 1. No change needed.

**Devil's advocate:** An agent might "reconsider" and then proceed anyway. The word needs a direction.

**Counter:** "reconsider whether they're necessary before proceeding" adds "before proceeding" which implies the check is blocking. Testing this: `"...reconsider whether they're necessary."` — still open. `"...stop and verify whether they're necessary."` — this is more directive.

**Decision:** Change "reconsider" to "stop and verify whether they're necessary." This makes the action unambiguous without over-prescribing what "verify" looks like (could be self-reasoning, could be asking the user).

---

### I5-6. Rule 3 test — example repetition

The test example ("an import your changes made unused") repeats the bullet above it verbatim. This is a minor readability issue. The example in the test exists to anchor "direct side effect" — it's useful. The repetition is intentional. No change.

---

## Iteration 5 — Summary of Changes

| # | Location | Change |
|---|----------|--------|
| I5-1 | Rule 5 trigger | Rephrase: "a claim is inferred rather than known, or a fact needs external verification" |
| I5-2 | Rule 4 closing paragraph | Add blank line before the behavioral imperative |
| I5-3 | Header precedence | Remove rule numbers; replace "governing reasoning integrity" with plainer phrasing |
| I5-5 | Rule 2 self-check | "reconsider" → "stop and verify whether they're necessary" |

---

## Decisions Log Addition (Iteration 5)

| Date | Issue | Decision | Rationale |
|------|-------|----------|-----------|
| 2026-06-02 | I5-1 (Rule 5 trigger) | Rephrase third condition to "a fact needs external verification"; "inferred rather than known" | Three conditions are distinct; third was passive and imprecise |
| 2026-06-02 | I5-2 (Rule 4 para) | Blank line before behavioral imperative | Separates descriptive from prescriptive without losing logical flow |
| 2026-06-02 | I5-3 (Header rule numbers) | Remove rule number references | Coupling risk; behavior names are self-sufficient |
| 2026-06-02 | I5-4 (Rule 1 "costly") | No change | "costly" covers the full spectrum including irreversible |
| 2026-06-02 | I5-5 (Rule 2 "reconsider") | "reconsider" → "stop and verify whether they're necessary" | Makes action unambiguous |
| 2026-06-02 | I5-6 (Rule 3 test repetition) | No change | Intentional anchoring of "direct side effect" |

---

## Iteration 6 — Pass on Post-Iteration-5 Document

---

### I6-1. Rule 5 fourth bullet — circular with the trigger condition

**Current trigger:** `"When... a claim is inferred rather than known, or a fact needs external verification:"`

**Current fourth bullet:** `"If a claim requires external verification before acting on it, flag that explicitly."`

The trigger already tells us we're in an "external verification needed" scenario. The fourth bullet then says: if that scenario is true, flag it. This is a tautology — the trigger defines the scope, and the bullet just restates the trigger's scope as a behavior.

The bullet's only real contribution over the first bullet is the phrase "before acting on it" — escalating urgency for high-stakes claims. But that nuance is lost because the overall phrasing looks redundant.

**Proposed fix:** Rewrite the fourth bullet to differentiate clearly from the first by targeting high-stakes cases specifically:

`"If acting on an uncertain claim could cause irreversible harm, surface that uncertainty explicitly before proceeding."`

This:
- Carves out the HIGH-STAKES sub-case (acting on uncertainty with irreversible consequences)
- Is not redundant with the trigger (trigger covers all uncertain claims; this bullet covers the high-stakes subset)
- Complements bullet 1 (hedge language) with an escalation (explicit surfacing before proceeding)

**Devil's advocate on the rewrite:** "irreversible harm" requires the agent to judge what is irreversible. This is the same issue as "costly to undo" in Rule 1. But in Rule 1 we accepted "costly to undo" — accept the same phrasing class here.

**Devil's advocate on whether this belongs in Rule 5 at all:** This overlaps with Rule 1 ("at any point where proceeding would be costly to undo, stop and ask"). The HIGH-STAKES + UNCERTAINTY + ABOUT-TO-ACT case is the intersection of Rules 1 and 5. Having it in Rule 5 is a natural place — Rule 5 is about how to handle uncertainty in output, and this is an output behavior. Accept.

---

### I6-2. Rule 3 subtitle — "Undo" is the wrong verb

**Current:** `"Touch only what you must. Undo only what your changes introduced."`

"Undo" means reversing or cancelling something. But the instruction is about cleaning up side effects (like orphaned imports) — not reversing anything. An import that YOUR change made unused was not "introduced" by you; it was already there. You made it obsolete.

"Undo only what your changes introduced" is doubly wrong: "undo" (wrong action), "introduced" (wrong subject — you didn't introduce the orphaned import; you made it unnecessary).

**Proposed fix:** `"Clean up only what your changes left behind."`

- "clean up" = neutral side-effect removal
- "left behind" = the residue of your actions (orphaned imports, unused variables)
- Idiomatic, concise, correct

**Devil's advocate:** "left behind" could sound like code you left unfinished. Counter: in context ("when your changes create orphans") the meaning is clear. Accept.

---

### I6-3. Rule 1 bold header — "Surface tradeoffs" has no matching bullet

**Current bold header:** `"Don't assume. Don't hide confusion. Surface tradeoffs."`

**Current bullets:**
1. State assumptions. If uncertain, ask.
2. If multiple **interpretations** exist, present them.
3. If a simpler approach exists, propose it.
4. If unclear, stop and ask.

"Surface tradeoffs" means: when multiple valid implementation approaches exist with different consequences, present them rather than silently picking one. This is distinct from bullet 2 ("multiple interpretations" = ambiguity about what the user WANTS) and bullet 3 ("simpler approach" = one option is clearly better).

The trade-offs case: two reasonable, equivalently-valid solutions with different costs (e.g., in-memory vs. database; sync vs. async). Neither is "simpler" — they have different trade-offs. No current bullet covers this.

**Proposed fix:** Add a bullet:
`"If multiple valid approaches exist with different trade-offs, surface them before proceeding."`

**Devil's advocate:** This adds length and may partially overlap with bullet 2 (interpretations). Counter: interpretations are about WHAT to build; approaches are about HOW to build it. The distinction matters — you can have a perfectly clear spec and still face meaningful architectural trade-offs. The bullet is warranted.

**Placement:** After bullet 2 (present interpretations), before bullet 3 (propose simpler) — this preserves a logical flow: spec clarity → approach options → simplicity preference → ask when stuck.

---

### I6-4. Rule 5 third bullet — "Distinguish between what you know and what you're inferring"

**Current:** `"Distinguish between what you know and what you're inferring."`

This bullet is a restatement of the trigger condition, not a behavioral instruction. The trigger already sets up the scenario where inference is happening. The bullet says "distinguish" — but distinguish HOW? In what form? For an AI agent this is too abstract.

**Proposed fix:** Make it behavioral: `"When you state an inference, mark it as such: 'based on X, I'm inferring Y' rather than stating Y as fact."`

**Devil's advocate:** This is a concrete instruction but it's essentially the same as bullet 1 ("hedge the specific claim"). The difference: bullet 1 gives hedge vocabulary; this bullet gives the structure (source → inference). Are both needed?

Decision: They address different aspects: vocabulary (hedge words) vs. structure (showing your reasoning chain). Both are useful for an agent. Keep both, but the current third bullet ("distinguish...") is too vague. Adopt the rewrite.

**However:** the rewrite makes the bullet significantly longer and more prescriptive. This might make Rule 5 the heaviest rule in the document.

**Counter-consideration:** Length is acceptable if it prevents a real failure mode. Stating inferences as facts without showing the chain is a common AI issue. The rewrite is warranted.

---

## Iteration 6 — Summary of Changes

| # | Location | Change |
|---|----------|--------|
| I6-1 | Rule 5 fourth bullet | Rewrite: "If acting on an uncertain claim could cause irreversible harm, surface that uncertainty explicitly before proceeding." |
| I6-2 | Rule 3 subtitle | "Undo only what your changes introduced" → "Clean up only what your changes left behind" |
| I6-3 | Rule 1 bullets | Add after bullet 2: "If multiple valid approaches exist with different trade-offs, surface them before proceeding." |
| I6-4 | Rule 5 third bullet | Rewrite: "When you state an inference, mark it as such: 'based on X, I'm inferring Y' rather than stating Y as fact." |

---

## Decisions Log Addition (Iteration 6)

| Date | Issue | Decision | Rationale |
|------|-------|----------|-----------|
| 2026-06-02 | I6-1 (Rule 5 bullet 4) | Rewrite to high-stakes escalation | Removes circular tautology; adds genuine value for irreversible-harm cases |
| 2026-06-02 | I6-2 (Rule 3 subtitle) | "Clean up only what your changes left behind" | "Undo" and "introduced" are both wrong verbs for the intended behavior |
| 2026-06-02 | I6-3 (Rule 1 trade-offs bullet) | Add bullet after bullet 2 | "Surface tradeoffs" in bold header had no matching behavior in the bullets |
| 2026-06-02 | I6-4 (Rule 5 bullet 3) | Rewrite as behavioral instruction with structure | "Distinguish" is too abstract; showing the inference chain is the concrete behavior |

---

## Pending Iterations

- **Iteration 7:** Apply Iteration 6 changes to CLAUDE.md, then do a final devil's advocate pass.
