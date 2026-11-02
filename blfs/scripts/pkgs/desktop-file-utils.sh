# REVISADO — general/desktop-file-utils — desktop-file-utils-0.28
set -e
rm -fv /usr/bin/desktop-file-edit
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
install -vdm755 /usr/share/applications &&
update-desktop-database /usr/share/applications
