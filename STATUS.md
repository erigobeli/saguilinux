# STATUS — Distro Linux do Zero feita por IA

- **Distro:** Semente Linux 1.0
- **Livro:** LFS 12.4 (SysVinit)
- **Marco atual:** todos concluídos
- **Progresso:** 100.0%
- **Último passo concluído:** H13: Teste em hardware confirmado pelo Eli: Marquina real, ok
- **Próximo passo:** Fase 1 concluída. Fase 2 (BLFS: Xorg + XFCE) aguarda autorização.
- **Bloqueios:** nenhum
- **Atualizado em:** 2026-11-01 23:58:19

## Informações

- **senha_root:** root / semente (troque com 'passwd' após o boot; o live é volátil e volta ao padrão a cada reinício)
- **distro:** Semente Linux 1.0
- **iso:** iso/semente-linux-1.0-x86_64.iso (295 MB) sha256 b42b3ec74d6852c2d9017007ff646c8e1871b63338e0afa70008fc79de52363c
- **extra:** instalar-no-disco /dev/sdX (testado em QEMU: BIOS e UEFI)

## Marcos

| ID | Marco | Peso | Status | Concluído em |
|---|---|---|---|---|
| [H01](historias/H01.md) | Preparar host | 3 | feito | 2026-11-01 15:10:49 |
| [H02](historias/H02.md) | Baixar livro, pacotes e patches; validar checksums | 3 | feito | 2026-11-01 15:16:21 |
| [H03](historias/H03.md) | Preparar $LFS, usuário lfs e ambiente | 2 | feito | 2026-11-01 15:16:57 |
| [H04](historias/H04.md) | Toolchain cruzada (capítulo 5) | 10 | feito | 2026-11-01 15:37:07 |
| [H05](historias/H05.md) | Ferramentas temporárias (capítulo 6) | 10 | feito | 2026-11-01 15:59:10 |
| [H06](historias/H06.md) | Chroot e ferramentas adicionais (capítulo 7) + backup | 6 | feito | 2026-11-01 16:15:23 |
| [H07](historias/H07.md) | Sistema base (capítulo 8) + backup | 30 | feito | 2026-11-01 20:01:50 |
| [H08](historias/H08.md) | Configuração do sistema (capítulo 9) | 4 | feito | 2026-11-01 20:02:49 |
| [H09](historias/H09.md) | Kernel | 8 | feito | 2026-11-01 20:10:08 |
| [H10](historias/H10.md) | Live system: initramfs, squashfs, overlay | 8 | feito | 2026-11-01 22:33:01 |
| [H11](historias/H11.md) | ISO híbrida BIOS + UEFI com GRUB | 6 | feito | 2026-11-01 22:33:01 |
| [H12](historias/H12.md) | Testes automáticos em QEMU (BIOS, UEFI, USB) | 6 | feito | 2026-11-01 22:12:31 |
| [H13](historias/H13.md) | Entrega: ISO, checksum, guia de gravação | 4 | feito | 2026-11-01 23:58:19 |
