#
#
#

kafka/clean/zookeeper: kafka/stop/zookeeper
	@docker rmi -f $(KAFKA_ZOOKEEPER_IMAGE) &> /dev/null || true
