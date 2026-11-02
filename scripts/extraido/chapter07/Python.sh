# ---- [userinput]
./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython
# ---- [userinput]
make
# ---- [userinput]
make install
