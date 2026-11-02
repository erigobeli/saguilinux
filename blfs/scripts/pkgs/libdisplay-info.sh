# REVISADO — general/libdisplay-info — libdisplay-info-0.3.0
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
