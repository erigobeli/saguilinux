# REVISADO — x/at-spi2-core — at-spi2-core-2.56.4
set -e
mkdir build &&
cd    build &&

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D gtk2_atk_adaptor=false \
      -D systemd_user_dir=/tmp  &&
ninja
ninja install &&
rm /tmp/at-spi-dbus-bus.service
