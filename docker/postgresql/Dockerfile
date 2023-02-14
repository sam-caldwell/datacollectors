ARG DOCKER_BASE_IMAGE

FROM ${DOCKER_BASE_IMAGE} AS base

ARG POSTGRESQL_VERSION=14

ENV DEBIAN_FRONTEND=noninteractive
ENV POSTGRESQL_DB_PORT=5432

USER root

RUN apt-get update -y && \
    apt-get install ${APT_INSTALL_ARGS} postgresql-${POSTGRESQL_VERSION} && \
    pg_dropcluster 14 main

#
# Configure postgresql as a server
#
FROM base AS server

RUN apt-get install ${APT_INSTALL_ARGS} postgresql-${POSTGRESQL_VERSION}-plpgsql-check \
                                        postgresql-${POSTGRESQL_VERSION}-pllua \
                                        postgresql-${POSTGRESQL_VERSION}-semver

COPY bin/server_entrypoint.sh /opt/

RUN chmod +x /opt/server_entrypoint.sh && \
    chown postgres: /opt/server_entrypoint.sh

USER postgres

ENTRYPOINT [ "/opt/server_entrypoint.sh" ]
CMD [ "/opt/server_entrypoint.sh" ]

#
# Configure postgresql as a client
#
FROM base AS client
USER root

ARG POSTGRESQL_VERSION=14

COPY bin/client_entrypoint.sh /opt/
COPY bin/client_requirements.txt /opt/

RUN apt-get install ${APT_INSTALL_ARGS} python3 \
                                        python3-pip \
                                        libpq-dev

RUN pip3 install -r /opt/client_requirements.txt

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENTRYPOINT [ "/opt/client_entrypoint.sh" ]
CMD [ "/opt/client_entrypoint.sh" ]

USER postgres

