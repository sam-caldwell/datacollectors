FROM ubuntu:latest AS base

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y postgresql-client-14

VOLUME [ "/opt/" ]
WORKDIR /opt/
