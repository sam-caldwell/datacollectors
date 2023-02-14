ARG DOCKER_BASE_IMAGE

FROM ${DOCKER_BASE_IMAGE} AS base
USER root

ENV KAFKA_BASE=kafka_2.13-3.4.0.tgz
ENV KAFKA_URL=https://dlcdn.apache.org/kafka/3.4.0/${KAFKA_BASE}.tgz

RUN apt-get update -y && \
    apt-get install ${APT_INSTALL_ARGS} wget \
                                        openjdk-19-jdk-headless \
                                        tar

RUN echo 'export PATH=$PATH:$JAVA_HOME/bin' > /etc/profile.d/01-path.sh
RUN echo 'export JAVA_HOME =$(dirname $(ls -la /etc/alternatives/java | awk '{print \$11}'))' > /etc/profile.d/02-java_home.sh

WORKDIR /tmp
RUN wget ${KAFKA_URL} && \
    tar -xvzf ${KAFKA_BASE}.tgz && \
    mv ${KAFKA_BASE} /usr/local/ && \
    chown -R service:service /usr/local/${KAFKA_BASE}
#
# The zookeeper image
#
FROM base AS zookeeper
USER service
COPY bin/zookeeper_entrypoint.sh /opt/
COPY etc/zookeeper.properties /opt/zookeeper.properties
ENV ZOOKEEPER_CONFIG="/usr/local/${KAFKA_BASE}/config/zookeeper.properties"
CMD [ "/opt/zookeeper_entrypoint.sh" ]
ENTRYPOINT [ "/opt/zookeeper_entrypoint.sh" ]
#
# The kafka broker service
#
FROM base AS broker_service
USER service
COPY bin/broker_entrypoint.sh /opt/
COPY etc/broker.properties /opt/broker.properties
RUN export KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)" && \
    /usr/local/${KAFKA_BASE}/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_ID} -c config/kraft/server.properties
CMD [ "/opt/broker_entrypoint.sh" ]
ENTRYPOINT [ "/opt/broker_entrypoint.sh" ]
