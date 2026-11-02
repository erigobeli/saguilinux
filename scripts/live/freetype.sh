# BLFS 12.4 FreeType-2.13.3 (dependência do grub-mkfont, que gera a fonte unicode.pf2 exigida pelo grub-mkrescue EFI)
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h
./configure --prefix=/usr --enable-freetype-config --disable-static
make
make install
