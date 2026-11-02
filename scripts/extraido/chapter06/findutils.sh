# ---- [userinput]
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
