# REVISADO — xfce/libwnck — libwnck-43.2
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
