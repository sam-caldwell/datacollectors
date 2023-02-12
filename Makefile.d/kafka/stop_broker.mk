#
#
#

kafka/stop/broker:
	@docker kill $(KAFKA_BROKER_CONTAINER) &> /dev/null || true
	@docker rm $(KAFKA_BROKER_CONTAINER) &>/dev/null || true
	@echo "kafka broker killed"
