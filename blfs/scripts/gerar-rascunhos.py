#!/usr/bin/env python3
"""Gera scripts/pkgs/<secao>_<pagina>.sh (rascunho) com os comandos do livro para cada página
de planos/ordem.txt. Remove suítes de teste, a definição de as_root (vem do prelúdio) e 'bash -e'.
NÃO sobrescreve scripts já revisados (que têm a linha '# REVISADO').
Cada bloco é marcado '# [bN:tipo]' para a revisão."""
import json, pathlib, re
B = pathlib.Path(__file__).resolve().parent.parent
d = json.load(open(B / 'livro/blfs-index.json'))
out = B / 'scripts/pkgs'; out.mkdir(exist_ok=True)
TESTE = re.compile(r'^\s*(make\b.*\b(check|test|tests)\b|ninja\b.*\btest\b|meson test|ctest\b|.*\bmake_check\.log|.*test_summary|python3 -m pytest|pytest\b)')
for p in [l.strip() for l in open(B / 'scripts/planos/ordem.txt') if l.strip()]:
    f = out / (p.replace('/', '_') + '.sh')
    if f.exists() and '# REVISADO' in f.read_text():
        continue
    v = d[p]
    linhas = [f'# {p} — {v["title"]}', f'# urls: {" ".join(v["urls"][:3])}', '# RASCUNHO (gerado de livro/blfs-index.json)']
    for i, c in enumerate(v['cmds']):
        t = c['text'].replace('<PREFIX>', '/usr')
        if t.strip() in ('bash -e', 'exit') or 'export -f as_root' in t:
            continue
        corpo = [l for l in t.splitlines() if not TESTE.match(l)]
        if not any(l.strip() for l in corpo):
            continue
        linhas.append(f'# [b{i}:{c["kind"]}]')
        linhas += corpo
    f.write_text('\n'.join(linhas) + '\n')
print('ok')
