#!/bin/bash
# B12 - testes da ISO do Sagui em QEMU (TCG, sem KVM na VPS). Saídas e capturas em logs/testes/.
P=$(cd "$(dirname "$0")/../.." && pwd)
ISO=$P/iso/sagui-linux-2.0-x86_64.iso
T=$P/logs/testes; mkdir -p $T
EXP=$P/scripts/testes/desktop-test.exp
Q="qemu-system-x86_64 -machine q35 -cpu max -m 3072 -smp 4 -vga std -display none -serial stdio -no-reboot -nic user,model=e1000"
declare -A CMD=(
 [bios-cdrom]="$Q -cdrom $ISO -boot d"
 [uefi-cdrom]="$Q -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd -drive if=pflash,format=raw,file=$T/ovmf-vars.fd -cdrom $ISO -boot d"
 [bios-usb]="$Q -device qemu-xhci,id=xhci -drive if=none,id=pendrive,format=raw,readonly=on,file=$ISO -device usb-storage,bus=xhci.0,drive=pendrive,bootindex=0"
)
falhas=0
for t in ${@:-bios-cdrom uefi-cdrom bios-usb}; do
  cp /usr/share/OVMF/OVMF_VARS_4M.fd $T/ovmf-vars.fd
  S=$T/$t.mon; rm -f $S
  if expect $EXP $t $T $S ${CMD[$t]} -monitor unix:$S,server,nowait > $T/$t.expect-out 2>&1; then r=PASSOU; else r=FALHOU; falhas=$((falhas+1)); fi
  for f in $T/$t-*.ppm; do [ -e "$f" ] && python3 -c "from PIL import Image; Image.open('$f').save('${f%.ppm}.png')" && rm -f "$f"; done
  echo "$r $t"
done
rm -f $T/ovmf-vars.fd $T/*.mon
exit $falhas
