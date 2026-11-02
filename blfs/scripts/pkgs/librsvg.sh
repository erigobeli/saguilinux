# REVISADO — general/librsvg — librsvg-2.61.0
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
gdk-pixbuf-query-loaders --update-cache
