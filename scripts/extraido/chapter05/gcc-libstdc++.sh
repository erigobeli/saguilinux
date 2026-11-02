# ---- [userinput]
mkdir -v build
cd       build
# ---- [userinput]
../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
# ---- [userinput]
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
