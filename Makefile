# -*- coding: utf-8 -*-
#
# =============================================================================
#
# Author(s):
#   Andre Richter, <andre.o.richter@gmail.com>
#
# =============================================================================
prefix := andrerichter/
image_name := rust-persistent
container_user_name := rust

baseimage_stable := rust
baseimage_nightly := rustlang/rust:nightly

all: nightly stable

nightly: Dockerfile
	docker build                                      \
	--build-arg RUSTUP_BASEIMAGE=$(baseimage_nightly) \
	--build-arg IMAGE_NAME=$(image_name):nightly      \
	--build-arg USER_NAME=$(container_user_name)     \
	-t $(prefix)$(image_name):nightly -f Dockerfile .

stable: Dockerfile
	docker build                                     \
	--build-arg RUSTUP_BASEIMAGE=$(baseimage_stable) \
	--build-arg IMAGE_NAME=$(image_name):stable      \
	--build-arg USER_NAME=$(container_user_name)     \
	-t $(prefix)$(image_name):stable -f Dockerfile .
