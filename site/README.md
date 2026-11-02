# Site do Sagui Linux

Site estático (HTML + CSS + JS puros, sem build e sem dependências externas).

## Estrutura
```
index.html      página inicial (o que é, captura do desktop, vídeo, números)
download.html   as duas edições, diferenças, live CD/USB, requisitos, SHA-256
instalar.html   tutorial: balenaEtcher (recomendado), Rufus (modo DD), dd, boot, VM, instalar no disco
historia.html   como foi feito: método, linha do tempo, histórias, tempos, erros (dados reais)
sobre.html      cuidados, aviso educacional/sem garantia, licenças, marcas, créditos
css/style.css   estilo (claro/escuro automático, cores do Brasil)
js/config.js    >>> ÚNICO ARQUIVO A EDITAR: links de download, vídeo, repositório, canal
js/main.js      comportamento (links do config, vídeo, abas, página de história)
js/dados.js     dados reais do build (números, histórias e erros)
img/            logo, mascote, wallpaper, capturas de tela reais dos testes
```

## Depois de subir as ISOs e o vídeo
Edite `js/config.js` e preencha:
- `videoProcesso` — link do vídeo no YouTube (o player aparece sozinho na página inicial e na história);
- `repositorio` — link do repositório no GitHub;
- `downloads.desktop.url` / `downloads.terminal.url` — links das ISOs (ex.: GitHub Releases);
- `downloads.*.sha256Url` — links dos arquivos `.sha256`.
Enquanto um link estiver vazio, o botão aparece desativado como "em breve".

## Publicar (GitHub Pages)
O site é publicado no branch `gh-pages`, que contém só o conteúdo desta pasta. Depois de alterar e commitar na `main`:
```
git subtree push --prefix site origin gh-pages
```
Endereço: https://erigobeli.github.io/saguilinux/ (ou o domínio próprio, com um arquivo `CNAME` nesta pasta).
As ISOs ficam nas Releases do GitHub (até 2 GB por arquivo).

## Ver no computador
Dê dois cliques no `index.html` (abre direto no navegador, sem instalar nada).
