#
#
#

db/stop/client:
	@docker kill $(POSTGRES_CLIENT_CONTAINER) &> /dev/null || true
	@docker rm $(POSTGRES_CLIENT_CONTAINER) &>/dev/null || true
	@echo "db server killed"
