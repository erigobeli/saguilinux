# ---- [userinput]
sed -i "s/echo/#echo/" src/egrep.sh
# ---- [userinput]
./configure --prefix=/usr
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
