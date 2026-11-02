# ---- [userinput]
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd
# ---- [userinput]
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
# ---- [userinput]
make FILE_COMPILE=$(pwd)/build/src/file
# ---- [userinput]
make DESTDIR=$LFS install
# ---- [userinput]
rm -v $LFS/usr/lib/libmagic.la
