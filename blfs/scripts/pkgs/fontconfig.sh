# REVISADO — general/fontconfig — Fontconfig-2.17.1
set -e
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.17.1 &&
make
make install
