# REVISADO — general/libxml2 — libxml2-2.14.5
set -e
# DESVIO: sem --with-icu (ICU entra só no B07)
./configure --prefix=/usr --sysconfdir=/etc --disable-static --with-history PYTHON=/usr/bin/python3 --docdir=/usr/share/doc/libxml2-2.14.5
make
make install
rm -vf /usr/lib/libxml2.la
sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config
