# REVISADO — lfs-backup-firefox
set -e
P=/home/erigobeli/distro-ai
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm || true
umount $LFS/dev/pts 2>/dev/null || true
umount $LFS/{sys,proc,run,dev} 2>/dev/null || true
cd $LFS
tar --exclude=./sources -cpf - . | xz -T0 -3 > $P/backups/lfs-fase2-firefox.tar.xz
ls -l $P/backups/
