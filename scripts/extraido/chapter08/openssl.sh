# ---- [userinput]
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
# ---- [userinput]
make
# ---- [userinput]
HARNESS_JOBS=$(nproc) make test
# ---- [userinput]
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
# ---- [userinput]
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.5.2
# ---- [userinput]
cp -vfr doc/* /usr/share/doc/openssl-3.5.2
