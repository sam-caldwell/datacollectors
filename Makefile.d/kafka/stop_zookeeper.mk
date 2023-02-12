#
#
#

kafka/stop/zookeeper:
	@docker kill $(KAFKA_ZOOKEEPER_CONTAINER) &> /dev/null || true
	@docker rm $(KAFKA_ZOOKEEPER_CONTAINER) &>/dev/null || true
	@echo "kafka zookeeper stopped"
