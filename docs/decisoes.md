# Decisões técnicas

## D01 — Versão do livro
- **Decisão:** LFS **12.4** (estável, variante **SysVinit**), publicada em 2025-09-01. É a versão listada em `https://www.linuxfromscratch.org/lfs/downloads/stable/` em 2026-11-01.
- **Arquivos:** `livro/LFS-BOOK-12.4.tar.xz` (HTML por capítulos), `livro/LFS-BOOK-12.4-NOCHUNKS.html`, `livro/wget-list-sysv`, `livro/md5sums`, `livro/lfs-bootscripts-20250827.tar.xz`.

## D02 — /bin/sh do host
- **Decisão:** apontar `/bin/sh` para `bash` no host Ubuntu 24.04 (padrão é `dash`), como exige o capítulo 2.2 do livro.

## D03 — Extração de comandos do livro
- **Decisão:** `scripts/extrair-comandos.py` extrai todos os blocos `<pre class="userinput">` de cada página para `scripts/extraido/<capítulo>/<página>.sh`. Os scripts de build (`scripts/chNN-*.sh`) são montados a partir deles, para não reler o HTML.

## D04 — Estado e dashboard
- **Decisão:** `scripts/status.py` é a única porta de escrita de `status.json`, `STATUS.md`, `docs/diario.md`, `docs/erros.md` e `dashboard/`. O `dashboard/index.html` é regenerado a cada atualização **com os dados embutidos** (funciona aberto como arquivo local, via `file://`, onde o `fetch` do JSON é bloqueado); quando servido por HTTP, ele também tenta ler `status.json` e usa o mais recente.

## D05 — Espelho alternativo para ncurses
- **Decisão:** `ncurses-6.5-20250809.tgz` deu 404 no endereço do `wget-list-sysv`; baixado de `https://ftp.osuosl.org/pub/lfs/lfs-packages/12.4/` (espelho de pacotes do LFS). O md5 confere com o `md5sums` do livro, então é o mesmo arquivo.

## D06 — Driver de build idempotente
- **Decisão:** `scripts/build.sh <plano> <marco>` lê um plano (`scripts/planos/*.txt`, uma linha `id|tarball|snippet|modo` por pacote), gera o script do passo em `$LFS/sources/.run/`, extrai o pacote, roda os comandos do livro (modo `lfs`, `chroot` ou `root`), apaga o diretório de build e grava `logs/<id>.log`. Sucesso cria `logs/feito/<id>`; na retomada esses passos são pulados. O estado vai para `logs/estado-build` (`RUNNING`/`OK`/`FAIL`).
- Scripts `ln -sv` do livro viraram `ln -sfv` para que um passo possa ser refeito sem falhar.

## D07 — Loops de trabalho (seção 9 do PRD)
A sessão do Claude Code não estava em modo `/loop`; os loops foram implementados com as ferramentas disponíveis:
- **Loop principal:** o agente segue marco a marco lendo `STATUS.md`/`status.json`; cada etapa roda via `scripts/rodar-etapa.sh` dentro do tmux `distro` (sobrevive à queda do SSH).
- **Loop de monitoramento de build:** `scripts/esperar-build.sh` (e um `until grep ... ; do sleep 60; done` em segundo plano no Claude Code) só verifica `logs/estado-build` a cada **60 s**, sem ler a saída do `make`; o agente é acordado quando aparece `OK` ou `FAIL`.
- **Loop de correção:** em `FAIL`, ler só o fim do log/`grep error`, corrigir o script, registrar em `docs/erros.md` e relançar (o driver retoma do passo que falhou). Máximo de **5 tentativas** por pacote; depois disso, `bloqueado` e seguir com o que não depende dele.
- **Loop de documentação:** `build.sh` chama `scripts/status.py` ao fim de cada pacote (diário, fração do marco, `status.json`, `STATUS.md`, dashboard).
- **Loop de testes:** a cada ISO nova roda `scripts/testes/rodar-testes.sh` (3 testes QEMU); falha volta ao loop de correção.

## D08 — Testes de pacotes (seção 10 do PRD)
- Rodam só as suítes que o livro trata como críticas: **glibc, binutils e gcc** (cap. 8). Falhas conhecidas não interrompem o build; o resumo vai para o log do pacote (`### RESUMO-TESTES`).
- Puladas (registrado aqui): suítes de todos os outros pacotes do cap. 8 e o `make test` do Python. Comandos interativos removidos: `passwd root` (feito com `chpasswd` no H08), `tzselect` (fuso fixo `America/Sao_Paulo`), `vim -c ':options'`, `exec bash --login`.

## D09 — Hardware genérico
- A VPS é um AMD EPYC 9354P; a ISO precisa rodar em qualquer x86_64. Por isso: **GMP** com `--host=none-linux-gnu` e **libffi** com `--with-gcc-arch=x86-64` (o livro usa `native`), exatamente como o próprio livro indica para gerar binários para outra máquina.
- Locales: só um conjunto reduzido (`C.UTF-8`, `en_US`, `pt_BR`, e alguns usados pelos testes) em vez da lista completa.

## D10 — Identidade da distro
- Nome provisório **Semente Linux 1.0** (`ID=semente`, hostname `semente`, label da ISO `SEMENTE_LIVE`). O PRD diz "a definir": basta trocar em `scripts/ch9/config.sh` e `scripts/live/*.sh`.
- Senha do root: **`semente`** (documentada no `STATUS.md`). Teclado `br-abnt2`; fuso `America/Sao_Paulo`; `LANG=pt_BR.UTF-8` fora do console.

## D11 — Rede no live
- O LFS não tem cliente DHCP (dhcpcd é BLFS, Fase 2). O live sobe só o loopback; `/etc/sysconfig/ifconfig.eth0` fica como modelo estático com `ONBOOT=no`. Os drivers (virtio-net, e1000, e1000e, igb, r8169) estão no kernel.

## D12 — Kernel
- `make menuconfig` (interativo) substituído por `make defconfig` + `scripts/config` + `make olddefconfig`, com verificação automática de que cada opção exigida ficou `=y`. Inclui as opções do livro (cap. 10.3) e as da seção 6 do PRD, além de `BLK_DEV_LOOP` (montar o squashfs) e HID USB (teclados).
- Framebuffer: o livro recomenda `SYSFB_SIMPLEFB` + `DRM_SIMPLEDRM`; `FB_EFI` e `FB_VESA` também foram embutidos como pede o PRD.
- Módulos instalados com `INSTALL_MOD_STRIP=1`.

## D13 — Live boot
- Initramfs feito só com binários do LFS (bash, util-linux, coreutils + bibliotecas via `ldd`), sem busybox, empacotado com `gen_init_cpio` compilado a partir do fonte do kernel (cpio não faz parte do LFS).
- `/init`: monta devtmpfs/proc/sys, procura por até 60 s o dispositivo com label `SEMENTE_LIVE` (`blkid`), monta `live/rootfs.squashfs` via loop, overlay com camada gravável em tmpfs, e faz `switch_root`. Em falha abre um shell de emergência.
- Console serial: `agetty` em `ttyS0` só quando o kernel recebeu `console=ttyS0` (entrada serial do GRUB), para não ficar em respawn em hardware sem porta serial.

## D14 — Empacotamento
- `mksquashfs` (xz, BCJ x86, blocos de 1 MiB) do host, só como ferramenta; exclui `/sources`, `/opt/isotools`, `*.dbg` e conteúdo de `/proc /sys /dev /run /tmp`.
- GRUB: o cap. 8 gera só `i386-pc`; o mesmo `grub-2.12` é compilado de novo com `--with-platform=efi --target=x86_64`.
- `grub-mkrescue` é o do LFS, rodado no chroot. As dependências dele, **xorriso 1.5.6.pl02** e **mtools 4.0.49** (GNU), foram baixadas de ftp.gnu.org (sha256 `786f9f5d…`, `6fe51935…`; assinatura do mtools verificada), compiladas no chroot em `/opt/isotools` e excluídas do squashfs.

## D15 — Pacotes além do livro LFS (todos compilados do fonte no chroot)
| Pacote | Origem | Onde fica | Por quê |
|---|---|---|---|
| FreeType 2.13.3 | BLFS 12.4 (md5 conferido) | /usr | grub-mkfont gera `unicode.pf2`, exigida pelo grub-mkrescue com alvo EFI |
| Unifont 16.0.04 (.pcf) | BLFS 12.4 (md5 conferido) | /usr/share/fonts/unifont | fonte de origem do `unicode.pf2` |
| GRUB 2.12 x86_64-efi | mesmo tarball do livro | /usr/lib/grub/x86_64-efi | boot UEFI (BLFS "GRUB-2.12 for EFI") |
| xorriso 1.5.6.pl02 | ftp.gnu.org | /opt/isotools (fora da ISO) | dependência do grub-mkrescue |
| mtools 4.0.49 | ftp.gnu.org (assinatura ok) | /opt/isotools **e** /usr | grub-mkrescue (efi.img) e `mformat` do instalar-no-disco |

## D16 — Marco extra: instalar-no-disco
- `/usr/sbin/instalar-no-disco /dev/DISCO` (fonte em `scripts/live/instalar-no-disco`): GPT com BIOS boot (1 MiB) + EFI FAT32 (512 MiB, `mformat`) + raiz ext4; copia `/live/ro` (camada somente leitura do live), gera fstab por UUID e instala o GRUB `i386-pc` e `x86_64-efi --removable --no-nvram` (dispensa efibootmgr).
- O sistema instalado não usa initramfs (drivers embutidos), por isso o kernel recebe `root=PARTUUID=... rootwait` (o kernel não entende `root=UUID=` sozinho).
- Testado em QEMU: instalação num disco virtio e boot do disco em BIOS e UEFI.

## D17 — Ponto de partida para a Fase 2
- Estado do sistema: `backups/lfs-temp-tools-12.4.tar.xz` (fim do cap. 7) e `backups/lfs-base-ch8-12.4.tar.xz` (fim do cap. 8); `/mnt/lfs` continua montável/chrootável pelo `scripts/build.sh` (modo `chroot` monta os sistemas virtuais sozinho).
- Para a Fase 2 basta criar novos planos em `scripts/planos/` (pacotes do BLFS) e rodar `scripts/rodar-etapa.sh`; depois `live.txt` + `iso.txt` geram a nova ISO e `scripts/testes/rodar-testes.sh` testa. A Fase 2 **não** foi iniciada (aguarda autorização).

## D18 — ISO final
- `iso/semente-linux-1.0-x86_64.iso` (295 MB), SHA-256 `b42b3ec74d6852c2d9017007ff646c8e1871b63338e0afa70008fc79de52363c`.
