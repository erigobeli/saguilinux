# H11b - ISO híbrida (BIOS i386-pc + UEFI x86_64-efi) com o grub-mkrescue do próprio LFS,
# executado no chroot com xorriso/mtools compilados do fonte em /opt/isotools.
P=/home/erigobeli/distro-ai
S=$P/iso/staging
NOME=semente-linux-1.0-x86_64.iso
cat > $S/boot/grub/grub.cfg << "EOT"
# Semente Linux 1.0 - GRUB da ISO live
set timeout=5
set default=0
if serial --unit=0 --speed=115200; then
  terminal_input --append serial
  terminal_output --append serial
fi
insmod all_video
menuentry "Semente Linux 1.0 (live)" --hotkey=n {
  echo "Carregando o kernel..."
  linux /boot/vmlinuz live.label=SEMENTE_LIVE console=tty0
  echo "Carregando o initramfs..."
  initrd /boot/initrd.img
}
menuentry "Semente Linux 1.0 (live, console serial ttyS0)" --hotkey=s {
  echo "Carregando o kernel..."
  linux /boot/vmlinuz live.label=SEMENTE_LIVE console=tty0 console=ttyS0,115200
  echo "Carregando o initramfs..."
  initrd /boot/initrd.img
}
menuentry "Reiniciar" { reboot }
menuentry "Desligar" { halt }
EOT
mkdir -p $LFS/mnt/iso
mountpoint -q $LFS/mnt/iso || mount --bind $P/iso $LFS/mnt/iso
mountpoint -q $LFS/dev  || mount --bind /dev $LFS/dev
mountpoint -q $LFS/proc || mount -t proc proc $LFS/proc
mountpoint -q $LFS/sys  || mount -t sysfs sysfs $LFS/sys
rc=0
chroot $LFS /usr/bin/env -i HOME=/root PATH=/opt/isotools/bin:/usr/bin:/usr/sbin \
  grub-mkrescue -o /mnt/iso/$NOME /mnt/iso/staging -- -volid SEMENTE_LIVE || rc=$?
umount $LFS/mnt/iso $LFS/sys $LFS/proc $LFS/dev || true
rmdir $LFS/mnt/iso || true
[ $rc = 0 ] || exit $rc
cd $P/iso
sha256sum $NOME > $NOME.sha256
chown erigobeli:erigobeli $NOME $NOME.sha256
ls -lh $NOME; cat $NOME.sha256
xorriso -indev $NOME -report_el_torito plain -report_system_area plain 2>&1 | tail -25
