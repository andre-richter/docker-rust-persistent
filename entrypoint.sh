#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# =============================================================================
#
# Author(s):
#   Andre Richter, <andre.o.richter@gmail.com>
#
# =============================================================================

# Default to 1000. It's a good default guess for debian/ubuntu systems.
GROUP_ID=${HOST_USER_GID:-1000}
USER_ID=${HOST_USER_UID:-1000}

# $USER_NAME is inherited from Dockerfile
groupadd --non-unique --gid $GROUP_ID $USER_NAME
useradd --non-unique -M --uid $USER_ID --gid $USER_NAME --groups sudo $USER_NAME

echo $USER_NAME ALL=NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME

export HOME=/home/$USER_NAME

# Adapt ownership of rust toolchain and home
chown -R $USER_ID:$GROUP_ID $HOME

exec /usr/local/bin/gosu $USER_NAME "$@"
