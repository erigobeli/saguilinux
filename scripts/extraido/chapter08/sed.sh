# ---- [userinput]
./configure --prefix=/usr
# ---- [userinput]
make
make html
# ---- [userinput]
chown -R tester .
su tester -c "PATH=$PATH make check"
# ---- [userinput]
make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9
