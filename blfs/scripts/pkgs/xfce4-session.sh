# REVISADO — xfce/xfce4-session — xfce4-session-4.20.3
set -e
./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --disable-legacy-sm &&
make
make install
update-desktop-database &&
update-mime-database /usr/share/mime

# ---------------- B07 apps e som ----------------
