#
#
#

db/install: db/clean \
		    docker/build/postgresql
	@python3 src/db_installer --manifest data \
							  --db_host $(DB_HOST) \
							  --db_port $(DB_PORT) \
							  --db_user $(DB_USER) \
							  --db_pass $(DB_PASS) \
							  --db_name $(DB_NAME)
	@say "make file finished"
