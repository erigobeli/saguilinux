# REVISADO — postlfs/polkit — Polkit-126
set -e
groupadd -fg 27 polkitd
id polkitd >/dev/null 2>&1 || useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 -g polkitd -s /bin/false polkitd
# DESVIO: sem elogind -> session_tracking=ConsoleKit (só rastreamento opcional); sem man/testes
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D man=false -D authfw=shadow -D session_tracking=ConsoleKit -D systemdsystemunitdir=/tmp -D tests=false
ninja
ninja install
rm -fv /tmp/*.service
rm -rf /usr/lib/{sysusers,tmpfiles}.d
bootscript polkit 2>/dev/null || true
