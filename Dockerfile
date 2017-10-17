# -*- coding: utf-8 -*-
#
# =============================================================================
#
# This is a template from:
#   https://www.github.com/andrerichter/docker-volume-permission-template
#
# Author(s):
#   Andre Richter, <andre.o.richter@gmail.com>
#
# =============================================================================
ARG RUSTUP_BASEIMAGE=rust

FROM $RUSTUP_BASEIMAGE

MAINTAINER Andre Richter <andre.o.richter@gmail.com>

ARG IMAGE_NAME=docker-rust-persistent:stable
ENV IMAGE_NAME=$IMAGE_NAME

ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# =============================================================================
#
# Use https://github.com/tianon/gosu to clone uid + gid of the host
# user, so that container-generated files in the mounted volumes have
# host user's permissions.
#
# Code taken from https://github.com/tianon/gosu/blob/master/INSTALL.md
#
# =============================================================================
ENV GOSU_VERSION 1.10
RUN set -ex;                                                                                 \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')";                       \
    wget -O /usr/local/bin/gosu                                                              \
        "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch";     \
    wget -O /usr/local/bin/gosu.asc                                                          \
        "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
                                                                                             \
    # verify the signature
    export GNUPGHOME="$(mktemp -d)";                                                         \
    gpg --keyserver ha.pool.sks-keyservers.net                                               \
        --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4;                                \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu;                        \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc;                                             \
                                                                                             \
    chmod +x /usr/local/bin/gosu;                                                            \
    # verify that the binary works
    gosu nobody true;

# =============================================================================
#
# Additional useful packages
#
# =============================================================================
RUN set -ex;                                                            \
    apt-get update;                                                     \
    apt-get install -q -y --no-install-recommends                       \
        build-essential                                                 \
        sudo                                                            \
        xutils-dev                                                      \
        gdb                                                             \
        ;                                                               \
    apt-get autoremove -q -y;                                           \
    apt-get clean -q -y;                                                \
    rm -rf /var/lib/apt/lists/*

# =============================================================================
#
# Wrapper for non-root login
#
# =============================================================================
COPY entrypoint.sh /usr/local/bin/
COPY .bash_aliases /etc/skel/

ENTRYPOINT ["bash", "entrypoint.sh"]
CMD ["/bin/bash"]
