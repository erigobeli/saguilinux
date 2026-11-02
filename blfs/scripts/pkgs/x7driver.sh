# REVISADO — x/x7driver — Xorg Input Drivers
set -e
# Só os pacotes necessários da página: libevdev, xf86-input-evdev, libinput, xf86-input-libinput
cd /sources
rm -rf libevdev-1.13.4 && tar xf libevdev-1.13.4.tar.xz && cd libevdev-1.13.4
mkdir build && cd build
meson setup .. --prefix=$XORG_PREFIX --buildtype=release -D documentation=disabled -D tests=disabled
ninja && ninja install
cd /sources && rm -rf libevdev-1.13.4
rm -rf xf86-input-evdev-2.11.0 && tar xf xf86-input-evdev-2.11.0.tar.xz && cd xf86-input-evdev-2.11.0
./configure $XORG_CONFIG && make && make install
cd /sources && rm -rf xf86-input-evdev-2.11.0
rm -rf libinput-1.29.0 && tar xf libinput-1.29.0.tar.gz && cd libinput-1.29.0
mkdir build && cd build
meson setup .. --prefix=$XORG_PREFIX --buildtype=release -D debug-gui=false -D tests=false -D libwacom=false -D udev-dir=/usr/lib/udev
ninja && ninja install
cd /sources && rm -rf libinput-1.29.0
rm -rf xf86-input-libinput-1.5.0 && tar xf xf86-input-libinput-1.5.0.tar.xz && cd xf86-input-libinput-1.5.0
./configure $XORG_CONFIG && make && make install
cd /sources && rm -rf xf86-input-libinput-1.5.0
