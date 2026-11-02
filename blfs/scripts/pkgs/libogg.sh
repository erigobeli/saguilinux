# REVISADO — multimedia/libogg — libogg-1.3.6
set -e
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libogg-1.3.6 &&
make
make install
