# REVISADO — x/xorg-server — Xorg-Server-21.1.18
set -e
patch -Np1 -i ../xorg-server-21.1.18-tearfree_backport-1.patch
# DESVIO: sem elogind -> systemd_logind=false e wrapper suid (o livro descreve essa alternativa)
mkdir build
cd    build
meson setup ..               \
      --prefix=$XORG_PREFIX  \
      --localstatedir=/var   \
      -D glamor=true         \
      -D systemd_logind=false \
      -D suid_wrapper=true   \
      -D xkb_output_dir=/var/lib/xkb
ninja
ninja install
mkdir -pv /etc/X11/xorg.conf.d
install -v -d -m1777 /tmp/.{ICE,X11}-unix
grep -q '.X11-unix' /etc/sysconfig/createfiles || cat >> /etc/sysconfig/createfiles << "EOF"
/tmp/.ICE-unix dir 1777 root root
/tmp/.X11-unix dir 1777 root root
EOF
