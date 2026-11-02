# REVISADO — gnome/gsettings-desktop-schemas — gsettings-desktop-schemas-48.0
set -e
sed -i -r 's:"(/system):"/org/gnome\1:g' schemas/*.in &&

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install
glib-compile-schemas /usr/share/glib-2.0/schemas
