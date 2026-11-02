# REVISADO — xfce/thunar — thunar-4.20.4
set -e
sed -i 's/\tinstall-systemd_userDATA/\t/' Makefile.in
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/thunar-4.20.4 &&
make
make install
