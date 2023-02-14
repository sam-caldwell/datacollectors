#!/bin/bash -e
#
#
initialize_cluster() {
  export CLUSTER_ID=$(kafka-storage.sh random-uuid)
  echo "${CLUSTER_ID}" >${CLUSTER_ID_FILE}
}

initialize_broker() {
  export BROKER_ID=${RANDOM}
  export BROKER_LOGS=/opt/kafka/data/${BROKER_ID}
  echo "process.roles=broker,controller" \
    "node.id=${BROKER_ID}" \
    "controller.quorum.voters=1@${KAFKA_IP}:9093" \
    "listeners=PLAINTEXT://${KAFKA_LISTENERS}" \
    "inter.broker.listener.name=PLAINTEXT" \
    "controller.listener.names=CONTROLLER" \
    "listener.security.protocol.map=${KAFKA_SECURITY_PROTOCOL_MAP}" \
    "num.network.threads=3" \
    "num.io.threads=8" \
    "socket.send.buffer.bytes=102400" \
    "socket.receive.buffer.bytes=102400" \
    "socket.request.max.bytes=104857600" \
    "log.dirs=${BROKER_LOGS}/0,${BROKER_LOGS}/1,${BROKER_LOGS}/2" \
    "num.partitions=1" \
    "offsets.topic.replication.factor=1" \
    "transaction.state.log.replication.factor=1" \
    "transaction.state.log.min.isr=1" \
    "log.flush.interval.messages=10000" \
    "log.flush.interval.ms=1000" \
    "log.retention.hours=168" \
    "log.retention.bytes=1073741824" \
    "log.segment.bytes=1073741824" \
    "log.retention.check.interval.ms=300000" \
    "num.recovery.threads.per.data.dir=1" >>${CONFIG_FILE}
}

echo "pre-start checks..."

echo "starting broker ${BROKER_ID}"
${KAFKA_ROOT}/bin/kafka-server-start.sh ${KAFKA_ROOT}/config/broker.properties
