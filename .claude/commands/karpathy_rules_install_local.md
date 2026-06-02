Install Karpathy coding guidelines globally into ~/.claude/CLAUDE.md and install all four Karpathy commands into ~/.claude/commands/.

## Step 1 — Fetch the latest rules

```bash
curl -s https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/CLAUDE.md
```

Store the output as the incoming rules.

## Step 2 — Check for existing installation

```bash
cat ~/.claude/CLAUDE.md 2>/dev/null
```

If the file contains "Behavioral guidelines to reduce common LLM coding mistakes", the Karpathy rules are already installed. Ask the user: "Karpathy rules are already installed globally. Update to the latest version?" If yes, replace the Karpathy block (everything from the first line of the file to the first `---` separator, or the whole file if no separator exists) with the incoming rules, preserving any content below the separator. Then skip to Step 4.

## Step 3 — Back up the existing file

If `~/.claude/CLAUDE.md` exists, create a backup before modifying it:

```bash
[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE-$(date +%Y%m%d).md.bkp
```

## Step 4 — Install the rules

**~/.claude/CLAUDE.md does not exist:** write the incoming rules as the file.

**File exists with no Karpathy rules:** prepend the incoming rules at the top, add a blank line, then the existing content below.

## Step 5 — Install all four commands globally

```bash
mkdir -p ~/.claude/commands
curl -s -o ~/.claude/commands/karpathy_rules_install_local.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_install_local.md
curl -s -o ~/.claude/commands/karpathy_rules_install_repo.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_install_repo.md
curl -s -o ~/.claude/commands/karpathy_rules_update.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_update.md
curl -s -o ~/.claude/commands/karpathy_rules_check.md https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/.claude/commands/karpathy_rules_check.md
```

Verify each curl exited with code 0. Report success or failure per file.

## Step 6 — Offer a code review

Check whether the current directory is a git repo with tracked files:

```bash
git ls-files 2>/dev/null | grep -v "^CLAUDE.md$" | head -1
```

If files are found, ask: "Would you like to run karpathy_rules_check to review the current project against the guidelines?" If yes, read `~/.claude/commands/karpathy_rules_check.md` and execute its steps now.
