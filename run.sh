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

docker run $ARGS $IMAGE
