# REVISADO — x/libxcvt — libxcvt-0.1.3
set -e
mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX --buildtype=release .. &&
ninja
ninja install
