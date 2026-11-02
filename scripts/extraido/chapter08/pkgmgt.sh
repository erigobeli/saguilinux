# ---- [userinput]
grep -l 'libfoo.*deleted' /proc/*/maps | tr -cd 0-9\\n | xargs -r ps u
# ---- [userinput]
./configure --prefix=/usr/pkg/libfoo/1.1
make
make install
# ---- [userinput]
./configure --prefix=/usr
make
make DESTDIR=/usr/pkg/libfoo/1.1 install
