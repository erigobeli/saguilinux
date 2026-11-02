# Backup do $LFS ao fim do H07 (sistema base completo). Exclui ./sources.
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm || true
umount $LFS/dev/pts || true
umount $LFS/{sys,proc,run,dev} || true
mkdir -p /home/erigobeli/distro-ai/backups
cd $LFS
tar --exclude=./sources -cpf - . | xz -T0 -6 > /home/erigobeli/distro-ai/backups/lfs-base-ch8-12.4.tar.xz
ls -l /home/erigobeli/distro-ai/backups/
