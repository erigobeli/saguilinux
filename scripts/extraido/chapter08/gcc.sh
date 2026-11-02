# ---- [userinput]
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
# ---- [userinput]
mkdir -v build
cd       build
# ---- [userinput]
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib
# ---- [userinput]
make
# ---- [userinput]
ulimit -s -H unlimited
# ---- [userinput]
sed -e '/cpython/d' -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
# ---- [userinput]
chown -R tester .
su tester -c "PATH=$PATH make -k check"
# ---- [userinput]
../contrib/test_summary
# ---- [userinput]
make install
# ---- [userinput]
chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/15.2.0/include{,-fixed}
# ---- [userinput]
ln -svr /usr/bin/cpp /usr/lib
# ---- [userinput]
ln -sv gcc.1 /usr/share/man/man1/cc.1
# ---- [userinput]
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/15.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
# ---- [userinput]
echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
# ---- [userinput]
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
# ---- [userinput]
grep -B4 '^ /usr/include' dummy.log
# ---- [userinput]
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
# ---- [userinput]
grep "/lib.*/libc.so.6 " dummy.log
# ---- [userinput]
grep found dummy.log
# ---- [userinput]
rm -v a.out dummy.log
# ---- [userinput]
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
