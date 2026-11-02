# ---- [userinput]
sed '6031s/$add_dir//' -i ltmain.sh
# ---- [userinput]
mkdir -v build
cd       build
# ---- [userinput]
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
# ---- [userinput]
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
