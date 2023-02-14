#
#
#

db/stop/server:
	@docker kill $(POSTGRES_SERVER_CONTAINER) &> /dev/null || true
	@docker rm $(POSTGRES_SERVER_CONTAINER) &>/dev/null || true
	@echo "db server stopped"
