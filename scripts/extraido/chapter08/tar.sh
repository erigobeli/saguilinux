# ---- [userinput]
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35
