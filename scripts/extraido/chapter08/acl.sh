# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/acl-2.3.2
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
