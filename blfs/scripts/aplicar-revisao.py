#!/usr/bin/env python3
"""Lê scripts/revisao.txt e gera scripts/pkgs/<id>.sh (REVISADO) e scripts/planos/<marco>.txt
(linhas id|tarball|snippet|modo para o build.sh), na ordem em que aparecem na revisão."""
import json, pathlib, re
B = pathlib.Path(__file__).resolve().parent.parent
d = json.load(open(B / 'livro/blfs-index.json'))
TESTE = re.compile(r'^\s*(make\b.*\b(check|test|tests)\b|ninja\b.*\btest\b|meson test|ctest\b|.*\bmake_check\.log|.*test_summary|python3 -m pytest|pytest\b)')
def bloco(p, n):
    t = d[p]['cmds'][n]['text'].replace('<PREFIX>', '/usr')
    return '\n'.join(l for l in t.splitlines() if not TESTE.match(l))
def tar_padrao(p):
    for u in d[p]['urls']:
        nome = u.split('/')[-2] if u.endswith('/download') else u.split('/')[-1]
        if not re.search(r'\.(patch|patch\.gz)$', nome) and not u.startswith('ftp://'):
            return nome
    return '-'
secoes, cur = [], None
for ln in open(B / 'scripts/revisao.txt').read().splitlines():
    if ln.startswith('@@@ '):
        parts = ln[4:].split()
        cur = {'page': parts[0], 'blocks': [], 'opts': {}, 'text': []}
        for x in parts[1:]:
            if re.fullmatch(r'b\d+', x): cur['blocks'].append(int(x[1:]))
            elif '=' in x: k, v = x.split('=', 1); cur['opts'][k] = v
        secoes.append(cur)
    elif cur is not None and not (ln.startswith('# ') and not cur['text'] and not cur['blocks'] and False):
        cur['text'].append(ln)
planos = {}
(B / 'scripts/pkgs').mkdir(exist_ok=True)
for s in secoes:
    p = s['page']; slug = p.split('/')[-1]
    corpo = [f'# REVISADO — {p}' + (f' — {d[p]["title"]}' if p in d else ''), 'set -e']
    for n in s['blocks']: corpo.append(bloco(p, n))
    for ln in s['text']:
        m = re.fullmatch(r'@b(\d+)', ln.strip())
        corpo.append(bloco(p, int(m.group(1))) if m else ln)
    while corpo and not corpo[-1].strip(): corpo.pop()
    f = B / 'scripts/pkgs' / f'{slug}.sh'
    f.write_text('\n'.join(corpo) + '\n')
    tar = s['opts'].get('tar') or (tar_padrao(p) if p in d else '-')
    modo = s['opts'].get('modo', 'chroot')
    planos.setdefault(s['opts']['marco'], []).append(f'b-{slug}|{tar}|pkgs/{slug}.sh|{modo}')
for m, linhas in planos.items():
    (B / 'scripts/planos' / f'{m}.txt').write_text(f'# {m} — gerado por aplicar-revisao.py\n' + '\n'.join(linhas) + '\n')
print({m: len(l) for m, l in planos.items()}, 'total', sum(len(l) for l in planos.values()))
