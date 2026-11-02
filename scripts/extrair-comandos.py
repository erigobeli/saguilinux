#!/usr/bin/env python3
"""Extrai os comandos (<pre class="userinput">) de cada página do livro LFS
para scripts/extraido/<capitulo>/<pagina>.sh, para não precisar reler o HTML."""
import html, re, sys, pathlib
book = pathlib.Path(sys.argv[1]); out = pathlib.Path(sys.argv[2])
for ch in sorted(book.glob('chapter*')):
    for page in sorted(ch.glob('*.html')):
        t = page.read_text(encoding='utf-8')
        blocks = re.findall(r'<pre class="(userinput|root)"[^>]*>(.*?)</pre>', t, re.S)
        if not blocks: continue
        o = out / ch.name; o.mkdir(parents=True, exist_ok=True)
        with open(o / (page.stem + '.sh'), 'w') as f:
            for kind, b in blocks:
                txt = html.unescape(re.sub(r'<[^>]+>', '', b))
                f.write(f'# ---- [{kind}]\n{txt}\n')
