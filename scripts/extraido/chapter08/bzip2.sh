# ---- [userinput]
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
# ---- [userinput]
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
# ---- [userinput]
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
# ---- [userinput]
make -f Makefile-libbz2_so
make clean
# ---- [userinput]
make
# ---- [userinput]
make PREFIX=/usr install
# ---- [userinput]
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
# ---- [userinput]
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
# ---- [userinput]
rm -fv /usr/lib/libbz2.a
