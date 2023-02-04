FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV CLUSTER_VERSION=14
ENV CLUSTER_NAME=pgdb
ENV LANGUAGE="en_US:en"
ENV LC_ALL=C.UTF-8
ENV LANG="en_US.UTF-8"


COPY ./src/*.sh /usr/bin/

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        postgresql-${CLUSTER_VERSION} \
        postgresql-common \
        postgresql-contrib \
        postgresql-plpython3-${CLUSTER_VERSION} \
        postgresql-${CLUSTER_VERSION}-cron \
        postgresql-${CLUSTER_VERSION}-pllua \
        postgresql-${CLUSTER_VERSION}-plpgsql-check \
        ca-certificates

RUN echo "listen_addresses=0.0.0.0" >> \
    /etc/postgresql/${CLUSTER_VERSION}/main/conf.d/listen.conf


#RUN chmod a+x /opt/*.sh

VOLUME [ "/var/lib/postgresql/14" ]

EXPOSE 5432

USER 1001

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]

