sed -i '/long long t1;/,+1s/()/(...)/' configure
# --host=none-linux-gnu: biblioteca genérica (não otimizada para a CPU da VPS), pois a ISO roda em outro hardware
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --host=none-linux-gnu \
            --docdir=/usr/share/doc/gmp-6.3.0
make
make html
make install
make install-html
