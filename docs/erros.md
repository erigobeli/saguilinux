# Erros e ciclos de correção

## E01 — ncurses-6.5-20250809.tgz (H02) — 2026-11-01 15:16:21

- **Sintoma:** `invisible-mirror.net/archives/ncurses/current/ncurses-6.5-20250809.tgz: ERROR 404: Not Found`
- **Causa:** O upstream move o snapshot de 'current/' quando sai um novo; a URL do wget-list ficou obsoleta
- **Correção aplicada:** Baixado do espelho oficial de pacotes LFS ftp.osuosl.org/pub/lfs/lfs-packages/12.4/; md5 confere
- **Tentativas:** 1

## E02 — binutils-pass1 (H04) — 2026-11-01 15:19:05

- **Sintoma:** `tar: binutils-2.45: Cannot mkdir: Permission denied`
- **Causa:** rsync -a em H03 copiou as permissões do diretório sources/ do projeto (775, dono erigobeli) por cima do chmod a+wt de $LFS/sources; o usuário lfs não podia escrever
- **Correção aplicada:** chown root + chmod a+wt em $LFS/sources após o rsync (corrigido também em scripts/H03-preparar.sh)
- **Tentativas:** 1

## E03 — stripping (H07) — 2026-11-01 19:58:28

- **Sintoma:** `strip: /usr/lib/libgcc_s.so: file format not recognized (rc=1)`
- **Causa:** O laço de strip do livro (8.85) passa por arquivos que não são ELF (scripts de linker como libgcc_s.so); o livro diz para ignorar, mas com set -e o primeiro erro aborta o script
- **Correção aplicada:** strip --strip-debug $i 2>/dev/null || true no laço genérico; passo relançado
- **Tentativas:** 1

## E04 — grub-mkrescue (H11) — 2026-11-01 20:16:06

- **Sintoma:** `grub-mkrescue: error: cannot open `/usr/share/grub/unicode.pf2': No such file or directory`
- **Causa:** Com o alvo x86_64-efi o grub-mkrescue renderiza o rótulo de disco (Apple) com a fonte unicode.pf2, que só é gerada se o GRUB for configurado com FreeType + Unifont (não fazem parte do LFS). --fonts= não evita isso.
- **Correção aplicada:** Seguido o BLFS 12.4 (GRUB-2.12 for EFI): FreeType-2.13.3 e Unifont-16.0.04 (md5 conferidos com o BLFS) compilados/instalados no chroot, GRUB EFI recompilado (gera unicode.pf2 e grub-mkfont); squashfs refeito para incluir isso
- **Tentativas:** 2

## E05 — teste QEMU (expect) (H12) — 2026-11-01 20:30:07

- **Sintoma:** `Login timed out after 60 seconds (senha enviada logo após 'Password:')`
- **Causa:** O login(1) descarta a entrada pendente ao desligar o eco; o expect mandou a senha antes disso. Além disso o prompt do root no LFS é '-bash-5.3#', não 'root...#'
- **Correção aplicada:** sleep 2 antes do usuário e da senha; espera por '# ' e define PS1='TESTE# ' para os comandos
- **Tentativas:** 1

## E06 — teste QEMU (expect) (H12) — 2026-11-01 21:41:27

- **Sintoma:** `expect parado após o login, sem casar o prompt nem disparar o timeout`
- **Causa:** No expect, um padrão "# " no início de uma linha dentro de { } é lido como comentário e anula o resto do bloco; além disso, sem KVM o UART emulado às vezes perde caracteres digitados
- **Correção aplicada:** Padrão trocado por -re {bash-[0-9.]+# $}; digitação lenta (send -s) e até 3 tentativas de login
- **Tentativas:** 3

## E07 — teste QEMU (expect) (H12) — 2026-11-01 21:57:31

- **Sintoma:** `expect: does "...Password: ..." match glob pattern " "Password:" {} timeout {...} "? no`
- **Causa:** Correção da causa real: bloco expect { } escrito em uma linha só é tratado como um único padrão literal (inclusive dentro do for), então o teste nunca mandava a senha e o login(1) expirava
- **Correção aplicada:** Script boot-test.exp reescrito com todos os blocos expect multilinha
- **Tentativas:** 4

## E08 — initramfs (/init) (H12) — 2026-11-01 22:02:57

- **Sintoma:** `[live] ERRO: mídia SEMENTE_LIVE não encontrada (teste USB: sda com sda1..sda4)`
- **Causa:** Gravada como disco (pendrive/DD), a ISO híbrida tem tabela GPT/MBR; o blkid passa a ver as partições e não reporta o label iso9660 do disco inteiro
- **Correção aplicada:** /init ganhou um fallback: tenta montar cada /dev/<disco|partição> como iso9660 e reconhece a mídia pelo arquivo live/SEMENTE_LIVE + live/rootfs.squashfs; initramfs, squashfs e ISO refeitos
- **Tentativas:** 1

