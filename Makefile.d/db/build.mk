#
#
#
db/build: db/build/server db/build/client
	@echo "$@ build complete"

db/build/server:
	@echo "Build docker postgresql server image: $(POSTGRES_SERVER_IMAGE)"
	@echo "current directory: '$(shell pwd)'"
	@( \
		cd $(CUR_DIR); \
		cd docker/postgresql/; \
		ls -la; \
		docker build --tag $(POSTGRES_SERVER_IMAGE) \
				 --compress \
				 --build-arg DOCKER_BASE_IMAGE=${DOCKER_BASE_IMAGE} \
				 --build-arg POSTGRESQL_VERSION=${POSTGRESQL_VERSION} \
				 --target server \
			     -f Dockerfile . && \
		echo "build complete" \
	)

db/build/client:
	@echo "Build docker postgresql client image: $(POSTGRES_CLIENT_IMAGE)"
	@echo "current directory: '$(shell pwd)'"
	@( \
		cd $(CUR_DIR); \
		cd docker/postgresql/; \
		ls -la; \
		docker build --tag $(POSTGRES_CLIENT_IMAGE) \
				 --compress \
				 --build-arg DOCKER_BASE_IMAGE=${DOCKER_BASE_IMAGE} \
				 --build-arg POSTGRESQL_VERSION=${POSTGRESQL_VERSION} \
				 --target client \
			     -f Dockerfile . && \
	 	echo "build complete" \
 	)
