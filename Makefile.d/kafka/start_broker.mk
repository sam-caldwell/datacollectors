#
#
#

KAFKA_DOCKER_BROKER_START_FLAGS:=-it
#KAFKA_DOCKER_BROKER_ENTRYPOINT:= --entrypoint ''
#KAFKA_DOCKER_BROKER_CMD:=/bin/bash

#PKAFKA_DOCKER_BROKER_START_FLAGS:=-d --rm
KAFKA_DOCKER_BROKER_ENTRYPOINT:= --entrypoint '/opt/broker_entrypoint.sh'
KAFKA_DOCKER_BROKER_CMD:=''

kafka/start/broker:
	docker run $(KAFKA_DOCKER_BROKER_START_FLAGS) \
	   --name $(KAFKA_BROKER_CONTAINER) \
	   -e POSTGRESQL_DB_HOST=$(POSTGRESQL_DB_HOST) \
	   -e POSTGRESQL_DB_PORT=$(POSTGRESQL_DB_PORT) \
	   -e POSTGRESQL_DB_NAME=$(POSTGRESQL_DB_NAME) \
	   -e POSTGRESQL_DB_USER=$(POSTGRESQL_DB_USER) \
	   -e POSTGRESQL_DB_PASS=$(POSTGRESQL_DB_PASS) \
	   $(KAFKA_DOCKER_BROKER_ENTRYPOINT) \
	   --volume $(CUR_DIR)/data/postgresql/:/opt/sql/ \
	   --volume $(CUR_DIR)/src/db_installer:/usr/bin/db_installer \
	   $(KAFKA_BROKER_IMAGE) $(KAFKA_DOCKER_BROKER_CMD)
	@echo "kafka broker started"
