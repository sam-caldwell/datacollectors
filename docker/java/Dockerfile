#
# (c) 2023 Sam Caldwell.  See License.txt
#
ARG DOCKER_BASE_IMAGE

FROM ${DOCKER_BASE_IMAGE} AS base
USER root
WORKDIR /tmp

RUN apt-get update -y --fix-missing && \
    apt-get upgrade -y && \
    apt-get ${APT_INSTALL_ARGS} install wget gnupg2

RUN wget -O- https://apt.corretto.aws/corretto.key | apt-key add -
#    apt-key add corretto.key && \
#    rm corretto.key && \
RUN echo 'deb https://apt.corretto.aws stable main' > /etc/apt/sources.list.d/corretto.list

RUN apt-get update -y && \
    apt-get install ${APT_INSTALL_ARGS} java-11-amazon-corretto-jdk

RUN apt-get autoremove -y
