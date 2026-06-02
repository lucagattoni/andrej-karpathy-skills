.PHONY: install_commands uninstall_commands

install_commands:
	bash install.sh

uninstall_commands:
	rm -f \
		~/.claude/commands/karpathy_rules_install_local.md \
		~/.claude/commands/karpathy_rules_install_repo.md \
		~/.claude/commands/karpathy_rules_update.md \
		~/.claude/commands/karpathy_rules_check.md
