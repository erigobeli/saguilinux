# REVISADO — general/mtdev — mtdev-1.1.7
set -e
./configure --prefix=/usr --disable-static &&
make
make install
