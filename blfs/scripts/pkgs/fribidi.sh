# REVISADO — general/fribidi — FriBidi-1.0.16
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
