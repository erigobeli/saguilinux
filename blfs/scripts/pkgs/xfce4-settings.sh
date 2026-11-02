# REVISADO — xfce/xfce4-settings — xfce4-settings-4.20.2
set -e
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install
