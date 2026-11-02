# REVISADO — x/pango — Pango-1.56.4
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr            \
            --buildtype=release      \
            --wrap-mode=nofallback   \
            -D introspection=enabled \
            ..                       &&
ninja
ninja install
