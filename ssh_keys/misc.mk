# Misc hosts

.PHONY: arthiq

# Password auto-login via sshpass. Requires: brew install hudochenkov/sshpass/sshpass
ARTHIP_PASS := ashue@3523FD354
arthiq: ## arthiq server (password auto)
	SSHPASS='$(ARTHIP_PASS)' sshpass -e ssh -o StrictHostKeyChecking=accept-new root@187.127.146.228
