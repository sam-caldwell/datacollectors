DB_HOST:=10.37.129.2
DB_PORT:=5432
DB_NAME:="postgres"
DB_USER:="postgres"
DB_PASS:="vitapro"

SRC_SCHEMA_PATH="$(HOME)/git/datacollectors/data/"

POSTGRES_DOCKERFILE:="upstream/postgresql-server/Dockerfile"
POSTGRES_BUILD_DIR:=$(shell dirname $(POSTGRES_DOCKERFILE))
POSTGRES_SERVER_IMAGE:="postgresql:local"
POSTGRES_CLIENT_IMAGE:="db-client:local"
POSTGRES_CONTAINER:="postgres"

CUR_DIR:=$(shell pwd)

build/db/list_sql_files:
	@go build -o bin/list_sql_files src/cmd/list_sql_files/main.go

build/db/installer:
	@go build -o bin/db_installer src/db_installer/main.go

build/db/server:
	@( \
		cd $(POSTGRES_BUILD_DIR) || exit 99; \
		docker rmi $(POSTGRES_SERVER_IMAGE) || true; \
		docker build --tag $(POSTGRES_SERVER_IMAGE) . \
	)

#ToDo: build postgresql server image.

#build/db/client: build/db/installer
#	@docker build --tag $(POSTGRES_CLIENT_IMAGE) \
#                  -f $(CUR_DIR)/data/Dockerfile .

stop/db/server:
	@docker kill $(POSTGRES_CONTAINER) &> /dev/null || true
	docker $(POSTGRES_CONTAINER) &>/dev/null || true
	@echo "db server killed"

start/db/server: stop/db/server
#			   --volume $(CUR_DIR)/storage/db:/var/lib/postgresql \
#			   --volume $(CUR_DIR)/storage/db_init:/docker-entrypoint-initdb.d \
#			   --volume $(CUR_DIR)/storage/db_preinit:/docker-entrypoint-preinitdb.d
	docker run -d \
			   --rm \
			   --publish $(DB_HOST):$(DB_PORT):$(DB_PORT) \
			   --name $(POSTGRES_CONTAINER) \
			   -e POSTGRESQL_DATABASE=$(DB_USER) \
			   -e POSTGRESQL_PASSWORD=$(DB_PASS) \
			   $(POSTGRES_SERVER_IMAGE)

deploy/db/schema: clean/db
	@python3 src/db_installer --manifest data \
							  --db_host $(DB_HOST) \
							  --db_port $(DB_PORT) \
							  --db_user $(DB_USER) \
							  --db_pass $(DB_PASS) \
							  --db_name $(DB_NAME)
	@say "make file finished"

#	@./bin/db_installer $(DB_HOST) $(DB_PORT) $(DB_NAME) $(DB_USER) $(DB_PASS) $(SRC_SCHEMA_PATH)
#	docker run -it \
#			   --volume $(CUR_DIR)/data/:/opt/ \
#			   -e DB_HOST=$(DB_HOST) \
#			   -e DB_USER=$(DB_USER) \
#			   -e DB_PASS=$(DB_PASS) \
#			   $(POSTGRES_CLIENT_IMAGE)
#

clean/db: stop/db/server start/db/server
	sleep 2
