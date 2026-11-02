# ---- [userinput]
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
