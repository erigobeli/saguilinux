# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.7.1
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
# ---- [userinput]
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.1
