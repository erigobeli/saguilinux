# REVISADO — xfce/xfce4-panel — xfce4-panel-4.20.5
set -e
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install
