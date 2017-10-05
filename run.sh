#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# =============================================================================
#
# Author(s):
#   Andre Richter, <andre.o.richter@gmail.com>
#
# =============================================================================
PREFIX=andrerichter/
IMAGE_NAME=rust-persistent
RUSTUP_CHANNEL=stable
VOLUME=$PWD

for i in "$@"
do
    case $i in
	-v=*|--volume=*)
            VOLUME="${i#*=}"
	    shift
	    ;;
	-c=*|--channel=*)
            RUSTUP_CHANNEL="${i#*=}"
	    shift
	    ;;
	*)
	    ;;
    esac
done

IMAGE=$PREFIX$IMAGE_NAME:$RUSTUP_CHANNEL
IMAGE_ID=$(docker inspect --format="{{.Id}}" "$IMAGE" | cut -c 8-19)

ARGS="-it --rm                                                            \
      -e HOST_USER_GID=$(id -g)                                           \
      -e HOST_USER_UID=$(id -u)                                           \
      -v $VOLUME:$VOLUME                                                  \
      -w $VOLUME                                                          \
      -v $IMAGE_NAME-$(id -u)-$(id -g)-cargo-$IMAGE_ID:/usr/local/cargo   \
      -v $IMAGE_NAME-$(id -u)-$(id -g)-rustup-$IMAGE_ID:/usr/local/rustup"

# Add security exceptions. Needed by GDB to function properly,
# e.g. disabling ASLR
DIST=`grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}'`
if [ "$DIST" == "Ubuntu" ]; then
    ARGS="$ARGS --security-opt seccomp=unconfined"
fi

# Uncomment to specify the username inside the container. Default is
# "rust".  Do not make it identical with your host username.  This
# would conflict when mounting a path in your home directory into the
# container.
# DOCKER_USER_NAME=rust
# ARGS="$ARGS -e DOCKER_USER_NAME=$DOCKER_USER_NAME"

docker run $ARGS $IMAGE
