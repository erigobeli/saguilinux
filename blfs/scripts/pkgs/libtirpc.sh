# REVISADO — basicnet/libtirpc — libtirpc-1.3.6
set -e
patch -Np1 -i ../libtirpc-1.3.6-gcc15_fixes-1.patch
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --disable-gssapi  &&
make
make install
