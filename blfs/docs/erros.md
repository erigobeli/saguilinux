# Erros e ciclos de correção

## E01 — p11-kit / make-ca (B03) — 2026-11-02 01:06:10

- **Sintoma:** `/usr/sbin/make-ca: line 980: /usr/bin/trust: No such file or directory ... Failed!!! (e o passo terminou com código 0)`
- **Causa:** A ordem calculada colocou o p11-kit antes da libtasn1 (a libtasn1 é 'recomendada' do p11-kit, e sem ela o p11-kit não gera o módulo trust); o make-ca não propaga a falha no código de saída
- **Correção aplicada:** libtasn1 movida para antes do p11-kit em revisao.txt; p11-kit recompilado e make-ca -g --force: 507 certificados e ca-bundle.crt gerados
- **Tentativas:** 1

## E02 — dbus (B03) — 2026-11-02 01:06:59

- **Sintoma:** `xz: (stdin): Unexpected end of input / tar: Unexpected EOF in archive`
- **Causa:** O sincronizador copiou para $LFS/sources uma tarball que ainda estava sendo baixada (sobrescrevendo a cópia completa da Fase 1)
- **Correção aplicada:** faltando.sh só copia arquivos parados há >2 min e que passam no teste de integridade (xz/gzip/bzip2 -t); dbus restaurado
- **Tentativas:** 1

## E03 — cmake (B03) — 2026-11-02 01:11:34

- **Sintoma:** `CMAKE_USE_SYSTEM_CURL is ON but a curl is not found!`
- **Causa:** --system-libs do livro supõe as recomendadas curl, libarchive, libuv e nghttp2 já instaladas
- **Correção aplicada:** bootstrap sem --system-libs (bibliotecas embutidas do CMake)
- **Tentativas:** 1

## E04 — libxml2 (B03) — 2026-11-02 01:20:22

- **Sintoma:** `make: *** No rule to make target 'install'.`
- **Causa:** Erro na revisão: os blocos de instalação do livro (b3 b4) ficaram antes do configure ajustado
- **Correção aplicada:** Entrada da libxml2 só com os comandos ajustados; conferidas as demais entradas que misturam blocos e texto
- **Tentativas:** 1

## E05 — libpng (B03) — 2026-11-02 01:34:22

- **Sintoma:** `gzip: ../libpng-1.6.47-apng.patch.gz: No such file or directory (build seguiu sem o patch)`
- **Causa:** O baixar.py só reconhecia URLs terminadas em .patch (este é .patch.gz) e o 'gzip -cd | patch' do livro não falha com set -e (pipe)
- **Correção aplicada:** Patch baixado (extras-download.txt); script sem pipe; libpng recompilada com APNG (png_get_next_frame_fcTL presente), necessária para o Firefox
- **Tentativas:** 1

## E06 — mesa (B04) — 2026-11-02 01:34:23

- **Sintoma:** `mesa-25.1.8.tar.xz em $LFS/sources com 791907 bytes (parcial)`
- **Causa:** Cópia feita pela 1ª versão do sincronizador enquanto o download ainda corria
- **Correção aplicada:** Comparação de tamanho de todas as tarballs; a parcial foi apagada e o loop espera a cópia completa
- **Tentativas:** 1

## E07 — xorg-server (B04) — 2026-11-02 02:38:57

- **Sintoma:** `ERROR: Dependency "xdmcp" not found`
- **Causa:** libXdmcp é só 'recomendada' (libxcb) no livro e não entrou no fecho de obrigatórias, mas o Xorg-Server a exige
- **Correção aplicada:** libXdmcp-1.1.5 (md5 ok) adicionada ao B04 antes do servidor
- **Tentativas:** 1

## E08 — curl (B05) — 2026-11-02 02:44:37

- **Sintoma:** `configure: error: libpsl libs and/or directories were not found`
- **Causa:** libpsl é recomendada do curl e não foi incluída
- **Correção aplicada:** --without-libpsl
- **Tentativas:** 1

## E09 — gdk-pixbuf (B05) — 2026-11-02 03:32:57

- **Sintoma:** `ERROR: No rst2man found, but man pages were explicitly enabled`
- **Causa:** Páginas de manual exigem docutils (opcional)
- **Correção aplicada:** -D man=false
- **Tentativas:** 1

## E10 — xfce4-dev-tools (B06) — 2026-11-02 03:45:45

- **Sintoma:** `configure: error: package 'xsltproc' missing`
- **Causa:** libxslt não estava no fecho (é só recomendada para glib/gtk3/polkit), mas o xfce4-dev-tools exige xsltproc
- **Correção aplicada:** libxslt-1.1.43 (md5 ok) adicionada antes do xfce4-dev-tools
- **Tentativas:** 1

## E11 — polkit (B06) — 2026-11-02 03:50:30

- **Sintoma:** `ERROR: C shared or static library 'pam' not found`
- **Causa:** polkit usa Linux-PAM por padrão (fora do escopo)
- **Correção aplicada:** -D authfw=shadow (autenticação via /etc/shadow, suportada pelo polkit)
- **Tentativas:** 1

## E12 — xfce4-terminal (B07) — 2026-11-02 03:58:31

- **Sintoma:** `failed to load "http://docbook.sourceforge.net/.../docbook.xsl"`
- **Causa:** A página de manual exige DocBook-XSL (não instalado)
- **Correção aplicada:** subdir('doc') removido do meson.build
- **Tentativas:** 1

## E13 — gtksourceview4 (B07) — 2026-11-02 04:01:16

- **Sintoma:** `ERROR: Dependency "vapigen" not found`
- **Causa:** vapi habilitado por padrão; vala não instalado
- **Correção aplicada:** -D vapi=false
- **Tentativas:** 1

## E14 — libvpx (B08) — 2026-11-02 04:47:06

- **Sintoma:** `Neither yasm nor nasm have been found`
- **Causa:** Na ordem do B08 o nasm vinha depois do libvpx (a relação é só 'recomendada' no livro)
- **Correção aplicada:** nasm movido para antes do libvpx
- **Tentativas:** 1

## E15 — firefox (B08) — 2026-11-02 04:52:27

- **Sintoma:** `cd: null directory`
- **Causa:** O tarball do Firefox começa com a entrada './'; o build.sh pegava a 1ª entrada para descobrir o diretório
- **Correção aplicada:** build.sh ignora entradas vazias após remover './' (grep -m1 .)
- **Tentativas:** 1

## E16 — firefox (B08) — 2026-11-02 04:54:20

- **Sintoma:** `ModuleNotFoundError: No module named '_sqlite3'`
- **Causa:** O Python do LFS foi compilado antes do SQLite; o BLFS lista Python 3 como dependência do Firefox para ser recompilado com sqlite
- **Correção aplicada:** Python 3.13.7 recompilado (mesmas opções do LFS) antes do Firefox
- **Tentativas:** 1

## E17 — kernel (B09) — 2026-11-02 05:51:24

- **Sintoma:** `FALTA: CONFIG_SND_PCM=y / SND_HDA_CODEC_GENERIC=m / SND_HDA_CODEC_IDT=m`
- **Causa:** SND_PCM é selecionada (vira módulo junto com os drivers); GENERIC e IDT não existem com esses nomes no 6.16 (SND_HDA_GENERIC e SIGMATEL cobrem)
- **Correção aplicada:** Retiradas da lista de verificação
- **Tentativas:** 1

## E18 — xfce4-session (integração) (B12) — 2026-11-02 06:23:49

- **Sintoma:** `Tela: 'Não foi possível carregar uma sessão de modo de segurança' (xfce4-panel/xfwm4/xfdesktop não sobem)`
- **Causa:** A integração sobrescreveu /etc/xdg/.../xfce4-session.xml (e xsettings.xml) com versões reduzidas, apagando a definição da sessão Failsafe
- **Correção aplicada:** XMLs do sistema restaurados dos tarballs do XFCE; preferências do Sagui gravadas na config do usuário (/etc/skel/.config/xfce4/xfconf); B10 e B11 refeitos
- **Tentativas:** 1

