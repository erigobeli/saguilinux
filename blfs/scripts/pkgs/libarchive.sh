# REVISADO — general/libarchive — libarchive-3.8.1
set -e
./configure --prefix=/usr --disable-static &&
make
make install
ln -sfv bsdunzip /usr/bin/unzip
