# REVISADO — general/harfbuzz — harfBuzz-11.4.1
set -e
# DESVIO: sem graphite2 (não instalado)
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D graphite2=disabled
ninja
ninja install
