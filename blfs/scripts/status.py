#!/usr/bin/env python3
"""Gerencia o estado do projeto: status.json, STATUS.md, docs/diario.md,
docs/erros.md e o dashboard (com os dados embutidos no HTML).

Uso:
  status.py marco H04 em_andamento [fracao]   # fracao 0..1 (opcional)
  status.py marco H04 feito
  status.py diario H04 "o que foi feito" "resultado"
  status.py erro H04 pacote "sintoma" "causa" "correcao" tentativas
  status.py proximo "texto"
  status.py bloqueio "texto"   |  status.py bloqueio ""   (limpa)
  status.py campo chave valor  # ex.: senha_root, distro
  status.py render
"""
import json, sys, datetime, pathlib, html

ROOT = pathlib.Path(__file__).resolve().parent.parent
SJ = ROOT / 'status.json'

MARCOS = [
    ('B01', 'Planejamento: PRD, livro BLFS, índice de dependências, renomear para Sagui', 3),
    ('B02', 'Identidade visual: mascote, logo, wallpaper (Higgsfield) + derivados', 4),
    ('B03', 'Base: make-ca, dhcpcd, sudo, D-Bus, módulos Python, libs gerais', 8),
    ('B04', 'Xorg: libs, xcb, libdrm, Mesa (LLVM), servidor, xinit, drivers, fontes', 16),
    ('B05', 'Pilha GTK 3: GLib, cairo, pango, gdk-pixbuf, librsvg, at-spi2, GTK 3', 12),
    ('B06', 'XFCE núcleo', 14),
    ('B07', 'XFCE apps, som (ALSA/PulseAudio), Mousepad', 6),
    ('B08', 'Firefox ESR (Rust, Node.js, NSS, ICU)', 14),
    ('B09', 'Kernel: DRM/GPU, som, input', 4),
    ('B10', 'Integração: usuário sagui, autologin, tema Brasil, DHCP, polkit', 6),
    ('B11', 'Live + ISO híbrida Sagui', 5),
    ('B12', 'Testes QEMU (BIOS, UEFI, USB) com captura de tela', 5),
    ('B13', 'Entrega: ISO, SHA-256, guia, teste em hardware', 3),
]
LABEL = {'a_fazer': 'a fazer', 'em_andamento': 'em andamento', 'feito': 'feito', 'bloqueado': 'bloqueado'}


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def load():
    if SJ.exists():
        return json.loads(SJ.read_text())
    return {
        'projeto': 'Sagui Linux — desktop XFCE (Fase 2)', 'distro': 'Sagui Linux 2.0',
        'livro': 'BLFS 12.4 (SysVinit) sobre LFS 12.4',
        'marcos': [{'id': i, 'nome': n, 'peso': p, 'status': 'a_fazer', 'fracao': 0.0, 'concluido_em': None}
                   for i, n, p in MARCOS],
        'acoes': [], 'erros': [], 'proximo_passo': '', 'bloqueios': '', 'ultimo_passo': '',
        'atualizado_em': now(), 'extra': {},
    }


def pct(s):
    t = 0.0
    for m in s['marcos']:
        if m['status'] == 'feito':
            t += m['peso']
        elif m['status'] in ('em_andamento', 'bloqueado'):
            t += m['peso'] * float(m.get('fracao') or 0)
    return round(t, 1)


def atual(s):
    for m in s['marcos']:
        if m['status'] != 'feito':
            return m
    return None


def save(s):
    s['atualizado_em'] = now()
    s['porcentagem'] = pct(s)
    a = atual(s)
    s['marco_atual'] = a['id'] if a else 'concluído'
    SJ.write_text(json.dumps(s, ensure_ascii=False, indent=2))
    (ROOT / 'dashboard').mkdir(exist_ok=True)
    (ROOT / 'dashboard' / 'status.json').write_text(json.dumps(s, ensure_ascii=False, indent=2))
    render_status_md(s)
    render_dashboard(s)


def render_status_md(s):
    a = atual(s)
    L = [f"# STATUS — {s['projeto']}", '',
         f"- **Distro:** {s.get('distro')}",
         f"- **Livro:** {s['livro']}",
         f"- **Marco atual:** {a['id'] + ' — ' + a['nome'] if a else 'todos concluídos'}",
         f"- **Progresso:** {s['porcentagem']}%",
         f"- **Último passo concluído:** {s.get('ultimo_passo') or '-'}",
         f"- **Próximo passo:** {s.get('proximo_passo') or '-'}",
         f"- **Bloqueios:** {s.get('bloqueios') or 'nenhum'}",
         f"- **Atualizado em:** {s['atualizado_em']}", '']
    ex = s.get('extra') or {}
    if ex:
        L += ['## Informações', '']
        for k, v in ex.items():
            L.append(f'- **{k}:** {v}')
        L.append('')
    L += ['## Marcos', '', '| ID | Marco | Peso | Status | Concluído em |', '|---|---|---|---|---|']
    for m in s['marcos']:
        st = LABEL[m['status']]
        if m['status'] == 'em_andamento' and m.get('fracao'):
            st += f" ({int(m['fracao'] * 100)}%)"
        L.append(f"| [{m['id']}](historias/{m['id']}.md) | {m['nome']} | {m['peso']} | {st} | {m.get('concluido_em') or ''} |")
    (ROOT / 'STATUS.md').write_text('\n'.join(L) + '\n')


DASH = r'''<!-- gerado por scripts/status.py: não editar à mão -->
<title>Sagui Linux — painel</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
:root{--bg:#f6f7f9;--card:#fff;--fg:#1d2330;--mut:#667085;--line:#e4e7ec;--acc:#009c3b;
--ok:#15803d;--okbg:#dcfce7;--run:#b45309;--runbg:#fef3c7;--blk:#b91c1c;--blkbg:#fee2e2;--todo:#475467;--todobg:#eef0f3}
@media (prefers-color-scheme:dark){:root:not([data-theme=light]){color-scheme:dark;--bg:#0f1218;--card:#171b23;--fg:#e6e9ef;--mut:#98a2b3;--line:#2a303c;--acc:#3ddc84;
--ok:#4ade80;--okbg:#12301f;--run:#fbbf24;--runbg:#3a2a08;--blk:#f87171;--blkbg:#3b1414;--todo:#98a2b3;--todobg:#222834}}
:root[data-theme=dark]{color-scheme:dark;--bg:#0f1218;--card:#171b23;--fg:#e6e9ef;--mut:#98a2b3;--line:#2a303c;--acc:#3ddc84;
--ok:#4ade80;--okbg:#12301f;--run:#fbbf24;--runbg:#3a2a08;--blk:#f87171;--blkbg:#3b1414;--todo:#98a2b3;--todobg:#222834}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);font:14px/1.5 system-ui,-apple-system,Segoe UI,Roboto,sans-serif;padding:24px 16px}
main{max-width:1100px;margin:0 auto}
h1{font-size:22px;margin:0 0 4px}h2{font-size:15px;margin:0 0 12px;color:var(--mut);font-weight:600;text-transform:uppercase;letter-spacing:.04em}
.sub{color:var(--mut);margin-bottom:20px}
.card{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:16px;margin-bottom:16px}
.big{display:flex;align-items:baseline;gap:12px;flex-wrap:wrap}.big b{font-size:40px;font-variant-numeric:tabular-nums}
.bar{height:14px;background:var(--todobg);border-radius:7px;overflow:hidden;margin-top:10px}.bar i{display:block;height:100%;background:var(--acc)}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}@media (max-width:760px){.grid{grid-template-columns:1fr}}
table{width:100%;border-collapse:collapse}td,th{padding:7px 6px;border-bottom:1px solid var(--line);text-align:left;vertical-align:top}
th{color:var(--mut);font-weight:600;font-size:12px}.num{text-align:right;font-variant-numeric:tabular-nums}
.pill{display:inline-block;padding:1px 9px;border-radius:999px;font-size:12px;font-weight:600;white-space:nowrap}
.feito{color:var(--ok);background:var(--okbg)}.em_andamento{color:var(--run);background:var(--runbg)}.bloqueado{color:var(--blk);background:var(--blkbg)}.a_fazer{color:var(--todo);background:var(--todobg)}
.mini{height:6px;background:var(--todobg);border-radius:3px;overflow:hidden;width:80px;display:inline-block;vertical-align:middle;margin-left:6px}.mini i{display:block;height:100%;background:var(--run)}
ul{list-style:none;margin:0;padding:0}li{padding:7px 0;border-bottom:1px solid var(--line)}li:last-child{border:0}
.t{color:var(--mut);font-size:12px;font-variant-numeric:tabular-nums}.k{font-weight:600}
.next{border-left:4px solid var(--acc)}.blk{border-left:4px solid var(--blk)}
.scroll{max-height:420px;overflow:auto}
.hero{display:flex;align-items:center;gap:16px;padding:18px;border-radius:12px;margin-bottom:16px;background-size:cover;background-position:center;color:#fff;flex-wrap:wrap}
.hero h1{color:#fff;text-shadow:0 1px 3px #0008}.hero .sub{color:#e8f5e9;margin:0;text-shadow:0 1px 3px #0008}
.logo{width:72px;height:72px;border-radius:16px}.mascote{width:96px;height:96px;margin-left:auto;background:#fffd;border-radius:50%;padding:4px}.tw{overflow-x:auto}
</style>
<main>
<div class="hero" style="background-image:url(__WALL__)"><img class="logo" src="__LOGO__" alt="logo Sagui Linux"><div><h1 id="proj"></h1><div class="sub" id="sub"></div></div><img class="mascote" src="__MASCOTE__" alt="mascote sagui"></div>
<div class="card"><div class="big"><b id="pct"></b><span id="cur"></span></div><div class="bar"><i id="barfill"></i></div></div>
<div class="card next"><h2>Próximo passo</h2><div id="next"></div></div>
<div class="card blk" id="blkcard" hidden><h2>Bloqueios</h2><div id="blk"></div></div>
<div class="card"><h2>Marcos</h2><div class="tw"><table><thead><tr><th>ID</th><th>Marco</th><th class="num">Peso</th><th>Status</th><th>Concluído em</th></tr></thead><tbody id="marcos"></tbody></table></div></div>
<div class="grid">
<div class="card"><h2>Últimas ações</h2><ul class="scroll" id="acoes"></ul></div>
<div class="card"><h2>Erros e correções recentes</h2><ul class="scroll" id="erros"></ul></div>
</div>
</main>
<script id="embedded" type="application/json">__DATA__</script>
<script>
const L={a_fazer:'a fazer',em_andamento:'em andamento',feito:'feito',bloqueado:'bloqueado'};
const esc=s=>String(s??'').replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
function draw(s){
 document.getElementById('proj').textContent=s.projeto+(s.distro&&s.distro!=='a definir'?' — '+s.distro:'');
 document.getElementById('sub').textContent=s.livro+' · última atualização: '+s.atualizado_em;
 document.getElementById('pct').textContent=s.porcentagem+'%';
 document.getElementById('cur').textContent='marco atual: '+s.marco_atual;
 document.getElementById('barfill').style.width=Math.min(100,s.porcentagem)+'%';
 document.getElementById('next').textContent=s.proximo_passo||'-';
 const bc=document.getElementById('blkcard');bc.hidden=!s.bloqueios;document.getElementById('blk').textContent=s.bloqueios||'';
 document.getElementById('marcos').innerHTML=s.marcos.map(m=>`<tr><td class="k">${m.id}</td><td>${esc(m.nome)}</td><td class="num">${m.peso}</td><td><span class="pill ${m.status}">${L[m.status]}</span>${m.status==='em_andamento'&&m.fracao?`<span class="mini"><i style="width:${Math.round(m.fracao*100)}%"></i></span>`:''}</td><td class="t">${esc(m.concluido_em||'')}</td></tr>`).join('');
 document.getElementById('acoes').innerHTML=s.acoes.slice(-40).reverse().map(a=>`<li><div class="t">${esc(a.data)} · ${esc(a.marco)}</div>${esc(a.texto)}<div class="t">${esc(a.resultado)}</div></li>`).join('')||'<li>-</li>';
 document.getElementById('erros').innerHTML=s.erros.slice(-25).reverse().map(e=>`<li><div class="t">${esc(e.data)} · ${esc(e.marco)} · ${esc(e.pacote)} · tentativas: ${esc(e.tentativas)}</div><div><span class="k">Sintoma:</span> ${esc(e.sintoma)}</div><div><span class="k">Causa:</span> ${esc(e.causa)}</div><div><span class="k">Correção:</span> ${esc(e.correcao)}</div></li>`).join('')||'<li>nenhum erro registrado</li>';
}
let data=JSON.parse(document.getElementById('embedded').textContent);draw(data);
fetch('status.json',{cache:'no-store'}).then(r=>r.json()).then(d=>{if(d.atualizado_em>=data.atualizado_em)draw(d)}).catch(()=>{});
</script>
'''


def render_dashboard(s):
    import base64
    data = json.dumps(s, ensure_ascii=False).replace('</', '<\\/')
    def uri(nome, mime):
        f = ROOT / 'arte' / nome
        return f'data:{mime};base64,' + base64.b64encode(f.read_bytes()).decode() if f.exists() else ''
    h = DASH.replace('__DATA__', data).replace('__LOGO__', uri('logo-sagui-256.png', 'image/png'))
    h = h.replace('__WALL__', uri('wallpaper-thumb.jpg', 'image/jpeg')).replace('__MASCOTE__', uri('mascote-sagui-256.png', 'image/png'))
    (ROOT / 'dashboard' / 'index.html').write_text('<!doctype html>\n<html lang="pt-BR">\n' + h + '</html>\n')


def main():
    s = load()
    a = sys.argv[1:]
    cmd = a[0] if a else 'render'
    if cmd == 'marco':
        mid, st = a[1], a[2]
        for m in s['marcos']:
            if m['id'] == mid:
                if m['status'] == 'feito' and st == 'em_andamento':
                    break  # refazer um passo (ex.: nova ISO) não rebaixa um marco concluído
                m['status'] = st
                if len(a) > 3:
                    m['fracao'] = float(a[3])
                if st == 'feito':
                    m['fracao'] = 1.0
                    m['concluido_em'] = now()
        hist = ROOT / 'historias' / f'{mid}.md'
        cur = next((m['status'] for m in s['marcos'] if m['id'] == mid), st)
        if hist.exists() and cur == st:
            t = hist.read_text().splitlines()
            for i, ln in enumerate(t):
                if ln.startswith('- **Status:**'):
                    t[i] = f'- **Status:** {LABEL[st]}'
                if ln.startswith('- **Data de conclusão:**') and st == 'feito':
                    t[i] = f'- **Data de conclusão:** {now()}'
            hist.write_text('\n'.join(t) + '\n')
    elif cmd == 'diario':
        mid, txt, res = a[1], a[2], a[3]
        s['acoes'].append({'data': now(), 'marco': mid, 'texto': txt, 'resultado': res})
        s['acoes'] = s['acoes'][-300:]
        s['ultimo_passo'] = f'{mid}: {txt}'
        d = ROOT / 'docs' / 'diario.md'
        if not d.exists():
            d.write_text('# Diário\n\nLog cronológico: data e hora | marco | o que foi feito | resultado\n\n')
        with open(d, 'a') as f:
            f.write(f'- {now()} | {mid} | {txt} | {res}\n')
    elif cmd == 'erro':
        mid, pac, sint, causa, corr, tent = a[1:7]
        s['erros'].append({'data': now(), 'marco': mid, 'pacote': pac, 'sintoma': sint, 'causa': causa, 'correcao': corr, 'tentativas': tent})
        d = ROOT / 'docs' / 'erros.md'
        if not d.exists():
            d.write_text('# Erros e ciclos de correção\n\n')
        n = sum(1 for _ in s['erros'])
        with open(d, 'a') as f:
            f.write(f'## E{n:02d} — {pac} ({mid}) — {now()}\n\n- **Sintoma:** `{sint}`\n- **Causa:** {causa}\n- **Correção aplicada:** {corr}\n- **Tentativas:** {tent}\n\n')
    elif cmd == 'proximo':
        s['proximo_passo'] = a[1]
    elif cmd == 'bloqueio':
        s['bloqueios'] = a[1]
    elif cmd == 'campo':
        s.setdefault('extra', {})[a[1]] = a[2]
        if a[1] == 'distro':
            s['distro'] = a[2]
    save(s)


if __name__ == '__main__':
    main()
