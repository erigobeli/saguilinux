# ---- [userinput]
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
