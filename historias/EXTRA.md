# EXTRA — Script instalar-no-disco (marco opcional do PRD, seção 6)

- **Status:** feito
- **Logs:** logs/extra-*.log, logs/testes/instalar.log, logs/testes/disco-bios.log, logs/testes/disco-uefi.log

## Objetivo
Instalar o sistema do live num disco, a partir do terminal da ISO.

## Uso
```bash
instalar-no-disco /dev/sdX        # pede para digitar SIM
```

## Passos
GPT (BIOS boot 1 MiB, EFI 512 MiB FAT32, raiz ext4) → cópia de `/live/ro` → fstab por UUID → GRUB i386-pc + x86_64-efi (removable) → grub.cfg com `root=PARTUUID`.

## Critério de aceite
Instalação num disco virtio em QEMU e boot do disco em BIOS e em UEFI até o login, com os mesmos comandos do H12: **passou**.
