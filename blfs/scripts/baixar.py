#!/usr/bin/env python3
"""Baixa as fontes de todas as páginas de planos/ordem.txt (+ planos/extras-download.txt)
para sources/, valida md5 quando o livro informa, e grava logs/B03-download.log.
- Páginas comuns: URLs do bloco de pacote (tarball + patches). md5 = primeiro 'MD5 sum' da página.
- Páginas com lista (x7lib, x7app, x7font, x7driver, xcb-util?...): lê o bloco 'cat > *.md5' dos
  comandos e baixa cada arquivo da URL base usada no 'wget -B'.
Idempotente: pula arquivos que já existem com md5 correto."""
import functools, hashlib, json, pathlib, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
print = functools.partial(print, flush=True)
B = pathlib.Path(__file__).resolve().parent.parent
d = json.load(open(B / 'livro/blfs-index.json'))
src = B / 'sources'; src.mkdir(exist_ok=True)
ordem = [l.strip() for l in open(B / 'scripts/planos/ordem.txt') if l.strip()]
extras = [l.split('#')[0].split() for l in open(B / 'scripts/planos/extras-download.txt') if l.split('#')[0].strip()]
falhas = []
tarefas = []
ESPELHOS = [('https://xorg.freedesktop.org/archive/', 'https://www.x.org/pub/'), ('http://xorg.freedesktop.org/archive/', 'https://www.x.org/pub/')]

def md5(f):
    h = hashlib.md5()
    with open(f, 'rb') as fh:
        for b in iter(lambda: fh.read(1 << 20), b''): h.update(b)
    return h.hexdigest()

def baixa(url, nome=None, soma=None):
    for a, b in ESPELHOS: url = url.replace(a, b)
    nome = nome or url.rstrip('/').split('/')[-1]
    if nome == 'download': nome = url.split('/')[-2]
    f = src / nome
    if f.exists() and (soma is None or md5(f) == soma):
        return True
    r = subprocess.run(['wget', '-q', '--tries=3', '--timeout=60', '-O', str(f), url])
    if r.returncode != 0 or not f.exists() or f.stat().st_size == 0:
        print(f'FALHA download {nome} <- {url}'); falhas.append(nome); f.unlink(missing_ok=True); return False
    if soma and md5(f) != soma:
        print(f'FALHA md5 {nome}: esperado {soma} obtido {md5(f)}'); falhas.append(nome); return False
    print(f'ok {nome}' + (' (md5 ok)' if soma else ''))
    return True

for p in ordem:
    v = d[p]
    lista = None
    for c in v['cmds']:
        m = re.search(r'cat > (\S+\.md5) << "EOF"\n(.*?)\nEOF', c['text'], re.S)
        if m: lista = m.group(2)
    base = None
    for c in v['cmds']:
        m = re.search(r'-B (https?://\S+)', c['text'])
        if m: base = m.group(1)
    if lista and base:
        for ln in lista.splitlines():
            if not ln.strip() or ln.startswith('#'): continue
            soma, nome = ln.split()
            tarefas.append((base.rstrip('/') + '/' + nome, nome, soma))
        continue
    urls = [u for u in v['urls'] if not u.startswith('ftp://')]
    if not urls: continue
    for i, u in enumerate(urls):
        tarefas.append((u, None, (v['md5'][0] if i == 0 and v['md5'] else None)))

for e in extras:
    tarefas.append((e[0], None, (e[1] if len(e) > 1 else None)))
with ThreadPoolExecutor(6) as ex:
    list(ex.map(lambda t: baixa(*t), tarefas))

print('FALHAS:', len(falhas), ' '.join(falhas))
