# ---- [userinput]
./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.5 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit
# ---- [userinput]
make
# ---- [userinput]
chown -R tester .
su tester -c "PATH=$PATH make check"
# ---- [userinput]
make install
