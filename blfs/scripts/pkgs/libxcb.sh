# REVISADO — x/libxcb — libxcb-1.17.0
set -e
./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.17.0 &&
LC_ALL=en_US.UTF-8 make
make install
chown -Rv root:root $XORG_PREFIX/share/doc/libxcb-1.17.0
