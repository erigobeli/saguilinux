# ---- [userinput]
./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            --without-systemd     \
            --without-systemdsystemunitdir        \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41.1
# ---- [userinput]
make
# ---- [userinput]
bash tests/run.sh --srcdir=$PWD --builddir=$PWD
# ---- [userinput]
touch /etc/fstab
chown -R tester .
su tester -c "make -k check"
# ---- [userinput]
make install
