# REVISADO — general/libpng — libpng-1.6.50
set -e
# Patch APNG (exigido pelo Firefox com --with-system-png); sem pipe para o erro não passar despercebido
gzip -cd ../libpng-1.6.47-apng.patch.gz > /tmp/libpng-apng.patch
patch -p1 < /tmp/libpng-apng.patch
./configure --prefix=/usr --disable-static &&
make
make install &&
mkdir -v /usr/share/doc/libpng-1.6.50 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.50
