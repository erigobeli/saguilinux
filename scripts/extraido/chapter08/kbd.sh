# ---- [userinput]
patch -Np1 -i ../kbd-2.8.0-backspace-1.patch
# ---- [userinput]
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
# ---- [userinput]
./configure --prefix=/usr --disable-vlock
# ---- [userinput]
make
# ---- [userinput]
make install
# ---- [userinput]
cp -R -v docs/doc -T /usr/share/doc/kbd-2.8.0
