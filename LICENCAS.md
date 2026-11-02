# Licenças, créditos e avisos legais

Resumo em linguagem simples (não é aconselhamento jurídico).

## 1. O que é deste projeto

| Conteúdo | Licença |
|---|---|
| Scripts e código (`scripts/`, `blfs/scripts/`, `site/js/`, …) | [MIT](LICENSE) |
| Documentação, histórias, diário, textos do site e de divulgação | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.pt_BR) |
| Logo, mascote sagui e wallpaper (`blfs/arte/`), gerados com o Higgsfield (Recraft V4.1) | CC BY 4.0, na medida em que houver direitos autorais sobre o conteúdo |

CC BY 4.0 = qualquer pessoa pode usar, copiar e adaptar, inclusive comercialmente, desde que dê o crédito: **"Sagui Linux — Eli Rigobeli"**.

## 2. Livros LFS e BLFS

- *Linux From Scratch* 12.4 — © 1999-2025 Gerard Beekmans — <https://www.linuxfromscratch.org/lfs/>
- *Beyond Linux From Scratch* 12.4 — © 1999-2025 The BLFS Development Team — <https://www.linuxfromscratch.org/blfs/>

O texto dos livros é licenciado sob **Creative Commons BY-NC-SA 2.0** e **não é redistribuído** aqui (usamos os links oficiais). Os livros declaram: *"Computer instructions may be extracted from the book under the MIT License"* — é o que os scripts deste repositório fazem, com as alterações documentadas em `docs/decisoes.md`, `blfs/docs/decisoes.md` e `blfs/scripts/revisao.txt` (marcadas com `DESVIO`).

## 3. Software dentro das ISOs

As imagens do Sagui Linux contêm apenas software livre e de código aberto, compilado sem modificações além das previstas nos livros. Cada componente mantém sua licença; os textos completos vão dentro do sistema (`/usr/share/doc`, `/usr/share/licenses` e nos pacotes).

| Componentes principais | Licença |
|---|---|
| Kernel Linux | GPL-2.0 |
| GCC, glibc, Bash, coreutils, binutils, GRUB e ferramentas GNU | GPL / LGPL |
| Xorg, Mesa, libdrm, libinput, D-Bus, polkit | MIT/X11, licenças permissivas, GPL/LGPL |
| GLib, GTK 3, Pango, cairo, at-spi2, PulseAudio, ALSA | LGPL |
| XFCE e aplicativos | GPL / LGPL |
| Firefox ESR, NSS, NSPR | MPL-2.0 |
| LLVM/Clang · Rust | Apache-2.0 com exceção LLVM · MIT/Apache-2.0 |
| Fontes DejaVu | licença das fontes Bitstream Vera / domínio público |

### Código-fonte correspondente (GPL)

Quem distribui binários de software GPL precisa disponibilizar o código-fonte correspondente. Por isso **cada Release traz, junto com a ISO, um arquivo com todos os tarballs de código-fonte originais** usados para compilá-la, e este repositório contém os scripts exatos de compilação e configuração (incluindo a configuração do kernel). Isso cumpre a obrigação de entregar o código-fonte completo.

## 4. Marcas

- **Linux®** é marca registrada de Linus Torvalds nos EUA e em outros países, administrada pelo Linux Mark Institute.
- **Firefox** e **Mozilla** são marcas da Mozilla Foundation. O navegador do Sagui é compilado **sem a marca oficial** (aparece como "Nightly"), como exigem as regras da Mozilla para binários redistribuídos; ele não é um produto da Mozilla.
- **XFCE**, **GNOME/GTK**, **Xorg** e demais nomes pertencem aos respectivos donos.
- O Sagui Linux não é afiliado, patrocinado ou endossado pelo projeto Linux From Scratch, pela Linux Foundation, pela Mozilla ou pela Anthropic.

## 5. Tux

Tux, o pinguim do Linux, © Larry Ewing (lewing@isc.tamu.edu), criado com o GIMP. O autor permite o uso e a modificação desde que receba o crédito.

## 6. Sem garantia

O Sagui Linux é um projeto educacional, distribuído **"como está"**, **sem garantia de qualquer tipo**. O uso é por conta e risco de quem usa; os autores não respondem por perda de dados ou danos ao equipamento. Não há atualizações de segurança.
