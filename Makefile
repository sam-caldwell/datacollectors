DB_HOST:=10.37.129.2
DB_USER:="postgres"
DB_PASS:="vitapro"

POSTGRES_SERVER_IMAGE:="postgresql:local"
POSTGRES_CLIENT_IMAGE:="db-client:local"

POSTGRES_CONTAINER:="postgres"

CUR_DIR:=$(shell pwd)

#ToDo: build postgresql server image.

build/db/client:
	@docker build --tag $(POSTGRES_CLIENT_IMAGE) \
                  -f $(CUR_DIR)/data/Dockerfile .

stop/db/server:
	@docker kill $(POSTGRES_CONTAINER) &> /dev/null || true
	@echo "db server killed"

start/db/server: stop/db/server
	docker run -d \
			   --rm \
			   --publish $(DB_HOST):5432:5432 \
			   --name $(POSTGRES_CONTAINER) \
			   --volume $(CUR_DIR)/storage/db:/var/lib/postgresql \
			   --volume $(CUR_DIR)/storage/db_init:/docker-entrypoint-initdb.d \
			   --volume $(CUR_DIR)/storage/db_preinit:/docker-entrypoint-preinitdb.d \
			   -e POSTGRESQL_DATABASE=$(DB_USER) \
			   -e POSTGRESQL_PASSWORD=$(DB_PASS) \
			   $(POSTGRES_SERVER_IMAGE)

deploy/db/schema: start/db/server build/db/client
	docker run -it \
			   --volume $(CUR_DIR)/data/:/opt/ \
			   -e DB_HOST=$(DB_HOST) \
			   -e DB_USER=$(DB_USER) \
			   -e DB_PASS=$(DB_PASS) \
			   $(POSTGRES_CLIENT_IMAGE)
