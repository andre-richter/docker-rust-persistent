# -*- coding: utf-8 -*-
#
# =============================================================================
#
# Author(s):
#   Andre Richter, <andre.o.richter@gmail.com>
#
# =============================================================================
prefix := andrerichter/
image_name := docker-rust-persistent

baseimage_nightly := rustlang/rust:nightly

all: nightly stable

nightly: Dockerfile
	docker build                                      \
	--build-arg RUSTUP_BASEIMAGE=$(baseimage_nightly) \
	--build-arg IMAGE_NAME=$(image_name):nightly      \
	-t $(prefix)$(image_name):nightly -f Dockerfile .

stable: Dockerfile
	docker build                                     \
	-t $(prefix)$(image_name) -f Dockerfile .
