# REVISADO — general/nodejs — Node.js-22.18.0
set -e
./configure --prefix=/usr          \
            --shared-brotli        \
            --shared-cares         \
            --shared-libuv         \
            --shared-openssl       \
            --shared-nghttp2       \
            --shared-zlib          \
            --with-intl=system-icu &&
make
make install &&
ln -sf node /usr/share/doc/node-22.18.0
