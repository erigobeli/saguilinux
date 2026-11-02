# REVISADO — x/libepoxy — libepoxy-1.5.10
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
