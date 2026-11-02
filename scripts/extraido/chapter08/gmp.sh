# ---- [userinput]
ABI=32 ./configure ...
# ---- [userinput]
sed -i '/long long t1;/,+1s/()/(...)/' configure
# ---- [userinput]
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0
# ---- [userinput]
make
make html
# ---- [userinput]
make check 2>&1 | tee gmp-check-log
# ---- [userinput]
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
# ---- [userinput]
make install
make install-html
