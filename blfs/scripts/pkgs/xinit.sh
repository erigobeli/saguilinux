# REVISADO — x/xinit — xinit-1.4.4
set -e
./configure $XORG_CONFIG --with-xinitdir=/etc/X11/app-defaults &&
make
make install &&
ldconfig
chmod u+s $XORG_PREFIX/bin/Xorg
