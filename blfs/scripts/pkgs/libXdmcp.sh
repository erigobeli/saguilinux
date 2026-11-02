# REVISADO — x/libXdmcp — libXdmcp-1.1.5
set -e
./configure $XORG_CONFIG --docdir=/usr/share/doc/libXdmcp-1.1.5 &&
make
make install
