# B11b - ISO híbrida (BIOS + UEFI) do Sagui com o grub-mkrescue do próprio LFS (no chroot).
P=/home/erigobeli/distro-ai/blfs
S=$P/iso/staging
NOME=sagui-linux-2.0-x86_64.iso
cp -v $P/arte/grub-fundo.png $S/boot/grub/fundo.png
cp -v $LFS/usr/share/grub/unicode.pf2 $S/boot/grub/unicode.pf2
cat > $S/boot/grub/grub.cfg << "EOT"
# Sagui Linux 2.0 - GRUB da ISO live
set timeout=8
set default=0
if serial --unit=0 --speed=115200; then
  terminal_input --append serial
  terminal_output --append serial
fi
insmod all_video
insmod png
insmod gfxterm
if loadfont /boot/grub/unicode.pf2; then
  set gfxmode=auto
  terminal_output --append gfxterm
  terminal_output --remove console
  background_image /boot/grub/fundo.png
  set color_normal=white/black
  set menu_color_normal=white/black
  set menu_color_highlight=black/yellow
fi
menuentry "Sagui Linux 2.0 (XFCE)" --hotkey=n {
  linux /boot/vmlinuz live.label=SAGUI_LIVE quiet loglevel=3 console=tty0
  initrd /boot/initrd.img
}
menuentry "Sagui Linux 2.0 (XFCE, console serial ttyS0)" --hotkey=s {
  linux /boot/vmlinuz live.label=SAGUI_LIVE console=tty0 console=ttyS0,115200
  initrd /boot/initrd.img
}
menuentry "Sagui Linux 2.0 (modo seguro de vídeo)" --hotkey=v {
  linux /boot/vmlinuz live.label=SAGUI_LIVE nomodeset console=tty0
  initrd /boot/initrd.img
}
menuentry "Sagui Linux 2.0 (modo texto)" --hotkey=t {
  linux /boot/vmlinuz live.label=SAGUI_LIVE sagui.texto 3 console=tty0
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
  grub-mkrescue -o /mnt/iso/$NOME /mnt/iso/staging -- -volid SAGUI_LIVE || rc=$?
umount $LFS/mnt/iso $LFS/sys $LFS/proc $LFS/dev || true
rmdir $LFS/mnt/iso || true
[ $rc = 0 ] || exit $rc
cd $P/iso
sha256sum $NOME > $NOME.sha256
chown erigobeli:erigobeli $NOME $NOME.sha256
ls -lh $NOME; cat $NOME.sha256
