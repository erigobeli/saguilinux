# B11a - squashfs (xz) do rootfs do Sagui + staging da ISO. Roda como root no host
# (mksquashfs do host é só ferramenta de empacotamento; nenhum binário do host entra no sistema).
P=/home/erigobeli/distro-ai/blfs
mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm || true
umount $LFS/dev/pts 2>/dev/null || true
umount $LFS/{sys,proc,run,dev} 2>/dev/null || true
for d in dev proc sys run; do mountpoint -q $LFS/$d && { echo "$LFS/$d ainda montado"; exit 1; }; done
S=$P/iso/staging
rm -rf $S; mkdir -p $S/live $S/boot/grub
cp -v $LFS/boot/vmlinuz-6.16.1-sagui $S/boot/vmlinuz
cp -v $LFS/boot/initrd-sagui.img $S/boot/initrd.img
echo "Sagui Linux 2.0 live" > $S/live/SAGUI_LIVE
# Exclui: fontes, ferramentas só de build (Rust/cargo, caches de build), pontos de montagem virtuais e *.dbg
mksquashfs $LFS $S/live/rootfs.squashfs -comp xz -Xbcj x86 -b 1M -noappend -no-progress \
  -processors $(nproc) -wildcards \
  -e sources opt/isotools 'opt/rustc*' 'proc/*' 'sys/*' 'dev/*' 'run/*' 'tmp/*' 'mnt/iso' '... *.dbg' \
     'root/.bash_history' 'root/.cargo' 'root/.cache' 'root/.mozbuild' 'var/cache/*'
ls -lh $S/live/rootfs.squashfs
chown -R erigobeli:erigobeli $S
