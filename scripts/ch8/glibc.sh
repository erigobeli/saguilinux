patch -Np1 -i ../glibc-2.42-fhs-1.patch
sed -e '/unistd.h/i #include <string.h>' \
    -e '/libc_rwlock_init/c\
  __libc_rwlock_define_initialized (, reset_lock);\
  memcpy (&lock, &reset_lock, sizeof (lock));' \
    -i stdlib/abort.c
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr                   \
             --disable-werror                \
             --disable-nscd                  \
             libc_cv_slibdir=/usr/lib        \
             --enable-stack-protector=strong \
             --enable-kernel=5.4
make
# Teste crítico (livro: não pular). Falhas conhecidas são toleradas e registradas.
make check || echo "### GLIBC make check retornou erro (ver resumo abaixo)"
echo "### RESUMO-TESTES glibc:"; grep -E '^(FAIL|XPASS|ERROR):' tests.sum || true; tail -15 tests.sum || true
grep "Timed out" $(find -name \*.out) || true
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
rm -f /usr/sbin/nscd
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/*.so.* /usr/lib
DIR=$(dirname $(gcc -print-libgcc-file-name))
[ -e $DIR/include/limits.h ]    || mv $DIR/include{-fixed,}/limits.h
[ -e $DIR/include/syslimits.h ] || mv $DIR/include{-fixed,}/syslimits.h
rm -rfv $DIR/include-fixed/*
unset DIR
make install
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
localedef -i C -f UTF-8 C.UTF-8
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i pt_BR -f ISO-8859-1 pt_BR
localedef -i pt_BR -f UTF-8 pt_BR.UTF-8
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
tar -xf ../../tzdata2025b.tar.gz
ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO tz
ln -sfv /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d
