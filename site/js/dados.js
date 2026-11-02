// Gerado por site/gerar-dados.py a partir dos registros reais do projeto
window.SAGUI_DADOS = {
 "fase1": {
  "titulo": "Fase 1 — Semente Linux 1.0 (terminal)",
  "iso": "semente-linux-1.0-x86_64.iso",
  "sha256": "b42b3ec74d6852c2d9017007ff646c8e1871b63338e0afa70008fc79de52363c",
  "inicio": "2026-11-01 15:03",
  "fim": "2026-11-01 23:58",
  "marcos": [
   {
    "id": "H01",
    "nome": "Preparar host",
    "peso": 3,
    "passos": 0,
    "min_build": 0
   },
   {
    "id": "H02",
    "nome": "Baixar livro, pacotes e patches; validar checksums",
    "peso": 3,
    "passos": 0,
    "min_build": 0
   },
   {
    "id": "H03",
    "nome": "Preparar $LFS, usuário lfs e ambiente",
    "peso": 2,
    "passos": 0,
    "min_build": 0
   },
   {
    "id": "H04",
    "nome": "Toolchain cruzada (capítulo 5)",
    "peso": 10,
    "passos": 5,
    "min_build": 15
   },
   {
    "id": "H05",
    "nome": "Ferramentas temporárias (capítulo 6)",
    "peso": 10,
    "passos": 17,
    "min_build": 24
   },
   {
    "id": "H06",
    "nome": "Chroot e ferramentas adicionais (capítulo 7) + backup",
    "peso": 6,
    "passos": 11,
    "min_build": 15
   },
   {
    "id": "H07",
    "nome": "Sistema base (capítulo 8) + backup",
    "peso": 30,
    "passos": 83,
    "min_build": 225
   },
   {
    "id": "H08",
    "nome": "Configuração do sistema (capítulo 9)",
    "peso": 4,
    "passos": 1,
    "min_build": 0
   },
   {
    "id": "H09",
    "nome": "Kernel",
    "peso": 8,
    "passos": 1,
    "min_build": 8
   },
   {
    "id": "H10",
    "nome": "Live system: initramfs, squashfs, overlay",
    "peso": 8,
    "passos": 2,
    "min_build": 2
   },
   {
    "id": "H11",
    "nome": "ISO híbrida BIOS + UEFI com GRUB",
    "peso": 6,
    "passos": 5,
    "min_build": 2
   },
   {
    "id": "H12",
    "nome": "Testes automáticos em QEMU (BIOS, UEFI, USB)",
    "peso": 6,
    "passos": 0,
    "min_build": 0
   },
   {
    "id": "H13",
    "nome": "Entrega: ISO, checksum, guia de gravação",
    "peso": 4,
    "passos": 0,
    "min_build": 0
   }
  ],
  "erros": [
   {
    "marco": "H02",
    "pacote": "ncurses-6.5-20250809.tgz",
    "sintoma": "invisible-mirror.net/archives/ncurses/current/ncurses-6.5-20250809.tgz: ERROR 404: Not Found",
    "causa": "O upstream move o snapshot de 'current/' quando sai um novo; a URL do wget-list ficou obsoleta",
    "correcao": "Baixado do espelho oficial de pacotes LFS ftp.osuosl.org/pub/lfs/lfs-packages/12.4/; md5 confere"
   },
   {
    "marco": "H04",
    "pacote": "binutils-pass1",
    "sintoma": "tar: binutils-2.45: Cannot mkdir: Permission denied",
    "causa": "rsync -a em H03 copiou as permissões do diretório sources/ do projeto (775, dono erigobeli) por cima do chmod a+wt de $LFS/sources; o usuário lfs não podia escrever",
    "correcao": "chown root + chmod a+wt em $LFS/sources após o rsync (corrigido também em scripts/H03-preparar.sh)"
   },
   {
    "marco": "H07",
    "pacote": "stripping",
    "sintoma": "strip: /usr/lib/libgcc_s.so: file format not recognized (rc=1)",
    "causa": "O laço de strip do livro (8.85) passa por arquivos que não são ELF (scripts de linker como libgcc_s.so); o livro diz para ignorar, mas com set -e o primeiro erro aborta o script",
    "correcao": "strip --strip-debug $i 2>/dev/null || true no laço genérico; passo relançado"
   },
   {
    "marco": "H11",
    "pacote": "grub-mkrescue",
    "sintoma": "grub-mkrescue: error: cannot open `/usr/share/grub/unicode.pf2': No such file or directory",
    "causa": "Com o alvo x86_64-efi o grub-mkrescue renderiza o rótulo de disco (Apple) com a fonte unicode.pf2, que só é gerada se o GRUB for configurado com FreeType + Unifont (não fazem parte do LFS). --fonts= não evita isso.",
    "correcao": "Seguido o BLFS 12.4 (GRUB-2.12 for EFI): FreeType-2.13.3 e Unifont-16.0.04 (md5 conferidos com o BLFS) compilados/instalados no chroot, GRUB EFI recompilado (gera unicode.pf2 e grub-mkfont); squashfs refeito para incluir isso"
   },
   {
    "marco": "H12",
    "pacote": "teste QEMU (expect)",
    "sintoma": "Login timed out after 60 seconds (senha enviada logo após 'Password:')",
    "causa": "O login(1) descarta a entrada pendente ao desligar o eco; o expect mandou a senha antes disso. Além disso o prompt do root no LFS é '-bash-5.3#', não 'root...#'",
    "correcao": "sleep 2 antes do usuário e da senha; espera por '# ' e define PS1='TESTE# ' para os comandos"
   },
   {
    "marco": "H12",
    "pacote": "teste QEMU (expect)",
    "sintoma": "expect parado após o login, sem casar o prompt nem disparar o timeout",
    "causa": "No expect, um padrão \"# \" no início de uma linha dentro de { } é lido como comentário e anula o resto do bloco; além disso, sem KVM o UART emulado às vezes perde caracteres digitados",
    "correcao": "Padrão trocado por -re {bash-[0-9.]+# $}; digitação lenta (send -s) e até 3 tentativas de login"
   },
   {
    "marco": "H12",
    "pacote": "teste QEMU (expect)",
    "sintoma": "expect: does \"...Password: ...\" match glob pattern \" \"Password:\" {} timeout {...} \"? no",
    "causa": "Correção da causa real: bloco expect { } escrito em uma linha só é tratado como um único padrão literal (inclusive dentro do for), então o teste nunca mandava a senha e o login(1) expirava",
    "correcao": "Script boot-test.exp reescrito com todos os blocos expect multilinha"
   },
   {
    "marco": "H12",
    "pacote": "initramfs (/init)",
    "sintoma": "[live] ERRO: mídia SEMENTE_LIVE não encontrada (teste USB: sda com sda1..sda4)",
    "causa": "Gravada como disco (pendrive/DD), a ISO híbrida tem tabela GPT/MBR; o blkid passa a ver as partições e não reporta o label iso9660 do disco inteiro",
    "correcao": "/init ganhou um fallback: tenta montar cada /dev/<disco|partição> como iso9660 e reconhece a mídia pelo arquivo live/SEMENTE_LIVE + live/rootfs.squashfs; initramfs, squashfs e ISO refeitos"
   }
  ],
  "acoes": 160,
  "pacotes": 125,
  "mais_longos": [
   {
    "id": "ch8-gcc",
    "marco": "H07",
    "min": 128.4
   },
   {
    "id": "ch8-glibc",
    "marco": "H07",
    "min": 37.5
   },
   {
    "id": "ch6-gcc-pass2",
    "marco": "H05",
    "min": 12.8
   },
   {
    "id": "ch8-binutils",
    "marco": "H07",
    "min": 8.8
   },
   {
    "id": "ch5-gcc-pass1",
    "marco": "H04",
    "min": 8.1
   },
   {
    "id": "ch10-kernel",
    "marco": "H09",
    "min": 7.5
   },
   {
    "id": "ch8-gettext",
    "marco": "H07",
    "min": 6.5
   },
   {
    "id": "ch7-gettext",
    "marco": "H06",
    "min": 6.2
   }
  ]
 },
 "fase2": {
  "titulo": "Fase 2 — Sagui Linux 2.0 (XFCE)",
  "iso": "sagui-linux-2.0-x86_64.iso",
  "sha256": "09d5d8cb6e85f56e56c175ed7169d41708f9463f217477fe174d3375217af634",
  "inicio": "2026-11-02 00:20",
  "fim": "2026-11-02 13:38",
  "marcos": [
   {
    "id": "B01",
    "nome": "Planejamento: PRD, livro BLFS, índice de dependências, renomear para Sagui",
    "peso": 3,
    "passos": 0,
    "min_build": 0
   },
   {
    "id": "B02",
    "nome": "Identidade visual: mascote, logo, wallpaper (Higgsfield) + derivados",
    "peso": 4,
    "passos": 0,
    "min_build": 0
   },
   {
    "id": "B03",
    "nome": "Base: make-ca, dhcpcd, sudo, D-Bus, módulos Python, libs gerais",
    "peso": 8,
    "passos": 16,
    "min_build": 12
   },
   {
    "id": "B04",
    "nome": "Xorg: libs, xcb, libdrm, Mesa (LLVM), servidor, xinit, drivers, fontes",
    "peso": 16,
    "passos": 27,
    "min_build": 77
   },
   {
    "id": "B05",
    "nome": "Pilha GTK 3: GLib, cairo, pango, gdk-pixbuf, librsvg, at-spi2, GTK 3",
    "peso": 12,
    "passos": 18,
    "min_build": 60
   },
   {
    "id": "B06",
    "nome": "XFCE núcleo",
    "peso": 14,
    "passos": 31,
    "min_build": 9
   },
   {
    "id": "B07",
    "nome": "XFCE apps, som (ALSA/PulseAudio), Mousepad",
    "peso": 6,
    "passos": 18,
    "min_build": 7
   },
   {
    "id": "B08",
    "nome": "Firefox ESR (Rust, Node.js, NSS, ICU)",
    "peso": 14,
    "passos": 16,
    "min_build": 103
   },
   {
    "id": "B09",
    "nome": "Kernel: DRM/GPU, som, input",
    "peso": 4,
    "passos": 2,
    "min_build": 8
   },
   {
    "id": "B10",
    "nome": "Integração: usuário sagui, autologin, tema Brasil, DHCP, polkit",
    "peso": 6,
    "passos": 2,
    "min_build": 0
   },
   {
    "id": "B11",
    "nome": "Live + ISO híbrida Sagui",
    "peso": 5,
    "passos": 3,
    "min_build": 6
   },
   {
    "id": "B12",
    "nome": "Testes QEMU (BIOS, UEFI, USB) com captura de tela",
    "peso": 5,
    "passos": 0,
    "min_build": 0
   },
   {
    "id": "B13",
    "nome": "Entrega: ISO, SHA-256, guia, teste em hardware",
    "peso": 3,
    "passos": 0,
    "min_build": 0
   }
  ],
  "erros": [
   {
    "marco": "B03",
    "pacote": "p11-kit / make-ca",
    "sintoma": "/usr/sbin/make-ca: line 980: /usr/bin/trust: No such file or directory ... Failed!!! (e o passo terminou com código 0)",
    "causa": "A ordem calculada colocou o p11-kit antes da libtasn1 (a libtasn1 é 'recomendada' do p11-kit, e sem ela o p11-kit não gera o módulo trust); o make-ca não propaga a falha no código de saída",
    "correcao": "libtasn1 movida para antes do p11-kit em revisao.txt; p11-kit recompilado e make-ca -g --force: 507 certificados e ca-bundle.crt gerados"
   },
   {
    "marco": "B03",
    "pacote": "dbus",
    "sintoma": "xz: (stdin): Unexpected end of input / tar: Unexpected EOF in archive",
    "causa": "O sincronizador copiou para $LFS/sources uma tarball que ainda estava sendo baixada (sobrescrevendo a cópia completa da Fase 1)",
    "correcao": "faltando.sh só copia arquivos parados há >2 min e que passam no teste de integridade (xz/gzip/bzip2 -t); dbus restaurado"
   },
   {
    "marco": "B03",
    "pacote": "cmake",
    "sintoma": "CMAKE_USE_SYSTEM_CURL is ON but a curl is not found!",
    "causa": "--system-libs do livro supõe as recomendadas curl, libarchive, libuv e nghttp2 já instaladas",
    "correcao": "bootstrap sem --system-libs (bibliotecas embutidas do CMake)"
   },
   {
    "marco": "B03",
    "pacote": "libxml2",
    "sintoma": "make: *** No rule to make target 'install'.",
    "causa": "Erro na revisão: os blocos de instalação do livro (b3 b4) ficaram antes do configure ajustado",
    "correcao": "Entrada da libxml2 só com os comandos ajustados; conferidas as demais entradas que misturam blocos e texto"
   },
   {
    "marco": "B03",
    "pacote": "libpng",
    "sintoma": "gzip: ../libpng-1.6.47-apng.patch.gz: No such file or directory (build seguiu sem o patch)",
    "causa": "O baixar.py só reconhecia URLs terminadas em .patch (este é .patch.gz) e o 'gzip -cd | patch' do livro não falha com set -e (pipe)",
    "correcao": "Patch baixado (extras-download.txt); script sem pipe; libpng recompilada com APNG (png_get_next_frame_fcTL presente), necessária para o Firefox"
   },
   {
    "marco": "B04",
    "pacote": "mesa",
    "sintoma": "mesa-25.1.8.tar.xz em $LFS/sources com 791907 bytes (parcial)",
    "causa": "Cópia feita pela 1ª versão do sincronizador enquanto o download ainda corria",
    "correcao": "Comparação de tamanho de todas as tarballs; a parcial foi apagada e o loop espera a cópia completa"
   },
   {
    "marco": "B04",
    "pacote": "xorg-server",
    "sintoma": "ERROR: Dependency \"xdmcp\" not found",
    "causa": "libXdmcp é só 'recomendada' (libxcb) no livro e não entrou no fecho de obrigatórias, mas o Xorg-Server a exige",
    "correcao": "libXdmcp-1.1.5 (md5 ok) adicionada ao B04 antes do servidor"
   },
   {
    "marco": "B05",
    "pacote": "curl",
    "sintoma": "configure: error: libpsl libs and/or directories were not found",
    "causa": "libpsl é recomendada do curl e não foi incluída",
    "correcao": "--without-libpsl"
   },
   {
    "marco": "B05",
    "pacote": "gdk-pixbuf",
    "sintoma": "ERROR: No rst2man found, but man pages were explicitly enabled",
    "causa": "Páginas de manual exigem docutils (opcional)",
    "correcao": "-D man=false"
   },
   {
    "marco": "B06",
    "pacote": "xfce4-dev-tools",
    "sintoma": "configure: error: package 'xsltproc' missing",
    "causa": "libxslt não estava no fecho (é só recomendada para glib/gtk3/polkit), mas o xfce4-dev-tools exige xsltproc",
    "correcao": "libxslt-1.1.43 (md5 ok) adicionada antes do xfce4-dev-tools"
   },
   {
    "marco": "B06",
    "pacote": "polkit",
    "sintoma": "ERROR: C shared or static library 'pam' not found",
    "causa": "polkit usa Linux-PAM por padrão (fora do escopo)",
    "correcao": "-D authfw=shadow (autenticação via /etc/shadow, suportada pelo polkit)"
   },
   {
    "marco": "B07",
    "pacote": "xfce4-terminal",
    "sintoma": "failed to load \"http://docbook.sourceforge.net/.../docbook.xsl\"",
    "causa": "A página de manual exige DocBook-XSL (não instalado)",
    "correcao": "subdir('doc') removido do meson.build"
   },
   {
    "marco": "B07",
    "pacote": "gtksourceview4",
    "sintoma": "ERROR: Dependency \"vapigen\" not found",
    "causa": "vapi habilitado por padrão; vala não instalado",
    "correcao": "-D vapi=false"
   },
   {
    "marco": "B08",
    "pacote": "libvpx",
    "sintoma": "Neither yasm nor nasm have been found",
    "causa": "Na ordem do B08 o nasm vinha depois do libvpx (a relação é só 'recomendada' no livro)",
    "correcao": "nasm movido para antes do libvpx"
   },
   {
    "marco": "B08",
    "pacote": "firefox",
    "sintoma": "cd: null directory",
    "causa": "O tarball do Firefox começa com a entrada './'; o build.sh pegava a 1ª entrada para descobrir o diretório",
    "correcao": "build.sh ignora entradas vazias após remover './' (grep -m1 .)"
   },
   {
    "marco": "B08",
    "pacote": "firefox",
    "sintoma": "ModuleNotFoundError: No module named '_sqlite3'",
    "causa": "O Python do LFS foi compilado antes do SQLite; o BLFS lista Python 3 como dependência do Firefox para ser recompilado com sqlite",
    "correcao": "Python 3.13.7 recompilado (mesmas opções do LFS) antes do Firefox"
   },
   {
    "marco": "B09",
    "pacote": "kernel",
    "sintoma": "FALTA: CONFIG_SND_PCM=y / SND_HDA_CODEC_GENERIC=m / SND_HDA_CODEC_IDT=m",
    "causa": "SND_PCM é selecionada (vira módulo junto com os drivers); GENERIC e IDT não existem com esses nomes no 6.16 (SND_HDA_GENERIC e SIGMATEL cobrem)",
    "correcao": "Retiradas da lista de verificação"
   },
   {
    "marco": "B12",
    "pacote": "xfce4-session (integração)",
    "sintoma": "Tela: 'Não foi possível carregar uma sessão de modo de segurança' (xfce4-panel/xfwm4/xfdesktop não sobem)",
    "causa": "A integração sobrescreveu /etc/xdg/.../xfce4-session.xml (e xsettings.xml) com versões reduzidas, apagando a definição da sessão Failsafe",
    "correcao": "XMLs do sistema restaurados dos tarballs do XFCE; preferências do Sagui gravadas na config do usuário (/etc/skel/.config/xfce4/xfconf); B10 e B11 refeitos"
   }
  ],
  "acoes": 176,
  "pacotes": 133,
  "mais_longos": [
   {
    "id": "b-llvm",
    "marco": "B04",
    "min": 60.2
   },
   {
    "id": "b-firefox",
    "marco": "B08",
    "min": 47.8
   },
   {
    "id": "b-nodejs",
    "marco": "B08",
    "min": 41.4
   },
   {
    "id": "b-rust",
    "marco": "B05",
    "min": 39.5
   },
   {
    "id": "b-kernel",
    "marco": "B09",
    "min": 8.4
   },
   {
    "id": "b-cmake",
    "marco": "B03",
    "min": 7.5
   },
   {
    "id": "b-squashfs",
    "marco": "B11",
    "min": 5.8
   },
   {
    "id": "b-mesa",
    "marco": "B04",
    "min": 5.1
   }
  ]
 }
};
