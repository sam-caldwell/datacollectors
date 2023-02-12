FROM ubuntu:latest AS base

ARG DEFAULT_SHELL="/bin/false"
ENV DEBIAN_FRONTEND=noninteractive
ENV APT_INSTALL_ARGS="-y --no-install-recommends"

RUN apt-get update -y --fix-missing && \
    apt-get upgrade -y && \
    apt-get install ${APT_INSTALL_ARGS} ca-certificates \
                                        apt-transport-https

FROM base AS with_service_user

RUN addgroup --gid 1337 service

RUN adduser --gid 1337 \
            --gid 1337 \
            --home /opt \
            --no-create-home \
            --gecos '' \
            --disabled-password \
            --disabled-login \
            --shell ${DEFAULT_SHELL} service
