# REVISADO — basicnet/nghttp2 — nghttp2-1.66.0
set -e
./configure --prefix=/usr     \
            --disable-static  \
            --enable-lib-only \
            --docdir=/usr/share/doc/nghttp2-1.66.0 &&
make
make install
