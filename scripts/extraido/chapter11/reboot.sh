# ---- [userinput]
logout
# ---- [userinput]
umount -v $LFS/dev/pts
mountpoint -q $LFS/dev/shm && umount -v $LFS/dev/shm
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys
# ---- [userinput]
umount -v $LFS/home
umount -v $LFS
# ---- [userinput]
umount -v $LFS
