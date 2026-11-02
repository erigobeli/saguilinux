# REVISADO — xfce/xfce4-power-manager — xfce4-power-manager-4.20.0
set -e
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install
