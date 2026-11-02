# ---- [userinput]
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
# ---- [userinput]
./configure --prefix=/usr
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
