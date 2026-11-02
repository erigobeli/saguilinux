# ---- [userinput]
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
# ---- [userinput]
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF
# ---- [userinput]
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
# ---- [userinput]
make -j32
# ---- [userinput]
export MAKEFLAGS=-j32
# ---- [userinput]
cat >> ~/.bashrc << "EOF"
export MAKEFLAGS=-j$(nproc)
EOF
# ---- [userinput]
source ~/.bash_profile
