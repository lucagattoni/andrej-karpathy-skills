Review the current project's code against the Karpathy coding guidelines and report findings.

## Step 1 — Load the active rules

Read the rules: prefer `./CLAUDE.md` if it exists, otherwise `~/.claude/CLAUDE.md`.

## Step 2 — Survey the codebase

List all tracked source files:

```bash
git ls-files | grep -v "^CLAUDE.md$"
```

For codebases with more than 50 files, focus on the most recently changed files:

```bash
git diff --name-only HEAD~10 HEAD 2>/dev/null || git ls-files | head -20
```

Read a representative sample of these files.

## Step 3 — Review against each applicable rule

Check the code against the rules that are detectable in static code:

**Rule 2 — Simplicity First**
Look for: abstractions with a single caller, classes or modules with a single method or responsibility that could be a plain function, wrapper functions that add no logic, unused configurability or feature flags, input validation duplicated across internal layers.

**Rule 3 — Surgical Changes**
Look for: functions that mix multiple unrelated concerns, inconsistent style within a single file suggesting drive-by edits, dead imports or variables.

**Rule 4 — Goal-Driven Execution**
Look for: test files testing implementation details rather than observable behaviour, missing coverage for the main user-facing paths.

Rules 1 and 5 (Think Before Coding, Signal Uncertainty) govern behaviour during development and cannot be assessed in static code — skip them.

## Step 4 — Report

For each finding, state:
- File path and line number
- Which rule it relates to
- What the issue is
- A concrete suggested fix

Group findings by rule. If no issues are found, say so explicitly.
