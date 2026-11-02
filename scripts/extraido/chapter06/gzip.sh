# ---- [userinput]
./configure --prefix=/usr --host=$LFS_TGT
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
