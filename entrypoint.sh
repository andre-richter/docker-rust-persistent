#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# =============================================================================
#
# Author(s):
#   Andre Richter, <andre.o.richter@gmail.com>
#
# =============================================================================

# Default to "rust"
USER_NAME=${DOCKER_USER_NAME:-rust}

# Default to 1000. It's a good default guess for debian/ubuntu systems.
GROUP_ID=${HOST_USER_GID:-1000}
USER_ID=${HOST_USER_UID:-1000}

groupadd --non-unique --gid $GROUP_ID $USER_NAME
useradd --non-unique --create-home --uid $USER_ID --gid $USER_NAME --groups sudo $USER_NAME

echo $USER_NAME ALL=NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME

export HOME=/home/$USER_NAME

# Adapt ownership of rust toolchain
chown -R $USER_ID:$GROUP_ID $RUSTUP_HOME $CARGO_HOME $HOME

exec /usr/local/bin/gosu $USER_NAME "$@"
