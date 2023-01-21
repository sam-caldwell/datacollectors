FROM ubuntu:latest

USER root
RUN apt-get update -y && apt-get install sudo -y

RUN adduser --quiet --gecos '' --disabled-password ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd -c SHA512

RUN echo 'ubuntu  ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu

USER ubuntu
