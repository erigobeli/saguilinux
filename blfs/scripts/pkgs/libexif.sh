# REVISADO — general/libexif — libexif-0.6.25
set -e
./configure --prefix=/usr    \
            --disable-static \
            --with-doc-dir=/usr/share/doc/libexif-0.6.25 &&
make
make install
