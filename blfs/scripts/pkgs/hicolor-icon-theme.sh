# REVISADO — x/hicolor-icon-theme — hicolor-icon-theme-0.18
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
