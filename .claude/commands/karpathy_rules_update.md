Update the Karpathy rules in ~/.claude/CLAUDE.md to the latest version from https://github.com/lucagattoni/andrej-karpathy-skills.

## Step 1 — Fetch the latest rules

```bash
curl -s https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/CLAUDE.md
```

Store the output as the incoming rules.

## Step 2 — Read the current global CLAUDE.md

```bash
cat ~/.claude/CLAUDE.md 2>/dev/null
```

## Step 3 — Update

**File does not exist or is empty:** write the incoming rules to ~/.claude/CLAUDE.md. Done.

**File contains "Behavioral guidelines to reduce common LLM coding mistakes"** (Karpathy rules present): replace the Karpathy block — everything from the first line of the file to the first `---` separator, or the whole file if no separator exists — with the incoming rules. Preserve any content below the separator unchanged.

**File exists but has no Karpathy rules:** prepend the incoming rules at the top, preserve the existing content below.

## Step 4 — Report

Confirm: "Karpathy rules updated in ~/.claude/CLAUDE.md."

If there were pre-existing rules, summarise what changed (e.g. new rules added, bullets reworded, removed instructions).
