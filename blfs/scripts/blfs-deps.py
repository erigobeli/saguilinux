#!/usr/bin/env python3
"""Ordem de build da Fase 2 a partir do índice do BLFS.
Segue dependências OBRIGATÓRIAS de cada página + arestas recomendadas escolhidas
(planos/recomendadas.txt: 'pacote dep'), ignorando arestas de alternativas
(planos/ignora-dep.txt: 'pacote dep') e páginas excluídas (planos/exclui.txt).
Saída: planos/ordem.txt (um id de página por linha, em ordem topológica)."""
import json, sys, pathlib
B = pathlib.Path(__file__).resolve().parent.parent
d = json.load(open(B / 'livro/blfs-index.json'))
def linhas(f):
    return [l.split('#')[0].split() for l in open(B / 'scripts/planos' / f) if l.split('#')[0].strip()]
alvos = [l[0] for l in linhas('alvos.txt')]
excl = {l[0] for l in linhas('exclui.txt')}
rec, ign = {}, set()
for a, b in linhas('recomendadas.txt'): rec.setdefault(a, []).append(b)
for a, b in linhas('ignora-dep.txt'): ign.add((a, b))
ordem, visto, pilha, erros = [], set(), [], []
def visita(p):
    if p in excl or p in visto: return
    if p in pilha: erros.append('CICLO ' + ' -> '.join(pilha[pilha.index(p):] + [p])); return
    if p not in d: erros.append('SEM PAGINA ' + p); return
    pilha.append(p)
    for q in d[p]['deps']['required'] + rec.get(p, []):
        if (p, q) not in ign: visita(q)
    pilha.pop(); visto.add(p); ordem.append(p)
for a in alvos: visita(a)
for e in erros: print(e, file=sys.stderr)
(B / 'scripts/planos/ordem.txt').write_text('\n'.join(ordem) + '\n')
print(len(ordem), 'páginas', file=sys.stderr)
