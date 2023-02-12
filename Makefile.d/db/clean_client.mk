#
#
#

db/clean/client: db/stop/client
	@docker rmi -f $(POSTGRES_CLIENT_IMAGE) &> /dev/null || true