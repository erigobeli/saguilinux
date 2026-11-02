# REVISADO — basicnet/c-ares — c-ares-1.34.5
set -e
mkdir build &&
cd    build &&

cmake  -D CMAKE_INSTALL_PREFIX=/usr .. &&
make
make install
