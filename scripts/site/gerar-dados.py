#!/usr/bin/env python3
"""Gera site/js/dados.js a partir dos registros reais do projeto (status.json, planos e logs de build)."""
import json, re, glob, os, datetime, pathlib
R = pathlib.Path(__file__).resolve().parent.parent.parent
def dur_log(f):
    t = open(f, errors='replace').read()
    a = re.search(r'- inicio: (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)', t); b = re.findall(r'- fim OK: (\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)', t)
    if not a or not b: return None
    p = lambda s: datetime.datetime.strptime(s, '%Y-%m-%d %H:%M:%S')
    d = (p(b[-1]) - p(a.group(1))).total_seconds()
    return d + 10800 if d < 0 else d  # glibc instala o fuso -03 no meio do cap. 8: o relógio do chroot "volta" 3 h
def fase(base, planos_marco, titulo, iso, sha, inicio, fim):
    s = json.load(open(base / 'status.json'))
    marcos = []
    pacotes = []
    for m in s['marcos']:
        ids = []
        for pl in planos_marco.get(m['id'], []):
            for ln in open(pl):
                if ln.strip() and not ln.startswith('#'): ids.append(ln.split('|')[0])
        seg = 0; n = 0
        for i in ids:
            f = base / 'logs' / f'{i}.log'
            if f.exists():
                d = dur_log(f)
                if d is not None: seg += d; n += 1; pacotes.append({'id': i, 'marco': m['id'], 'min': round(d / 60, 1)})
        marcos.append({'id': m['id'], 'nome': m['nome'], 'peso': m['peso'], 'passos': n, 'min_build': round(seg / 60)})
    erros = [{k: e[k] for k in ('marco', 'pacote', 'sintoma', 'causa', 'correcao')} for e in s['erros']]
    top = sorted(pacotes, key=lambda x: -x['min'])[:8]
    return {'titulo': titulo, 'iso': iso, 'sha256': sha, 'inicio': inicio, 'fim': fim,
            'marcos': marcos, 'erros': erros, 'acoes': len(s['acoes']), 'pacotes': len(pacotes), 'mais_longos': top}
f1p = {'H04': ['scripts/planos/ch5.txt'], 'H05': ['scripts/planos/ch6.txt'], 'H06': ['scripts/planos/ch7.txt'],
       'H07': ['scripts/planos/ch8.txt'], 'H08': ['scripts/planos/ch9.txt'], 'H09': ['scripts/planos/ch10.txt'],
       'H10': ['scripts/planos/live.txt'], 'H11': ['scripts/planos/isotools.txt', 'scripts/planos/iso.txt'], 'EXTRA': ['scripts/planos/extra.txt']}
f1p = {k: [R / x for x in v] for k, v in f1p.items()}
f2p = {m: [R / 'blfs/scripts/planos' / f'{m}.txt'] for m in ['B03','B04','B05','B06','B07','B08','B09','B10','B11']}
sha1 = open(R / 'iso/semente-linux-1.0-x86_64.iso.sha256').read().split()[0]
sha2 = open(R / 'blfs/iso/sagui-linux-2.0-x86_64.iso.sha256').read().split()[0]
dados = {
  'fase1': fase(R, f1p, 'Fase 1 — Semente Linux 1.0 (terminal)', 'semente-linux-1.0-x86_64.iso', sha1, '2026-11-01 15:03', '2026-11-01 23:58'),
  'fase2': fase(R / 'blfs', f2p, 'Fase 2 — Sagui Linux 2.0 (XFCE)', 'sagui-linux-2.0-x86_64.iso', sha2, '2026-11-02 00:20', '2026-11-02 13:38'),
}
open(R / 'site/js/dados.js', 'w').write('// Gerado por site/gerar-dados.py a partir dos registros reais do projeto\nwindow.SAGUI_DADOS = ' + json.dumps(dados, ensure_ascii=False, indent=1) + ';\n')
for k in dados:
    d = dados[k]; print(k, d['pacotes'], 'pacotes', len(d['erros']), 'erros', sum(m['min_build'] for m in d['marcos']), 'min build')
    for m in d['marcos']: print('  ', m['id'], m['passos'], m['min_build'])
    print('  top', [(p['id'], p['min']) for p in d['mais_longos'][:5]])
