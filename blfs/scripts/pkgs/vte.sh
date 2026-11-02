# REVISADO — gnome/vte — VTE-0.80.3
set -e
# DESVIO: sem GTK 4, sem GnuTLS, sem vala
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D _systemd=false -D gtk4=false -D gnutls=false -D vapi=false
ninja
ninja install
rm -fv /etc/profile.d/vte.*
