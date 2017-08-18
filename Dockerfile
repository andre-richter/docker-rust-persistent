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
FROM ubuntu:16.04

MAINTAINER Andre Richter <andre.o.richter@gmail.com>

ARG RUSTUP_CHANNEL

ARG IMAGE_NAME
ENV IMAGE_NAME=$IMAGE_NAME

ARG USER_NAME
ENV USER_NAME=$USER_NAME

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
                                                                                             \
    fetchDeps='                                                                              \
        ca-certificates                                                                      \
        wget                                                                                 \
    ';                                                                                       \
    apt-get update;                                                                          \
    apt-get install -y --no-install-recommends $fetchDeps;                                   \
    rm -rf /var/lib/apt/lists/*;                                                             \
                                                                                             \
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
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc;                                              \
                                                                                             \
    chmod +x /usr/local/bin/gosu;                                                            \
    # verify that the binary works
    gosu nobody true;                                                                        \
                                                                                             \
    apt-get purge -y --auto-remove $fetchDeps

# =============================================================================
#
# Rust toolchain
#
# =============================================================================
RUN set -ex;                                                            \
    USER_HOME=/home/$USER_NAME;                                         \
    apt-get update;                                                     \
    apt-get install -q -y --no-install-recommends                       \
        autoconf                                                        \
        automake                                                        \
        autotools-dev                                                   \
        build-essential                                                 \
        ca-certificates                                                 \
        curl                                                            \
        file                                                            \
        libtool                                                         \
        sudo                                                            \
        xutils-dev                                                      \
        ;                                                               \
    curl https://sh.rustup.rs -sSf | sh -s --                           \
        --default-toolchain $RUSTUP_CHANNEL -y --no-modify-path;        \
    mkdir -p $USER_HOME;                                                \
    cp -R /etc/skel/. $USER_HOME;                                       \
    mv /root/.cargo $USER_HOME;                                         \
    mv /root/.rustup $USER_HOME;                                        \
    ln -s $USER_HOME/.rustup $USER_HOME/.multirust;                     \
    apt-get purge -y --auto-remove curl;                                \
    apt-get clean -q -y;                                                \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/home/$USER_NAME/.cargo/bin:$PATH

# =============================================================================
#
# Wrapper for non-root login
#
# =============================================================================
COPY entrypoint.sh /usr/local/bin/
COPY .bash_aliases /home/$USER_NAME/

ENTRYPOINT ["bash", "entrypoint.sh"]
CMD ["/bin/bash"]
