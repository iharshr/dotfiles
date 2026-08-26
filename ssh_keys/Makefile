# Root Makefile — SSH shortcuts for lykstage pem keys
# Per-env targets live in included .mk files. Run `make help`.

KEYDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SSH     := ssh
SCP     := scp
SSH_OPTS := -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=60

include sandbox.mk
include prod.mk
include lg.mk
include ad.mk
include misc.mk

.PHONY: help keys

help: ## Show all SSH targets
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## ' Makefile sandbox.mk prod.mk lg.mk ad.mk misc.mk \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "keys dir: $(KEYDIR)"
	@echo "usage: make <target>   |   make scp-lg FILE=/path/to/file"

keys: ## chmod 600 all pem files
	@chmod 600 $(KEYDIR)/*.pem && echo "perms fixed: $(KEYDIR)/*.pem"
