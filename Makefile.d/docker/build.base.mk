#
#
#

docker/build/base:
	@echo "Build docker base image"
	docker build --tag $(DOCKER_BASE_IMAGE) -f $(DOCKER_BASE_IMAGE_DOCKERFILE) .
