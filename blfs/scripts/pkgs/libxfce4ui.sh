# REVISADO — xfce/libxfce4ui — libxfce4ui-4.20.2
set -e
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install
