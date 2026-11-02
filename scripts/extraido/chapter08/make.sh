# ---- [userinput]
./configure --prefix=/usr
# ---- [userinput]
make
# ---- [userinput]
chown -R tester .
su tester -c "PATH=$PATH make check"
# ---- [userinput]
make install
