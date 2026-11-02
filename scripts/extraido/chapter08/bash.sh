# ---- [userinput]
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.3
# ---- [userinput]
make
# ---- [userinput]
chown -R tester .
# ---- [userinput]
LC_ALL=C.UTF-8 su -s /usr/bin/expect tester << "EOF"
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
# ---- [userinput]
make install
# ---- [userinput]
exec /usr/bin/bash --login
