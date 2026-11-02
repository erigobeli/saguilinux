# ---- [userinput]
mkdir -pv $LFS/{dev,proc,sys,run}
# ---- [userinput]
mount -v --bind /dev $LFS/dev
# ---- [userinput]
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
# ---- [userinput]
if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi
