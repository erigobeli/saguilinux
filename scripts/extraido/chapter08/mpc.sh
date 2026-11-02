# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1
# ---- [userinput]
make
make html
# ---- [userinput]
make check
# ---- [userinput]
make install
make install-html
