FROM ubuntu:latest AS base

ENV DB_HOST=10.37.129.2
ENV DB_PORT=5432
ENV DB_USER="postgres"
ENV DB_PASS="vitapro"
ENV DB_NAME="postgres"


RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y postgresql-client-14 \
                                               libpq-dev \
                                               python3 \
                                               python3-pip && \
    pip3 install psycopg2

COPY ./src /opt/

VOLUME [ "/opt/" ]
WORKDIR /opt/
CMD [ "/opt/install.sh" ]