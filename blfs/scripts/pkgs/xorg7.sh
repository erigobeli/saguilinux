# REVISADO — x/xorg7 — Introduction to Xorg-7
set -e
cat > /etc/profile.d/xorg.sh << "EOF"
XORG_PREFIX="/usr"
XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
chmod 644 /etc/profile.d/xorg.sh
install -dm755 /etc/sudoers.d
cat > /etc/sudoers.d/xorg << "EOF"
Defaults env_keep += XORG_PREFIX
Defaults env_keep += XORG_CONFIG
EOF
