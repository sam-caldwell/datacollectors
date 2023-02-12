ARG DOCKER_BASE_IMAGE

FROM ${DOCKER_BASE_IMAGE} AS base
USER root

ENV KAFKA_BASE=kafka_2.13-3.4.0.tgz
ENV KAFKA_URL=https://dlcdn.apache.org/kafka/3.4.0/${KAFKA_BASE}.tgz

RUN apt-get update -y && \
    apt-get install ${APT_INSTALL_ARGS} wget \
                                        openjdk-19-jdk-headless \
                                        tar

WORKDIR /tmp
RUN wget ${KAFKA_URL} && \
    tar -xvzf ${KAFKA_BASE}.tgz && \
    mv ${KAFKA_BASE} /usr/local/ && \
    chown -R service:service /usr/local/${KAFKA_BASE}

FROM base AS zookeeper
USER service
CMD [ "/usr/local/${KAFKA_BASE}/bin/kafka-server-start.sh","/usr/local/${KAFKA_BASE}/config/zookeeper.properties" ]
ENTRYPOINT [ "/usr/local/${KAFKA_BASE}/bin/kafka-server-start.sh","/usr/local/${KAFKA_BASE}/config/zookeeper.properties" ]

FROM base AS broker_service
USER service
RUN export KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)" && \
    /usr/local/${KAFKA_BASE}/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_ID} -c config/kraft/server.properties
CMD [ "/usr/local/${KAFKA_BASE}/bin/kafka-server-start.sh config/server.properties" ]
ENTRYPOINT [ "/usr/local/${KAFKA_BASE}/bin/kafka-server-start.sh config/server.properties" ]