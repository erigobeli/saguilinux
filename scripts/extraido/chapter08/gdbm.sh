# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
