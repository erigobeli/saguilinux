# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.1
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
