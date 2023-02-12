POSTGRESQL_DB_HOST:=10.37.129.2
POSTGRESQL_DB_PORT:=5432
POSTGRESQL_DB_NAME:="postgres"
POSTGRESQL_DB_USER:="datacollector"
POSTGRESQL_DB_PASS:="vitapro"

SRC_SCHEMA_PATH="$(HOME)/git/datacollectors/data/"

DOCKER_BASE_IMAGE:="datacollectors/base_opsys:local"
DOCKER_BASE_IMAGE_DOCKERFILE:="docker/base/Dockerfile"

POSTGRESQL_VERSION="14"
POSTGRES_DOCKERFILE:="docker/postgresql/Dockerfile"
POSTGRES_SERVER_IMAGE:="datacollectors/db/postgresql/server:local"
POSTGRES_CLIENT_IMAGE:="datacollectors/db/postgresql/client:local"
POSTGRES_SERVER_CONTAINER:="datacollectors_postgres"
POSTGRES_CLIENT_CONTAINER:="datacollector_postgres_client"

CUR_DIR:=$(shell pwd)


include Makefile.d/db/*.mk
include Makefile.d/docker/*.mk
