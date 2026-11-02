# ---- [userinput]
./configure --prefix=/usr --localstatedir=/var/lib/locate
# ---- [userinput]
make
# ---- [userinput]
chown -R tester .
su tester -c "PATH=$PATH make check"
# ---- [userinput]
make install
