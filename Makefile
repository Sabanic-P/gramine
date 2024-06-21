build:
	meson setup build/ --buildtype=release -Ddirect=enabled -Dlibc=musl
	ninja -C build/

install:
	ninja -C build/ install