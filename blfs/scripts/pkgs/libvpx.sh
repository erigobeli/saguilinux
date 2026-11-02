# REVISADO — multimedia/libvpx — libvpx-1.15.2
set -e
find -type f | xargs touch
sed -i 's/cp -p/cp/' build/make/Makefile &&

mkdir libvpx-build            &&
cd    libvpx-build            &&

../configure --prefix=/usr    \
             --enable-shared  \
             --disable-static &&
make
make install
