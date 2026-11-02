./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make
make install
ln -sfv flex   /usr/bin/lex
ln -sfv flex.1 /usr/share/man/man1/lex.1
