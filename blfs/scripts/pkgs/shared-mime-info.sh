# REVISADO — general/shared-mime-info — shared-mime-info-2.4
set -e
tar -xf ../xdgmime.tar.xz &&
make -C xdgmime
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release -D update-mimedb=true .. &&
ninja
ninja install
