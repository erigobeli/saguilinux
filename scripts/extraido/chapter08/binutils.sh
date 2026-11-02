# ---- [userinput]
mkdir -v build
cd       build
# ---- [userinput]
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu
# ---- [userinput]
make tooldir=/usr
# ---- [userinput]
make -k check
# ---- [userinput]
grep '^FAIL:' $(find -name '*.log')
# ---- [userinput]
make tooldir=/usr install
# ---- [userinput]
rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/
