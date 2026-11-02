# REVISADO — xfce/ristretto — ristretto-0.13.4
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
