# REVISADO — general/libuv — libuv-1.51.0
set -e
sh autogen.sh                              &&
./configure --prefix=/usr --disable-static &&
make 
make install
