Update the Karpathy rules to the latest version from https://github.com/lucagattoni/andrej-karpathy-skills. Always updates the global ~/.claude/CLAUDE.md; also offers to update the project CLAUDE.md if one is present.

## Step 1 — Fetch the latest rules

```bash
curl -s https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/CLAUDE.md
```

Store the output as the incoming rules.

## Step 2 — Update the global CLAUDE.md

```bash
cat ~/.claude/CLAUDE.md 2>/dev/null
```

**File does not exist or is empty:** write the incoming rules to ~/.claude/CLAUDE.md.

**File contains "Behavioral guidelines to reduce common LLM coding mistakes"** (Karpathy rules present): replace the Karpathy block — everything from the first line of the file to the first `---` separator, or the whole file if no separator exists — with the incoming rules. Preserve any content below the separator unchanged.

**File exists but has no Karpathy rules:** prepend the incoming rules at the top, preserve the existing content below.

Confirm: "Karpathy rules updated in ~/.claude/CLAUDE.md." Summarise what changed if there were pre-existing rules.

## Step 3 — Offer to update the project CLAUDE.md

Check whether a project-level CLAUDE.md exists in the current directory:

```bash
cat ./CLAUDE.md 2>/dev/null
```

If the file exists, ask: "A project CLAUDE.md was found. Update the Karpathy rules there too?"

If yes:

1. Back up the file first:
   ```bash
   cp ./CLAUDE.md ./CLAUDE-$(date +%Y%m%d).md.bkp
   ```

2. Apply the same update logic as Step 2, but targeting `./CLAUDE.md`.

3. Confirm: "Karpathy rules updated in ./CLAUDE.md." Summarise what changed.

If the project CLAUDE.md does not exist, skip this step silently.
