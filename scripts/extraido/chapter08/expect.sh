# ---- [userinput]
python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
# ---- [userinput]
patch -Np1 -i ../expect-5.45.4-gcc15-1.patch
# ---- [userinput]
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
# ---- [userinput]
make
# ---- [userinput]
make test
# ---- [userinput]
make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
