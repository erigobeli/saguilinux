#!/bin/bash
# H03: prepara $LFS (sem partição dedicada), usuário lfs e ambiente (cap. 4). Idempotente.
set -eu
export LFS=/mnt/lfs
sudo mkdir -pv $LFS
sudo chown root:root $LFS; sudo chmod 755 $LFS
sudo mkdir -pv $LFS/sources; sudo chmod -v a+wt $LFS/sources
sudo rsync -a --exclude md5sums "$(dirname "$0")/../sources/" $LFS/sources/
sudo cp "$(dirname "$0")/../sources/md5sums" $LFS/sources/
sudo chown -R root:root $LFS/sources; sudo chmod a+wt $LFS/sources; sudo chmod 1777 $LFS/sources/.run 2>/dev/null || true
sudo mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do [ -L $LFS/$i ] || sudo ln -sv usr/$i $LFS/$i; done
sudo mkdir -pv $LFS/lib64 $LFS/tools
getent group lfs >/dev/null || sudo groupadd lfs
id lfs >/dev/null 2>&1 || sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs
sudo chown -v lfs $LFS/{usr{,/*},var,etc,tools} $LFS/lib64
sudo tee /home/lfs/.bash_profile >/dev/null << "EOP"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOP
sudo tee /home/lfs/.bashrc >/dev/null << "EOP"
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
export MAKEFLAGS=-j$(nproc)
EOP
sudo chown lfs:lfs /home/lfs/.bash_profile /home/lfs/.bashrc
[ ! -e /etc/bash.bashrc ] || sudo mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
sudo -u lfs env -i HOME=/home/lfs TERM=xterm bash -c 'source ~/.bashrc; echo "LFS=$LFS LFS_TGT=$LFS_TGT PATH=$PATH MAKEFLAGS=$MAKEFLAGS"; ls -ld $LFS/tools'
