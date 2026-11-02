# PRD: Sagui Linux 2.0 — desktop XFCE sobre o LFS (Fase 2)

Documento escrito pelo agente (Claude Code) a partir do pedido do Eli em 2026-11-02, dando continuidade à Fase 1 (`~/distro-ai/PRD.md`, Semente Linux 1.0, LFS 12.4 SysVinit, concluída e validada em hardware real em 2026-11-01).

## 1. Objetivo

Transformar o sistema LFS da Fase 1 numa distribuição com interface gráfica leve, seguindo o livro **BLFS 12.4 (SysVinit)**, e entregar uma nova ISO live híbrida (BIOS + UEFI) que:

1. Dê boot em VM (QEMU/VirtualBox) e em hardware real por pendrive (balenaEtcher, Rufus em modo DD, `dd`).
2. Entre direto (autologin) no desktop **XFCE 4.20** com o usuário `sagui`.
3. Tenha identidade visual própria: nome **Sagui Linux**, mascote sagui, logo e papel de parede com as cores do Brasil.
4. Tenha o navegador **Firefox ESR** e rede automática (DHCP), para o desktop ser usável.

## 2. Decisões já tomadas com o Eli (2026-11-02)

| Tema | Decisão |
|---|---|
| Nome | **Sagui Linux 2.0** (`ID=sagui`), substitui "Semente" |
| Início do modo gráfico | Autologin no XFCE (usuário `sagui`), sem gerenciador de login |
| Navegador | Firefox ESR (aceito o custo de Rust/LLVM/Node.js/NSS no build) |
| Versão do livro | BLFS 12.4, mesma do LFS da Fase 1 |
| Arte | Higgsfield MCP (Recraft V4.1) com no máximo ~5 imagens; SVG próprio como reserva |

## 3. Escopo

### Dentro
- Infraestrutura: certificados (make-ca), DHCP (dhcpcd), D-Bus, sudo, polkit.
- Xorg completo (bibliotecas, Mesa com llvmpipe + drivers de GPU, servidor, xinit, drivers libinput/fbdev), fontes TrueType.
- Pilha GTK 3 (GLib, cairo, pango, gdk-pixbuf, librsvg, at-spi2, GTK 3).
- XFCE: núcleo completo do BLFS (panel, session, settings, desktop, wm, thunar, appfinder, tumbler, notifyd, power manager) e apps (terminal, ristretto, plugin de som).
- Som: alsa-lib + PulseAudio (exigido pelo Firefox).
- Firefox ESR 140.
- Editor de texto (Mousepad, fora do BLFS 12.4, compilado do upstream com gtksourceview4 do BLFS).
- Kernel com drivers DRM para VMs e GPUs comuns (Intel, AMD/Radeon, nouveau, virtio-gpu, bochs, vmware, qxl).
- Tema "Brasil": wallpaper, logo, mascote, cores do painel, menu do GRUB e `/etc/issue`.
- Nova ISO live `sagui-linux-2.0-x86_64.iso` com o mesmo esquema da Fase 1 (initramfs próprio, squashfs, overlay em RAM).

### Fora
- Wayland, GNOME/KDE, tela de login gráfica, gerenciador de pacotes, Secure Boot, Linux-PAM/elogind, LibreOffice, firmware proprietário de rede Wi-Fi.

## 4. Ambiente

- Mesmo host e mesmos princípios da Fase 1 (VPS Ubuntu, 8 núcleos, sem KVM; sudo sem senha; tmux `distro`).
- Projeto: `~/distro-ai/blfs/`. Sistema alvo: o mesmo `$LFS=/mnt/lfs` (o LFS pronto é a base). Backups da Fase 1 em `~/distro-ai/backups/` garantem a volta.
- Build sempre **dentro do chroot** do LFS com o compilador do LFS. Ferramentas do host só empacotam (squashfs/ISO/QEMU).

### Estrutura

```
~/distro-ai/blfs/
  PRD.md  STATUS.md  status.json
  historias/      B01.md ... B13.md
  docs/           diario.md decisoes.md erros.md
  livro/          BLFS 12.4 HTML + blfs-index.json (índice gerado: pacotes, URLs, md5, dependências, comandos)
  sources/        tarballs e patches
  scripts/        blfs-parse.py, blfs-deps.py, build.sh, status.py, pkgs/<pacote>.sh, planos/*.txt, live/, testes/
  arte/           mascote, logo, wallpaper (Higgsfield) e derivados
  logs/           um log por pacote; logs/feito/ marcadores; logs/testes/ (inclui capturas de tela)
  iso/            ISO final, SHA-256, COMO-GRAVAR.md
  dashboard/      index.html (dados embutidos) + status.json
```

## 5. Marcos (histórias)

| ID | Marco | Peso |
|---|---|---|
| B01 | Planejamento: PRD, estrutura, livro BLFS, índice de dependências, renomear para Sagui | 3 |
| B02 | Identidade visual: mascote, logo e wallpaper (Higgsfield) + derivados (ícones, GRUB, issue) | 4 |
| B03 | Base do sistema: make-ca, dhcpcd, sudo, D-Bus, Python modules, CMake, libs gerais | 8 |
| B04 | Xorg: bibliotecas, xcb, libdrm, Mesa (LLVM), servidor, xinit, drivers, fontes | 16 |
| B05 | Pilha GTK 3: GLib, cairo, pango, gdk-pixbuf, librsvg, at-spi2, GTK 3, ícones | 12 |
| B06 | XFCE núcleo | 14 |
| B07 | XFCE apps, som (ALSA/PulseAudio), Mousepad | 6 |
| B08 | Firefox ESR (Rust, Node.js, NSS, ICU…) | 14 |
| B09 | Kernel: DRM/GPU, som, input | 4 |
| B10 | Integração: usuário sagui, autologin, tema Brasil, DHCP, polkit, configs padrão do XFCE | 6 |
| B11 | Live + ISO híbrida (Sagui) | 5 |
| B12 | Testes em QEMU (BIOS, UEFI, USB) com captura de tela do desktop | 5 |
| B13 | Entrega: ISO, SHA-256, guia, teste em hardware pelo Eli | 3 |

Porcentagem = soma dos pesos concluídos + fração dos marcos em andamento.

## 6. Requisitos técnicos

### Seleção de pacotes
- O livro é a referência. `scripts/blfs-parse.py` gera `livro/blfs-index.json`; `scripts/blfs-deps.py` calcula a ordem de build a partir de `scripts/planos/alvos.txt`, seguindo as dependências **obrigatórias** e as **recomendadas escolhidas** em `scripts/planos/recomendadas.txt`, menos `scripts/planos/exclui.txt`. Toda escolha fica justificada em `docs/decisoes.md`.
- Páginas com vários pacotes (bibliotecas Xorg, apps, drivers, módulos Python/Perl) usam a lista do próprio livro, filtrada.
- Desvios do livro só com justificativa.

### Gráficos
- Mesa com `llvmpipe` (renderização por software, funciona em qualquer máquina e VM) e drivers de hardware comuns.
- Xorg usa o driver `modesetting` (embutido) sobre o DRM do kernel; `fbdev` como reserva.
- Xorg sem elogind: wrapper suid do BLFS.

### Live
- Mesmo initramfs/overlay da Fase 1, label `SAGUI_LIVE`.
- Boot em runlevel 5: autologin do usuário `sagui` no tty1 que inicia `startxfce4`; tty2–6 continuam com login em texto; console serial na entrada "serial" do GRUB.
- Senhas documentadas no `STATUS.md`: `root` / `sagui` e `sagui` / `sagui` (sagui no grupo `wheel`, com sudo).
- Rede por DHCP em todas as interfaces cabeadas no boot.

### ISO
- `iso/sagui-linux-2.0-x86_64.iso`, híbrida BIOS + UEFI, menu GRUB com tema Brasil (cores, logo quando suportado), entradas normal, serial e "modo seguro gráfico" (`nomodeset`, fbdev).

## 7. Testes (B12)

Em QEMU (TCG), com a ISO como CD em BIOS, como CD em UEFI e como pendrive USB:
1. Console serial: login root e `uname -a`, `cat /etc/os-release`, `pgrep -a Xorg`, `pgrep -a xfce4-panel`, `firefox --version`.
2. Captura de tela pelo monitor do QEMU (`screendump`) depois do boot, salva em `logs/testes/`, mostrando o desktop XFCE com o wallpaper do Sagui. O agente inspeciona a imagem.
3. Firefox abre uma página local (`file:///`) sem travar (captura de tela).

## 8. Documentação e acompanhamento

Igual à Fase 1: `docs/diario.md`, `docs/erros.md`, `docs/decisoes.md`, `STATUS.md`, `status.json` e `dashboard/index.html` (com dados embutidos), atualizados ao fim de cada passo pelo `scripts/status.py`. O dashboard também mostra a arte do projeto.

## 9. Execução

- Loops iguais aos da Fase 1: execução, monitoramento (verifica `logs/estado-build` a cada 60 s sem ler a saída do `make`), correção (máx. 5 tentativas por pacote), documentação e testes.
- Scripts idempotentes com marcadores em `logs/feito/`.
- Backup tar do `$LFS` ao fim de B05 (pilha gráfica) e de B08 (antes do empacotamento).
- Builds longos (LLVM, Rust, Firefox) rodam no tmux; o agente só confere o resultado.

## 10. Critérios de aceite

1. ISO `sagui-linux-2.0-x86_64.iso` + SHA-256 em `iso/`.
2. Os três testes QEMU passam e as capturas mostram o desktop XFCE com a identidade Sagui.
3. Firefox abre no live.
4. `iso/COMO-GRAVAR.md` atualizado (Sagui, autologin, senhas, dica do balenaEtcher que funcionou no notebook do Eli).
5. Histórias, diário, erros e decisões preenchidos; dashboard em 100% após o teste do Eli em hardware.
