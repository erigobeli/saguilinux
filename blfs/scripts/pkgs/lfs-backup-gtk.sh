# REVISADO — lfs-backup-gtk
set -e
# Backup do $LFS ao fim da pilha GTK (PRD seção 9)
P=/home/erigobeli/distro-ai
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm || true
umount $LFS/dev/pts 2>/dev/null || true
umount $LFS/{sys,proc,run,dev} 2>/dev/null || true
cd $LFS
tar --exclude=./sources -cpf - . | xz -T0 -3 > $P/backups/lfs-fase2-gtk3.tar.xz
ls -l $P/backups/

# ---------------- B06 XFCE núcleo ----------------
