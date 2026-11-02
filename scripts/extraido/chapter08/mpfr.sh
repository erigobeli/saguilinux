# ---- [userinput]
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.2
# ---- [userinput]
make
make html
# ---- [userinput]
make check
# ---- [userinput]
make install
make install-html
