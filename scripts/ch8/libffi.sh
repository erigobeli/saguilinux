# --with-gcc-arch=x86-64 em vez de native: a ISO roda em CPUs diferentes da VPS (AMD EPYC)
./configure --prefix=/usr    \
            --disable-static \
            --with-gcc-arch=x86-64
make
make install
