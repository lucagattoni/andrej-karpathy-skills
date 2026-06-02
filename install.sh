#!/usr/bin/env bash
set -euo pipefail

REPO="lucagattoni/andrej-karpathy-skills"
BASE_URL="https://raw.githubusercontent.com/${REPO}/main"
COMMANDS_DIR="${HOME}/.claude/commands"
COMMANDS=(
  karpathy_rules_install_local
  karpathy_rules_install_repo
  karpathy_rules_update
  karpathy_rules_check
)

echo "Installing Claude Code commands for Karpathy's rules..."
mkdir -p "${COMMANDS_DIR}"

for cmd in "${COMMANDS[@]}"; do
  dest="${COMMANDS_DIR}/${cmd}.md"
  if curl -s -f -o "${dest}" "${BASE_URL}/.claude/commands/${cmd}.md"; then
    echo "  ✓ ${cmd}"
  else
    echo "  ✗ ${cmd} — download failed" >&2
    exit 1
  fi
done

echo ""
echo "Installed to ${COMMANDS_DIR}"
echo "Run /karpathy_rules_install_local or /karpathy_rules_install_repo in Claude Code to get started."
