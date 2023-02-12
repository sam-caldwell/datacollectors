#
#
#

kafka/clean/broker: kafka/stop/broker
	@docker rmi -f $(KAFKA_BROKER_IMAGE) &> /dev/null || true
