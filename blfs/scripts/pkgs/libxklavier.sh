# REVISADO — x/libxklavier — libxklavier-5.4
set -e
./configure --prefix=/usr --disable-static &&
make
make install
