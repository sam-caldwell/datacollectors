#
#
#

db/clean/server: db/stop/server
	@docker rmi -f $(POSTGRES_SERVER_IMAGE) &> /dev/null || true
	@rm -rf $(CUR_DIR)/storage/db/*
	@rm -rf $(CUR_DIR)/storage/db_init/*
	@rm -rf $(CUR_DIR)/storage/db_preinit/*
	@echo "db server cleaned"
