# REVISADO — general/pixman — Pixman-0.46.4
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
