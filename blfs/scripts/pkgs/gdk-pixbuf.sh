# REVISADO — x/gdk-pixbuf — gdk-pixbuf-2.42.12
set -e
# DESVIO: sem páginas de manual (rst2man/docutils não instalado)
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D others=enabled -D man=false --wrap-mode=nofallback
ninja
ninja install
gdk-pixbuf-query-loaders --update-cache
