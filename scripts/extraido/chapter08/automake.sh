# ---- [userinput]
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18.1
# ---- [userinput]
make
# ---- [userinput]
make -j$(($(nproc)>4?$(nproc):4)) check
# ---- [userinput]
make install
