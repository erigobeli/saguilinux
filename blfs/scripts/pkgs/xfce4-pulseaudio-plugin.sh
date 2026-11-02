# REVISADO — xfce/xfce4-pulseaudio-plugin — xfce4-pulseaudio-plugin-0.5.1
set -e
mkdir build &&
cd    build &&

meson setup  --prefix=/usr --buildtype=release .. &&
ninja
ninja install
