# ---- [userinput]
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.1
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
# ---- [userinput]
rm -v $LFS/usr/lib/liblzma.la
