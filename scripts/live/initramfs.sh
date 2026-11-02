# H10a - initramfs mínimo feito só com binários do próprio LFS (bash + util-linux + coreutils).
# Empacotado com gen_init_cpio (fonte do kernel 6.16.1, compilado aqui) porque cpio não faz parte do LFS.
W=/tmp/initramfs
rm -rf $W; mkdir -p $W/usr/{bin,sbin,lib} $W/{dev,proc,sys,run,newroot,etc,mnt/media,mnt/ro,mnt/rw}
ln -s usr/bin $W/bin; ln -s usr/sbin $W/sbin; ln -s usr/lib $W/lib; mkdir -p $W/lib64
BINS="/usr/bin/bash /usr/bin/mount /usr/bin/umount /usr/bin/sleep /usr/bin/mkdir /usr/bin/cat /usr/bin/ls /usr/sbin/switch_root /usr/sbin/blkid"
for b in $BINS; do cp -v $b $W$b; done
ln -s bash $W/usr/bin/sh
for lib in $(for b in $BINS; do ldd $b | grep -o '/[^ ]*'; done | sort -u); do
  real=$(readlink -f $lib); cp -v $real $W/usr/lib/$(basename $lib)
done
ln -sf ../lib/ld-linux-x86-64.so.2 $W/lib64/ld-linux-x86-64.so.2
strip --strip-unneeded $W/usr/bin/* $W/usr/sbin/* $W/usr/lib/* 2>/dev/null || true
cat > $W/init << "EOT"
#!/bin/bash
# /init do initramfs do Semente Linux: acha a mídia pelo label, monta o squashfs,
# monta overlay com camada gravável em tmpfs (RAM) e faz switch_root.
export PATH=/usr/bin:/usr/sbin
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
LABEL=SEMENTE_LIVE
for p in $(cat /proc/cmdline); do case $p in live.label=*) LABEL=${p#live.label=};; esac; done
rescue() { echo "[live] ERRO: $1"; echo "[live] abrindo shell de emergência"; exec bash; }
echo "[live] procurando mídia com label $LABEL ..."
found=
# A mídia é reconhecida pelo arquivo live/<LABEL> + live/rootfs.squashfs.
eh_midia() { [ -f /mnt/media/live/rootfs.squashfs ] && [ -f /mnt/media/live/$LABEL ]; }
for ((i=0; i<60; i++)); do
  # 1) pelo label (CD/DVD, VM)
  for dev in $(blkid -c /dev/null -t LABEL="$LABEL" -o device 2>/dev/null); do
    if mount -o ro $dev /mnt/media 2>/dev/null; then
      eh_midia && { found=$dev; break 2; }
      umount /mnt/media
    fi
  done
  # 2) pendrive gravado em modo DD: a tabela de partições híbrida esconde o label do disco
  #    inteiro no blkid, então tenta montar cada disco/partição como iso9660
  for sys in /sys/class/block/*; do
    dev=/dev/${sys##*/}
    case ${sys##*/} in loop*|ram*|zram*) continue;; esac
    [ -b $dev ] || continue
    if mount -t iso9660 -o ro $dev /mnt/media 2>/dev/null; then
      eh_midia && { found=$dev; break 2; }
      umount /mnt/media
    fi
  done
  sleep 1
done
[ -n "$found" ] || rescue "mídia $LABEL não encontrada"
echo "[live] mídia encontrada em $found"
mount -t squashfs -o ro,loop /mnt/media/live/rootfs.squashfs /mnt/ro || rescue "falha ao montar squashfs"
mount -t tmpfs -o mode=0755 tmpfs /mnt/rw || rescue "falha no tmpfs"
mkdir -p /mnt/rw/upper /mnt/rw/work
mount -t overlay overlay -o lowerdir=/mnt/ro,upperdir=/mnt/rw/upper,workdir=/mnt/rw/work /newroot || rescue "falha no overlay"
mkdir -p /newroot/live/media /newroot/live/ro /newroot/live/rw
mount --move /mnt/media /newroot/live/media
mount --move /mnt/ro /newroot/live/ro
mount --move /mnt/rw /newroot/live/rw
echo "[live] iniciando o sistema (switch_root)"
exec switch_root /newroot /sbin/init
EOT
chmod 755 $W/init
# gen_init_cpio a partir do fonte do kernel
cd /sources; rm -rf /tmp/gic; mkdir /tmp/gic
tar -xf linux-6.16.1.tar.xz -C /tmp/gic linux-6.16.1/usr/gen_init_cpio.c
gcc -O2 -o /tmp/gic/gen_init_cpio /tmp/gic/linux-6.16.1/usr/gen_init_cpio.c
L=/tmp/initramfs.list
{
  cd $W
  find . -mindepth 1 | sort | while read -r p; do
    q=${p#.}
    if [ -L "$p" ]; then echo "slink $q $(readlink "$p") 0777 0 0"
    elif [ -d "$p" ]; then echo "dir $q $(stat -c %a "$p") 0 0"
    else echo "file $q $W$q $(stat -c %a "$p") 0 0"; fi
  done
  echo "nod /dev/console 0600 0 0 c 5 1"
  echo "nod /dev/null 0666 0 0 c 1 3"
} > $L
/tmp/gic/gen_init_cpio $L | gzip -9 > /boot/initrd-semente.img
ls -l /boot/initrd-semente.img
rm -rf /tmp/gic $W $L
