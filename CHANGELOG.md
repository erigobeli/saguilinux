# Histórico de versões

## Site 1.0 — 2026-11-02
- Primeira versão do site (HTML + CSS + JS): início, download, como gravar, como foi feito, créditos e avisos.
- Downloads diretos pelas Releases do GitHub; site publicado no GitHub Pages a partir do branch `gh-pages` (conteúdo da pasta `site/`).

## Sagui Linux 2.0 "mico" — 2026-11-02 (tag `v2.0`)
- Desktop **XFCE 4.20** com autologin do usuário `sagui`, sobre **LFS 12.4 + BLFS 12.4**.
- Firefox ESR 140 (sem marca oficial), Thunar, Terminal, Mousepad, Ristretto, PulseAudio.
- Rede cabeada automática (dhcpcd), teclado ABNT2, interface em português.
- Kernel 6.16.1 com DRM para Intel (até Haswell, acelerado), NVIDIA (nouveau) e VMs; logo do Sagui no boot.
- Identidade visual: logo, mascote e wallpaper (Higgsfield); tema com as cores do Brasil; GRUB temático.
- Testado em QEMU (BIOS, UEFI, USB) e em hardware real.
- Limitações: sem Wi-Fi; GPUs AMD e Intel recentes usam renderização por software.

## Edição de terminal 1.0 "fase1" — 2026-11-01 (tag `v1.0`)
- Sistema base do **LFS 12.4** (SysVinit), só linha de comando, lançado com o nome provisório "Semente Linux".
- ISO live híbrida BIOS + UEFI, initramfs próprio, squashfs + overlay em RAM.
- Script `instalar-no-disco` (GPT, GRUB BIOS + UEFI).
- Testado em QEMU (BIOS, UEFI, USB) e em hardware real.
