# REVISADO — xfce/garcon — Garcon-4.20.0
set -e
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install
