PREFIX ?= $(shell pwd)
build:
	meson setup build/ --buildtype=release -Ddirect=enabled -Dlibc=musl --prefix=${PREFIX}/
	ninja -C build/

install:
	ninja -C build/ install