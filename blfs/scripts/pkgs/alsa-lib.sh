# REVISADO — multimedia/alsa-lib — alsa-lib-1.2.14
set -e
sed 's/playmidi1//' -i test/Makefile.am &&
autoreconf -fi
./configure &&
make
make install &&
tar -C /usr/share/alsa --strip-components=1 -xf ../alsa-ucm-conf-1.2.14.tar.bz2
