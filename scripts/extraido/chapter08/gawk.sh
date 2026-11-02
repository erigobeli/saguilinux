# ---- [userinput]
sed -i 's/extras//' Makefile.in
# ---- [userinput]
./configure --prefix=/usr
# ---- [userinput]
make
# ---- [userinput]
chown -R tester .
su tester -c "PATH=$PATH make check"
# ---- [userinput]
rm -f /usr/bin/gawk-5.3.2
make install
# ---- [userinput]
ln -sv gawk.1 /usr/share/man/man1/awk.1
# ---- [userinput]
install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.2
