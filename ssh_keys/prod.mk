# Production (lyk-prod-backend.pem)

.PHONY: prod-be

prod-be: ## prod -> backend
	$(SSH) -i $(KEYDIR)/lyk-prod-backend.pem $(SSH_OPTS) ubuntu@52.91.179.43
