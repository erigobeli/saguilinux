# H10b - squashfs (xz) do rootfs do LFS + staging da ISO. Roda como root no host
# (mksquashfs do host é só ferramenta de empacotamento; nenhum binário do host entra no sistema).
P=/home/erigobeli/distro-ai
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm || true
umount $LFS/dev/pts 2>/dev/null || true
umount $LFS/{sys,proc,run,dev} 2>/dev/null || true
for d in dev proc sys run; do mountpoint -q $LFS/$d && { echo "$LFS/$d ainda montado"; exit 1; }; done
S=$P/iso/staging
rm -rf $S; mkdir -p $S/live $S/boot/grub
cp -v $LFS/boot/vmlinuz-6.16.1-semente $S/boot/vmlinuz
cp -v $LFS/boot/initrd-semente.img $S/boot/initrd.img
# arquivo identificador procurado pelo /init do initramfs
echo "Semente Linux 1.0 live" > $S/live/SEMENTE_LIVE
# Exclui: fontes, ferramentas de empacotamento, pontos de montagem virtuais e símbolos de debug (*.dbg)
mksquashfs $LFS $S/live/rootfs.squashfs -comp xz -Xbcj x86 -b 1M -noappend -no-progress \
  -processors $(nproc) -wildcards \
  -e sources opt/isotools 'proc/*' 'sys/*' 'dev/*' 'run/*' 'tmp/*' 'mnt/iso' '... *.dbg' 'root/.bash_history'
ls -lh $S/live/rootfs.squashfs
chown -R erigobeli:erigobeli $S
