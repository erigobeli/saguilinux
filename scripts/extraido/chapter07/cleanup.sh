# ---- [userinput]
rm -rf /usr/share/{info,man,doc}/*
# ---- [userinput]
find /usr/{lib,libexec} -name \*.la -delete
# ---- [userinput]
rm -rf /tools
# ---- [userinput]
exit
# ---- [userinput]
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
# ---- [userinput]
cd $LFS
tar -cJpf $HOME/lfs-temp-tools-12.4.tar.xz .
