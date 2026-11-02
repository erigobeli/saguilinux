# REVISADO — general/libusb — libusb-1.0.29
set -e
./configure --prefix=/usr --disable-static &&
make
make install
