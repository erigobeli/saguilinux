# REVISADO — basicnet/curl — cURL-8.15.0
set -e
# DESVIO: sem libpsl (recomendada não instalada)
./configure --prefix=/usr --disable-static --with-openssl --without-libpsl --with-ca-path=/etc/ssl/certs
make
make install
