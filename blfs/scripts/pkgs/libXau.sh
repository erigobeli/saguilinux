# REVISADO — x/libXau — libXau-1.0.12
set -e
./configure $XORG_CONFIG &&
make
make install
