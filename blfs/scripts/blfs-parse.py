#!/usr/bin/env python3
"""Lê o livro BLFS (HTML por capítulos) e gera livro/blfs-index.json com, para cada página:
pacote, versão, URLs de download (+ adicionais), md5, dependências required/recommended/optional
(como ids de página 'secao/pagina') e os blocos de comandos (userinput/root) em ordem.
Uso: blfs-parse.py <dir-do-livro> <saida.json>"""
import html, json, pathlib, re, sys

book = pathlib.Path(sys.argv[1])
out = {}
def clean(s):
    return html.unescape(re.sub(r'<[^>]+>', '', s))

for page in sorted(book.glob('*/*.html')):
    pid = f'{page.parent.name}/{page.stem}'
    t = page.read_text(encoding='utf-8', errors='replace')
    tn = re.sub(r'=\s*"', '="', re.sub(r'\s+', ' ', t))  # atributos quebrados em várias linhas
    title = re.search(r'<h1 class="sect1">(.*?)</h1>', tn, re.S)
    title = ' '.join(clean(title.group(1)).split()) if title else ''
    # URLs: links do bloco "Package Information" e "Additional Downloads"
    urls = re.findall(r'<a class="ulink" href="((?:https?|ftp)://[^"]+\.(?:tar\.(?:xz|gz|bz2|lz|zst)|tgz|tbz2|zip|patch|txz|pem|ttf|otf|crt)(?:/download)?)"', tn)
    md5 = re.findall(r'MD5 sum:\s*([0-9a-f]{32})', clean(t))
    deps = {}
    for kind in ('required', 'recommended', 'optional'):
        lst = []
        for p in re.findall(r'<p class="%s">(.*?)</p>' % kind, tn, re.S):
            for href in re.findall(r'<a class="xref" href="([^"#]+)\.html', p):
                parts = href.split('/')
                dep = f'{parts[-2]}/{parts[-1]}' if len(parts) >= 2 and parts[-2] != '..' else f'{page.parent.name}/{parts[-1]}'
                dep = dep.replace('../', '')
                if dep not in lst:
                    lst.append(dep)
        deps[kind] = lst
    cmds = []
    for kind, b in re.findall(r'<pre class="(userinput|root)"[^>]*>(.*?)</pre>', t, re.S):
        cmds.append({'kind': kind, 'text': clean(b)})
    out[pid] = {'title': title, 'urls': list(dict.fromkeys(urls)), 'md5': md5, 'deps': deps, 'cmds': cmds}

json.dump(out, open(sys.argv[2], 'w'), ensure_ascii=False, indent=1)
print(len(out), 'páginas')
