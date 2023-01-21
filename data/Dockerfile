FROM ubuntu:latest AS base

ENV DB_HOST=10.37.129.2
ENV DB_USER="postgres"
ENV DB_PASS="vitapro"


RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y postgresql-client-14

COPY ../scripts/ /usr/local/

VOLUME [ "/opt/" ]
WORKDIR /opt/
CMD [ "/opt/install.sh" ]