# Decisões técnicas — Fase 2 (Sagui Linux)

## D01 — Escopo combinado com o Eli (2026-11-02)
Autologin no XFCE (usuário `sagui`), Firefox ESR incluído, base BLFS 12.4 (mesma versão do LFS da Fase 1), arte pelo Higgsfield com poucos créditos. Nome: **Sagui Linux 2.0**.

## D02 — Livro e índice
- BLFS **12.4** SysVinit (`livro/blfs-book-12.4-html.tar.xz`), bootscripts `blfs-bootscripts-20250225`.
- `scripts/blfs-parse.py` lê as 857 páginas e gera `livro/blfs-index.json` (título, URLs, md5, dependências required/recommended/optional, blocos de comandos).
- `scripts/blfs-deps.py` gera `scripts/planos/ordem.txt` seguindo as obrigatórias + recomendadas escolhidas (`recomendadas.txt`), ignorando arestas de alternativas (`ignora-dep.txt`) e páginas excluídas (`exclui.txt`).

## D03 — Por que não seguir todas as "recomendadas"
Seguir obrigatórias + recomendadas de forma transitiva puxa 281 páginas (LibreOffice, GTK4, Qt6, CUPS, TeX…). Foram escolhidas à mão só as recomendadas que importam para um desktop XFCE leve com Firefox (lista em `recomendadas.txt`), resultando em ~118 páginas.

## D04 — Exclusões e alternativas
- `python-modules`/`perl-modules`: páginas agregadoras; só Mako e PyYAML (+libyaml) entram, exigidos pelo Mesa.
- Notificações: `xfce4-notifyd` (o livro lista notification-daemon/lxqt-notificationd como alternativas).
- Ícones: `lxde-icon-theme` + hicolor (Adwaita exige GTK 4).
- Sem Linux-PAM/elogind: Xorg com wrapper suid; desligar/reiniciar do XFCE via polkit (regra para o grupo `wheel`).
- Sem Wayland: GTK 3 só com backend X11.

## D05 — Arte (Higgsfield)
- Modelo Recraft V4.1 (vetor para mascote/logo, 2K para o wallpaper). 5 imagens geradas, ~18 créditos no total (saldo inicial 5797).
- Escolhidos: `arte/mascote-sagui.svg`, `arte/logo-sagui.svg` (2ª tentativa; a 1ª era uma silhueta sem rosto), `arte/wallpaper-sagui.png` (2688×1536). Descartes mantidos com sufixo `-descartado`.

## D06 — Revisão dos comandos e testes
- `scripts/revisao.txt` é a fonte única: por página, os blocos de comando do livro mantidos (`bN`) e/ou comandos ajustados; `scripts/aplicar-revisao.py` gera `scripts/pkgs/*.sh` e os planos `scripts/planos/B03..B08.txt`.
- Suítes de teste não rodam na Fase 2 (nenhuma é marcada como crítica no BLFS; o PRD da Fase 1 pedia testes só nos críticos do LFS). Testes reais acontecem no B12 (boot e desktop em QEMU).
- Documentação/manuais que exigem DocBook/gtk-doc/doxygen foram pulados.

## D07 — Prelúdio do chroot e loop de build
- `scripts/prelude.sh` (inserido em todo passo): `XORG_PREFIX=/usr`, `XORG_CONFIG`, `as_root` (já somos root), `pathappend/pathprepend`, PATH do Rust, `bootscript <nome>` para os bootscripts do BLFS.
- `scripts/rodar-blfs.sh B03 … B08`: roda os planos no tmux (`distro:build`); se a tarball de um passo ainda não baixou, espera 60 s e tenta de novo; qualquer outro erro para com `FAIL` para o loop de correção.
- Monitor: um `until grep -qE '^(OK|FAIL)' logs/estado-build; do sleep 60; done` em segundo plano acorda o agente só quando há resultado.
- Downloads: `scripts/baixar.py` (6 em paralelo, md5 do livro, espelho www.x.org/pub no lugar do lento xorg.freedesktop.org). `scripts/faltando.sh` só copia para `$LFS/sources` arquivos completos (parados há >2 min e íntegros).

## D08 — Gráficos
- Mesa 25.1.8: `-D platforms=x11`, gallium `llvmpipe,softpipe,crocus,i915,nouveau,r300,r600,radeonsi,svga,virgl`, sem Vulkan e sem `video-codecs=all` (o livro alerta sobre patentes ao distribuir). `iris` (Intel Broadwell+) exigiria libclc/SPIRV — essas GPUs usam llvmpipe (software), suficiente para o XFCE.
- Xorg-Server: `-D systemd_logind=false -D suid_wrapper=true` (sem elogind) e `/etc/X11/Xwrapper.config` com `allowed_users=console`.
- Kernel: DRM i915, nouveau, virtio-gpu, bochs, qxl, vmwgfx, cirrus, ast, mgag200, vboxvideo como módulos; **amdgpu/radeon ficam de fora** porque não funcionam sem o pacote linux-firmware (sem firmware eles derrubam o framebuffer e a tela fica preta). Essas máquinas usam simpledrm + modesetting (software).

## D09 — Firefox ESR
- Seguindo o livro, mas **sem `--enable-official-branding`** e sem a chave do Google Location: o próprio livro diz que o binário com marca oficial não pode ser distribuído, e a ISO é distribuída. O navegador aparece com a marca "não oficial" do código-fonte da Mozilla.
- `policies.json`: sem atualizações automáticas e sem telemetria; página inicial local `file:///usr/share/sagui/bemvindo.html`.

## D10 — Sessão e usuário
- Runlevel 5 por padrão: `agetty --autologin sagui` no tty1 → `.bash_profile` roda `startx` → `.xinitrc` com `dbus-launch --exit-with-session startxfce4`. Kernel com `3` ou `sagui.texto` (entrada "modo texto" do GRUB) volta ao login em texto.
- Senhas do live: `root/sagui`, `sagui/sagui`; `sagui` no grupo `wheel` com sudo sem senha; regra polkit dá ao `wheel` permissão para desligar/reiniciar/montar.
- Rede: bootscript `sagui-rede` (dhcpcd em todas as interfaces, em segundo plano).
- `machine-id` removido da imagem (o bootscript do D-Bus gera no boot).

## D11 — Identidade visual aplicada
- Wallpaper: o arquivo padrão do xfdesktop (`/usr/share/backgrounds/xfce/xfce-shapes.svg` e afins) vira link para `wallpaper-sagui.png`, funcionando para qualquer nome de monitor.
- Botão do menu do painel com o ícone `sagui-logo` e título "Sagui"; painel azul (#002776), seleção verde (#009c3b), destaque amarelo (#ffdf00) via `gtk.css`.
- Logo do Sagui como **logo de boot do kernel** (substitui o pinguim do framebuffer, `logo_linux_clut224.ppm` gerado do SVG, 215 cores).
- GRUB com fundo (wallpaper escurecido + logo + nome) e fonte `unicode.pf2`.
- `/etc/issue` com o nome em ASCII colorido.

## D12 — Arte gerada (Higgsfield)
| Arquivo | Modelo | Créditos |
|---|---|---|
| mascote-sagui.svg | Recraft V4.1 vector | 2,5 |
| logo-v1-descartado.svg (silhueta sem rosto) | Recraft V4.1 vector | 2,5 |
| wallpaper-sagui.png (2688×1536) | Recraft V4.1 2K | 8 |
| logo-sagui.svg + logo-v2b-descartado.svg | Recraft V4.1 vector ×2 | 5 |
Total ≈ 18 créditos.

## D13 — Ajustes descobertos nos testes
- Os XMLs padrão do XFCE em `/etc/xdg/xfce4/xfconf/` não podem ser substituídos (o `xfce4-session.xml` define a sessão Failsafe); as preferências do Sagui ficam em `/etc/skel/.config/xfce4/xfconf/` e o xfconf combina as duas (erro E em `docs/erros.md`).
- Firefox sem marca oficial aparece como **"Nightly"** (nome da marca não oficial no código da Mozilla). O aviso de sandbox ("security features may offer less protection") vem do kernel sem user namespaces sem privilégio; o navegador funciona.
- `instalar-no-disco` (Fase 1) continua no sistema, com os nomes atualizados para Sagui.

## D14 — Recomendadas que precisaram entrar depois (lições para a próxima fase)
libXdmcp (Xorg), libxslt (xfce4-dev-tools), nasm antes do libvpx, libtasn1 antes do p11-kit e Python recompilado com SQLite (Firefox). Opções desligadas por falta de dependências opcionais: libpsl (curl), páginas de manual (glib, gdk-pixbuf, xfce4-terminal), vapi (gtksourceview4), PAM (polkit → `authfw=shadow`), Wayland (libxkbcommon, GTK 3).
