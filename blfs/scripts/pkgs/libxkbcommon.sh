# REVISADO — general/libxkbcommon — libxkbcommon-1.11.0
set -e
# DESVIO: sem Wayland
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D enable-docs=false -D enable-wayland=false
ninja
ninja install
