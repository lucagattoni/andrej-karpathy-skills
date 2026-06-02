Install Karpathy coding guidelines into this project's CLAUDE.md and install all four Karpathy commands into .claude/commands/.

## Step 1 — Fetch the latest rules

```bash
curl -s https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/CLAUDE.md
```

Store the output as the incoming rules.

## Step 2 — Check for existing installation

```bash
cat ./CLAUDE.md 2>/dev/null
```

If the file contains "Behavioral guidelines to reduce common LLM coding mistakes", the Karpathy rules are already installed in this project. Ask the user: "Karpathy rules are already installed in this project. Update to the latest version?" If yes, replace the Karpathy block (everything from the first line of the file to the first `---` separator, or the whole file if no separator exists) with the incoming rules, preserving any content below the separator. Then skip to Step 4.

## Step 3 — Back up the existing file

If `./CLAUDE.md` exists, create a backup before modifying it:

```bash
[ -f ./CLAUDE.md ] && cp ./CLAUDE.md ./CLAUDE-$(date +%Y%m%d).md.bkp
```

## Step 4 — Install the rules

**No CLAUDE.md exists:** write the incoming rules as CLAUDE.md.

**CLAUDE.md exists with no Karpathy rules** (only project-specific content): prepend the incoming rules at the top, add a blank line, then the existing content below.

If there are existing rules that conflict with, duplicate, or are superseded by the incoming rules: remove or consolidate them, preserve all project-specific sections, and report what changed and why.

## Step 5 — Install all four commands in the project

```bash
mkdir -p .claude/commands
curl -s -o .claude/commands/karpathy_rules_install_local.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_install_local.md
curl -s -o .claude/commands/karpathy_rules_install_repo.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_install_repo.md
curl -s -o .claude/commands/karpathy_rules_update.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_update.md
curl -s -o .claude/commands/karpathy_rules_check.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_check.md
```

Verify each curl exited with code 0. Report success or failure per file.

## Step 6 — Offer a code review

Check whether the project already has tracked files:

```bash
git ls-files | grep -v "^CLAUDE.md$" | head -1
```

If files are found, ask: "Would you like to run karpathy_rules_check to review the current project against the guidelines?" If yes, read `.claude/commands/karpathy_rules_check.md` and execute its steps now.
