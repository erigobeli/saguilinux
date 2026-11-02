#!/bin/bash
# H12 - três testes em QEMU (sem KVM na VPS: TCG). Saídas em logs/testes/.
P=$(cd "$(dirname "$0")/../.." && pwd)
ISO=$P/iso/semente-linux-1.0-x86_64.iso
T=$P/logs/testes; mkdir -p $T
EXP=$P/scripts/testes/boot-test.exp
Q="qemu-system-x86_64 -machine q35 -cpu max -m 2048 -smp 4 -nographic -no-reboot"
cp /usr/share/OVMF/OVMF_VARS_4M.fd $T/ovmf-vars.fd
declare -A CMD=(
 [bios-cdrom]="$Q -cdrom $ISO -boot d"
 [uefi-cdrom]="$Q -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd -drive if=pflash,format=raw,file=$T/ovmf-vars.fd -cdrom $ISO -boot d"
 [bios-usb]="$Q -device qemu-xhci,id=xhci -drive if=none,id=pendrive,format=raw,readonly=on,file=$ISO -device usb-storage,bus=xhci.0,drive=pendrive,bootindex=0"
 [uefi-usb]="$Q -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd -drive if=pflash,format=raw,file=$T/ovmf-vars.fd -device qemu-xhci,id=xhci -drive if=none,id=pendrive,format=raw,readonly=on,file=$ISO -device usb-storage,bus=xhci.0,drive=pendrive,bootindex=0"
)
# Os três primeiros são os exigidos pelo PRD; uefi-usb é um teste extra (pendrive em PC UEFI).
falhas=0
for t in ${@:-bios-cdrom uefi-cdrom bios-usb}; do
  cp /usr/share/OVMF/OVMF_VARS_4M.fd $T/ovmf-vars.fd
  echo "== $t: ${CMD[$t]}" > $T/$t.cmd
  if expect $EXP $t $T/$t.log ${CMD[$t]} > $T/$t.expect-out 2>&1; then echo "PASSOU $t"; else echo "FALHOU $t"; falhas=$((falhas+1)); fi
done
exit $falhas
