# Backup do estado ao fim do cap. 7 (livro 7.13.2). Exclui ./sources (cópia já existe em ~/distro-ai/sources).
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm || true
umount $LFS/dev/pts || true
umount $LFS/{sys,proc,run,dev} || true
mkdir -p /home/erigobeli/distro-ai/backups
cd $LFS
tar --exclude=./sources -cpf - . | xz -T0 -6 > /home/erigobeli/distro-ai/backups/lfs-temp-tools-12.4.tar.xz
ls -l /home/erigobeli/distro-ai/backups/
