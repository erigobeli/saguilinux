# ---- [userinput]
./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
# ---- [userinput]
ln -sv bash $LFS/bin/sh
