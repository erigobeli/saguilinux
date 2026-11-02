# ---- [userinput]
sed -i '/install -m.*STA/d' libcap/Makefile
# ---- [userinput]
make prefix=/usr lib=lib
# ---- [userinput]
make test
# ---- [userinput]
make prefix=/usr lib=lib install
