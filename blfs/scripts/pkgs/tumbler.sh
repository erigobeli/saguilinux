# REVISADO — xfce/tumbler — tumbler-4.20.0
set -e
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install
rm -fv /usr/lib/systemd/user/tumblerd.service
