<p align="center">
  <img src="site/img/logo-sagui.svg" width="120" alt="Logo do Sagui Linux">
</p>

<h1 align="center">Sagui Linux</h1>

<h3 align="center">🤖 A distribuição Linux criada 100% por IA 🐧🐒</h3>

<p align="center">Compilada do zero, pacote por pacote, a partir do código-fonte — com os livros<br>
<a href="https://www.linuxfromscratch.org/lfs/">Linux From Scratch 12.4</a> e <a href="https://www.linuxfromscratch.org/blfs/">Beyond Linux From Scratch 12.4</a>, pelo <strong>Claude Opus 5.5</strong>.</p>

<p align="center">
  <a href="https://github.com/erigobeli/saguilinux/releases/latest"><img alt="Download" src="https://img.shields.io/github/v/release/erigobeli/saguilinux?label=download&color=009c3b&style=for-the-badge"></a>
  <a href="https://erigobeli.github.io/saguilinux/"><img alt="Site" src="https://img.shields.io/badge/site-saguilinux-002776?style=for-the-badge"></a>
  <a href="https://www.youtube.com/@EliRigobeliAI"><img alt="YouTube" src="https://img.shields.io/badge/YouTube-@EliRigobeliAI-ff0000?style=for-the-badge&logo=youtube&logoColor=white"></a>
</p>
<p align="center">
  <img alt="Feito por IA" src="https://img.shields.io/badge/feito%20por-Claude%20Opus%205.5-d97757">
  <img alt="Base" src="https://img.shields.io/badge/base-LFS%2012.4%20%2B%20BLFS%2012.4-2d6a4f">
  <img alt="Desktop" src="https://img.shields.io/badge/desktop-XFCE%204.20-2284f2">
  <img alt="Boot" src="https://img.shields.io/badge/boot-BIOS%20%2B%20UEFI-555">
  <a href="LICENSE"><img alt="Licença" src="https://img.shields.io/badge/licen%C3%A7a-MIT%20%2B%20CC%20BY%204.0-ffdf00"></a>
</p>

<p align="center">
  <a href="https://erigobeli.github.io/saguilinux/">Site</a> ·
  <a href="https://github.com/erigobeli/saguilinux/releases">Download</a> ·
  <a href="https://erigobeli.github.io/saguilinux/instalar.html">Como gravar</a> ·
  <a href="https://erigobeli.github.io/saguilinux/historia.html">Como foi feito</a> ·
  <a href="CONTRIBUTING.md">Contribuir</a>
</p>

<p align="center">
  <img src="site/img/desktop.jpg" width="88%" alt="Desktop do Sagui Linux 2.0 com o painel azul, ícones e o wallpaper da floresta com o sagui">
</p>

---

O **Sagui Linux** é um projeto **educacional**: um sistema operacional Linux montado peça por peça — compilador, biblioteca C, kernel, sistema de inicialização, servidor gráfico, desktop XFCE e Firefox — sem partir de nenhuma distribuição pronta.

Todo o trabalho técnico foi feito por um agente de IA (**Claude Opus 5.5**, da Anthropic, no **Claude Code**): ler os livros, escrever os scripts deste repositório, compilar ~250 pacotes, corrigir 26 erros, testar as imagens em máquinas virtuais e documentar tudo. A parte humana — de **Eli Rigobeli** — foi definir o objetivo, tomar as decisões de produto e testar em hardware real.

<table>
  <tr>
    <td width="50%"><img src="site/img/firefox.jpg" alt="Firefox aberto na página de boas-vindas do Sagui Linux"></td>
    <td width="50%" align="center"><img src="site/img/tux-e-sagui.png" alt="Tux e o sagui lado a lado"></td>
  </tr>
  <tr>
    <td align="center"><sub>Firefox ESR compilado do código-fonte, na página de boas-vindas</sub></td>
    <td align="center"><sub>O Tux e o mascote sagui</sub></td>
  </tr>
</table>

## ⬇️ Edições

| | Sagui Linux 2.0 (Desktop) | Edição de terminal 1.0 |
|---|---|---|
| Interface | XFCE 4.20 | Linha de comando |
| Programas | Firefox ESR 140, Thunar, Terminal, Mousepad, Ristretto | GCC, Bash, Vim, ferramentas GNU |
| Base | LFS 12.4 + BLFS 12.4 | LFS 12.4 |
| ISO | `sagui-linux-2.0-x86_64.iso` (841 MB) | `semente-linux-1.0-x86_64.iso` (295 MB) |
| Login | `sagui`/`sagui` (automático) · `root`/`sagui` | `root`/`semente` |

As duas são **live** (rodam da memória RAM, sem instalar), híbridas **BIOS + UEFI**, para pendrive ou máquina virtual. A edição de terminal saiu com o nome provisório "Semente Linux". **Downloads diretos** (ISO + SHA-256 + código-fonte) nas [Releases](https://github.com/erigobeli/saguilinux/releases). Tutorial de gravação — **balenaEtcher recomendado** — no [site](https://erigobeli.github.io/saguilinux/instalar.html).

> ⚠️ **Projeto educacional, sem garantia.** Tudo o que você fizer no sistema live some ao desligar; gravar a ISO apaga o pendrive. Leia os [cuidados antes de testar](https://erigobeli.github.io/saguilinux/sobre.html#cuidados).

## 📁 O que tem neste repositório

```
PRD.md, STATUS.md, status.json   Fase 1 (edição de terminal, LFS): requisitos, estado final
historias/  docs/  dashboard/    histórias H01–H13, diário, erros, decisões, painel
scripts/                         scripts de build da Fase 1 (driver, planos por capítulo, live, ISO, testes)
logs/testes/                     saída dos testes automáticos em QEMU

blfs/                            Fase 2 (Sagui Linux 2.0, BLFS + XFCE)
  PRD.md  historias/ docs/ dashboard/
  scripts/revisao.txt            fonte única dos comandos do BLFS revisados (gera scripts/pkgs/ e planos/)
  scripts/sagui/                 kernel, integração (usuário, autologin, tema), live
  arte/                          logo, mascote, wallpaper (Higgsfield) e derivados
  logs/testes/                   testes em QEMU com capturas de tela

site/                            site do projeto (HTML + CSS + JS puros)
divulgacao/                      imagens e textos para redes sociais
```

Não estão no Git (por tamanho ou por serem de terceiros): as ISOs e os **tarballs de código-fonte** de todos os pacotes (ambos publicados nas Releases), as cópias dos livros, os backups e os logs completos de compilação.

## 🛠️ Como foi feito

1. Um **PRD** define objetivo, regras e critérios de aceite; o trabalho vira **13 histórias** por fase.
2. Os comandos são extraídos dos livros, revisados e organizados em **planos**; um **driver idempotente** (`scripts/build.sh`) compila um pacote por vez dentro do chroot, salva o log e marca o que terminou.
3. **Loops** de execução, monitoramento, correção e documentação; cada erro registrado com sintoma, causa e correção (`docs/erros.md`, `blfs/docs/erros.md`).
4. **Testes automáticos** em QEMU (BIOS, UEFI, USB), com capturas de tela analisadas pelo agente.
5. Teste final em hardware real.

A história completa, com tempos e todos os erros, está no [site](https://erigobeli.github.io/saguilinux/historia.html).

## 🔁 Reproduzir o build

Leia primeiro os livros [LFS 12.4](https://www.linuxfromscratch.org/lfs/view/12.4/) e [BLFS 12.4](https://www.linuxfromscratch.org/blfs/view/12.4/) — os scripts seguem os livros e só fazem sentido com eles. Em linhas gerais (Ubuntu 24.04 como hospedeiro, root via sudo):

```bash
bash scripts/H02-baixar.sh && bash scripts/H03-preparar.sh
bash scripts/rodar-etapa.sh scripts/planos/ch5.txt:H04 scripts/planos/ch6.txt:H05 \
     scripts/planos/ch7.txt:H06 scripts/planos/ch8.txt:H07 scripts/planos/ch9.txt:H08 scripts/planos/ch10.txt:H09
# ... live e ISO da Fase 1; depois a Fase 2:
cd blfs && python3 scripts/baixar.py && python3 scripts/aplicar-revisao.py
bash scripts/rodar-blfs.sh B03 B04 B05 B06 B07 B08 B09 B10 B11
```

Os scripts foram escritos para o ambiente onde o projeto foi feito (caminhos como `/home/erigobeli` e `/mnt/lfs`); adapte antes de usar. **Compilar um sistema mexe com root e partições — faça numa máquina ou VM descartável.**

## 🤝 Contribuir

Contribuições são bem-vindas: relatos de teste em hardware, correções na documentação, melhorias nos scripts. Veja [CONTRIBUTING.md](CONTRIBUTING.md) e o [código de conduta](CODE_OF_CONDUCT.md).

## ⚖️ Licenças e créditos

- Scripts e código deste repositório: **[MIT](LICENSE)**. Textos, documentação e arte: **CC BY 4.0**. Detalhes, licenças dos componentes do sistema e créditos em **[LICENCAS.md](LICENCAS.md)**.
- Livros: *Linux From Scratch* e *Beyond Linux From Scratch*, © Gerard Beekmans e equipe LFS/BLFS — os comandos extraídos dos livros são usados sob a licença MIT que os próprios livros concedem às instruções.
- Tux © Larry Ewing (lewing@isc.tamu.edu), criado com o GIMP.
- Linux® é marca registrada de Linus Torvalds. Firefox e Mozilla são marcas da Mozilla Foundation; o navegador do Sagui é compilado sem a marca oficial. O projeto não é afiliado ao LFS, à Linux Foundation nem à Mozilla.

Criado por **Eli Rigobeli** · construído por **Claude Opus 5.5** (Anthropic) · [@EliRigobeliAI](https://www.youtube.com/@EliRigobeliAI)
