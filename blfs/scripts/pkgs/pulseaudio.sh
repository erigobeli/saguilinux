# REVISADO — multimedia/pulseaudio — PulseAudio-17.0
set -e
mkdir build &&
cd    build &&

meson setup --prefix=/usr       \
            --buildtype=release \
            -D database=gdbm    \
            -D doxygen=false    \
            -D bluez5=disabled  \
            -D tests=false      \
            ..                  &&
ninja
ninja install
rm /usr/share/dbus-1/system.d/pulseaudio-system.conf
