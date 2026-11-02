# REVISADO — basicnet/libevent — libevent-2.1.12
set -e
sed -i 's/python/&3/' event_rpcgen.py
./configure --prefix=/usr --disable-static &&
make
make install
