# REVISADO — x/xkeyboard-config — XKeyboardConfig-2.45
set -e
mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX --buildtype=release .. &&
ninja
if [ -d $XORG_PREFIX/share/X11/xkb ]; then
  rm -rf $XORG_PREFIX/share/X11/xkb
  rm -f  $XORG_PREFIX/share/man/man7/xkeyboard-config.7
  rm -f  $XORG_PREFIX/share/pkgconfig/xkeyboard-config.pc
fi
ninja install
