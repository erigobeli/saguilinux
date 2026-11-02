# REVISADO — xfce/xfce4-notifyd — xfce4-notifyd-0.9.7
set -e
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-systemd &&
make
make install
