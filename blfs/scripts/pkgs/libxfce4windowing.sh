# REVISADO — xfce/libxfce4windowing — libxfce4windowing-4.20.4
set -e
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-x11      \
            --disable-debug   &&
make
make install
