# ---- [userinput]
make mrproper
# ---- [userinput]
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
