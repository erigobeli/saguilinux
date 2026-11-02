# ---- [userinput]
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
# ---- [userinput]
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
# ---- [userinput]
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.3
# ---- [userinput]
make SHLIB_LIBS="-lncursesw"
# ---- [userinput]
make install
# ---- [userinput]
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.3
