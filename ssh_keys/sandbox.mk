# Sandbox EC2 instances (lyk-sandbox.pem)

.PHONY: sandbox-backend sandbox-mysql sandbox-mongo sandbox-rds-tunnel

sandbox-backend: ## sandbox -> backend
	$(SSH) -i $(KEYDIR)/lyk-sandbox.pem $(SSH_OPTS) ubuntu@ec2-18-206-125-21.compute-1.amazonaws.com

sandbox-mysql: ## sandbox -> mysql
	$(SSH) -i $(KEYDIR)/lyk-sandbox.pem $(SSH_OPTS) ubuntu@ec2-13-223-139-168.compute-1.amazonaws.com

sandbox-mongo: ## sandbox -> mongo
	$(SSH) -i $(KEYDIR)/lyk-sandbox.pem $(SSH_OPTS) ubuntu@ec2-3-225-150-177.compute-1.amazonaws.com

sandbox-rds-tunnel: ## sandbox -> RDS tunnel (local :3307 -> RDS :3306, foreground)
	$(SSH) -i $(KEYDIR)/lyk-sandbox.pem $(SSH_OPTS) -N -L 3307:10.32.1.169:3306 ubuntu@ec2-18-206-125-21.compute-1.amazonaws.com
