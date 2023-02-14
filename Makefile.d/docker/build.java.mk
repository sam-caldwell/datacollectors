#
# (c) 2023 Sam Caldwell.  See License.txt
#

docker/build/java:
	@echo "Build docker java image"
	docker build --tag $(DOCKER_JAVA_IMAGE) \
				 --build-arg DOCKER_BASE_IMAGE=$(DOCKER_BASE_IMAGE) \
				 -f $(DOCKER_JAVA_IMAGE_DOCKERFILE) .
