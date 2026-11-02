# ---- [userinput]
./configure --prefix=/usr        \
            --disable-debuginfod \
            --enable-libdebuginfod=dummy
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a
