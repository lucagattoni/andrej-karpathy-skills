Integrate the Karpathy coding guidelines into this project's CLAUDE.md. Work through each step in order and report what you did at the end.

## Step 1 — Fetch the latest rules

Run:
```bash
curl -s https://raw.githubusercontent.com/lucagattoni/andrej-karpathy-skills/main/CLAUDE.md
```

This is the canonical rules content. Hold it as "the incoming rules".

## Step 2 — Read the existing CLAUDE.md

Check whether a CLAUDE.md exists at the project root. If it does, read its full contents.

## Step 3 — Merge

Apply the correct case:

**No CLAUDE.md exists** — Write the incoming rules directly as CLAUDE.md. Done.

**CLAUDE.md exists, no prior behavioural rules** (only project-specific sections: library choices, naming conventions, tooling, etc.) — Prepend the incoming rules at the top of the file, add a blank line separator, then the existing content below.

**CLAUDE.md exists with prior behavioural rules** —
1. Go through the existing rules line by line. Identify anything that:
   - Directly conflicts with the incoming rules
   - Is made redundant because the incoming rules cover the same behaviour more precisely
   - Uses vague or ambiguous phrasing that the incoming rules replace with a clearer version
2. Remove or consolidate those entries. Preserve all project-specific sections unchanged.
3. Integrate the incoming rules cleanly, without duplicating content.
4. After writing the merged file, report a short summary: what was removed or changed and why.

## Step 4 — Offer a code review for pre-existing projects

Run:
```bash
find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.tsx" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.java" -o -name "*.rb" -o -name "*.cpp" -o -name "*.c" -o -name "*.swift" -o -name "*.kt" -o -name "*.cs" \) -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" -not -path "*/build/*" -not -path "*/.next/*" | head -1
```

If any source files are found, ask the user:

> "Would you like a full code review against the new guidelines?"
