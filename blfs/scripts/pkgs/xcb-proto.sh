# REVISADO — x/xcb-proto — xcb-proto-1.17.0
set -e
PYTHON=python3 ./configure $XORG_CONFIG
make install
rm -f $XORG_PREFIX/lib/pkgconfig/xcb-proto.pc
