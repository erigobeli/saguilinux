# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --with-gcc-arch=native
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
