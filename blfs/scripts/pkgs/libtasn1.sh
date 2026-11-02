# REVISADO — general/libtasn1 — libtasn1-4.20.0
set -e
./configure --prefix=/usr --disable-static &&
make
make install
