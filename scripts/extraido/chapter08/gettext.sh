# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.26
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
