#
#
#

kafka/clean: kafka/clean/zookeeper \
		  	 kafka/clean/broker
	@echo "kafka cleaned"
