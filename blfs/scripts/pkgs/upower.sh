# REVISADO — general/upower — UPower-1.90.9
set -e
mkdir build &&
cd    build &&

meson setup ..                   \
      --prefix=/usr              \
      --buildtype=release        \
      -D gtk-doc=false           \
      -D man=false               \
      -D systemdsystemunitdir=no \
      -D udevrulesdir=/usr/lib/udev/rules.d &&
ninja
ninja install
