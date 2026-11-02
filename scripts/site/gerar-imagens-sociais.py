#!/usr/bin/env python3
"""Gera as imagens de divulgação (X/Twitter 1600x900 e LinkedIn 1200x1200) com a captura real do desktop."""
import subprocess
from PIL import Image, ImageDraw, ImageFont, ImageFilter
R = '/home/erigobeli/distro-ai/'
OUT = R + 'divulgacao/'
B = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
N = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
VERDE, AMARELO, AZUL, BRANCO = (0, 156, 59), (255, 223, 0), (0, 39, 118), (255, 255, 255)
AZUL_ESC = (6, 18, 52)

def fonte(p, t): return ImageFont.truetype(p, t)

def dupla(altura, contorno=7):
    # Tux (Larry Ewing, feito no GIMP) + mascote sagui, com contorno branco para destacar no fundo azul
    im = Image.open(R + 'arte-extra/tux-e-sagui.png').convert('RGBA')
    im = im.resize((int(im.width * altura / im.height), altura), Image.LANCZOS)
    pad = contorno * 2
    base = Image.new('RGBA', (im.width + 2 * pad, im.height + 2 * pad), (0, 0, 0, 0))
    base.alpha_composite(im, (pad, pad))
    a = base.getchannel('A').filter(ImageFilter.MaxFilter(contorno * 2 + 1))
    contornado = Image.new('RGBA', base.size, (255, 255, 255, 0)); contornado.putalpha(a)
    sombra = Image.new('RGBA', base.size, (0, 0, 0, 0)); sombra.putalpha(a.point(lambda v: v * 0.45))
    sombra = sombra.filter(ImageFilter.GaussianBlur(10))
    out = Image.new('RGBA', (base.width + 20, base.height + 20), (0, 0, 0, 0))
    out.alpha_composite(sombra, (14, 18)); out.alpha_composite(contornado, (0, 0)); out.alpha_composite(base, (0, 0))
    return out

def logo(px):
    subprocess.run(['rsvg-convert', '-w', str(px), '-h', str(px), R + 'blfs/arte/logo-sagui.svg', '-o', '/tmp/claude-1000/logo-soc.png'], check=True)
    return Image.open('/tmp/claude-1000/logo-soc.png').convert('RGBA')

def captura(largura):
    im = Image.open(R + 'blfs/logs/testes/bios-cdrom-desktop.png').convert('RGB')
    h = int(im.height * largura / im.width)
    im = im.resize((largura, h), Image.LANCZOS)
    # moldura de "janela" com sombra
    pad = 10
    fr = Image.new('RGBA', (largura + 2 * pad, h + 2 * pad + 28), (0, 0, 0, 0))
    d = ImageDraw.Draw(fr)
    d.rounded_rectangle([0, 0, fr.width - 1, fr.height - 1], 14, fill=(235, 238, 236, 255))
    for i, c in enumerate([(230, 80, 70), (240, 190, 50), (70, 180, 90)]):
        d.ellipse([16 + i * 22, 10, 28 + i * 22, 22], fill=c)
    fr.paste(im, (pad, 28 + pad))
    sombra = Image.new('RGBA', (fr.width + 60, fr.height + 60), (0, 0, 0, 0))
    ImageDraw.Draw(sombra).rounded_rectangle([30, 40, fr.width + 30, fr.height + 40], 16, fill=(0, 0, 0, 150))
    sombra = sombra.filter(ImageFilter.GaussianBlur(18))
    sombra.alpha_composite(fr, (30, 30))
    return sombra

def fundo(w, h):
    bg = Image.new('RGB', (w, h), AZUL_ESC)
    d = ImageDraw.Draw(bg)
    for y in range(h):  # gradiente azul
        t = y / h
        d.line([(0, y), (w, y)], fill=(int(6 + 4 * t), int(18 + 30 * t), int(52 + 40 * t)))
    # faixa Brasil
    d.rectangle([0, h - 14, int(w * .6), h], fill=VERDE)
    d.rectangle([int(w * .6), h - 14, int(w * .8), h], fill=AMARELO)
    d.rectangle([int(w * .8), h - 14, w, h], fill=(40, 90, 200))
    return bg

def texto_quebrado(d, xy, txt, f, larg, cor, entre=1.15):
    x, y = xy; linha = ''
    for pal in txt.split():
        t = (linha + ' ' + pal).strip()
        if d.textlength(t, font=f) <= larg: linha = t
        else:
            d.text((x, y), linha, font=f, fill=cor); y += int(f.size * entre); linha = pal
    if linha: d.text((x, y), linha, font=f, fill=cor); y += int(f.size * entre)
    return y

def selo(d, xy, txt, f):
    x, y = xy
    w = d.textlength(txt, font=f) + 36
    d.rounded_rectangle([x, y, x + w, y + f.size + 22], (f.size + 22) // 2, fill=AZUL, outline=AMARELO, width=3)
    d.text((x + 18, y + 10), txt, font=f, fill=BRANCO)
    return y + f.size + 22

# ---------- X / Twitter 1600x900 ----------
W, H = 1600, 900
im = fundo(W, H); d = ImageDraw.Draw(im)
cap = captura(860)
cx, cy = W - cap.width + 20, 40
im.paste(cap, (cx, cy), cap)
du = dupla(320); im.paste(du, (cx + 10, H - du.height - 8), du)
lg = logo(110); im.paste(lg, (70, 70), lg)
d.text((200, 92), 'Sagui Linux', font=fonte(B, 52), fill=BRANCO)
y = selo(d, (70, 215), 'Claude Opus 5.5 · LFS + BLFS', fonte(B, 26)) + 30
y = texto_quebrado(d, (70, y), 'A DISTRIBUIÇÃO LINUX', fonte(B, 48), 640, BRANCO, 1.12)
y = texto_quebrado(d, (70, y), 'CRIADA 100% POR IA', fonte(B, 48), 640, AMARELO, 1.12) + 22
y = texto_quebrado(d, (70, y), 'Compilada do zero a partir do código-fonte, com desktop XFCE e Firefox. Nenhuma linha de código escrita por humanos.', fonte(N, 27), 560, (215, 228, 240), 1.35)
im.save(OUT + 'x-twitter-1600x900.png')

# ---------- LinkedIn 1200x1200 ----------
W, H = 1200, 1200
im = fundo(W, H); d = ImageDraw.Draw(im)
lg = logo(96); im.paste(lg, (70, 64), lg)
d.text((184, 72), 'Sagui Linux', font=fonte(B, 46), fill=BRANCO)
d.text((186, 128), 'Projeto educacional · código aberto', font=fonte(N, 24), fill=(190, 205, 225))
y = 210
y = texto_quebrado(d, (70, y), 'A DISTRIBUIÇÃO LINUX', fonte(B, 66), 1060, BRANCO, 1.08)
y = texto_quebrado(d, (70, y), 'CRIADA 100% POR IA', fonte(B, 66), 1060, AMARELO, 1.08) + 6
cap = captura(900)
im.paste(cap, ((W - cap.width) // 2 - 60, y - 10), cap)
y2 = y - 10 + cap.height + 10
du = dupla(330); im.paste(du, (W - du.width - 20, H - du.height - 6), du)
f = fonte(B, 26)
itens = ['LFS 12.4 + BLFS 12.4', 'Claude Opus 5.5']
xs = 70
for t in itens:
    w = d.textlength(t, font=f) + 34
    d.rounded_rectangle([70, y2, 70 + w, y2 + 52], 26, fill=AZUL, outline=VERDE, width=3)
    d.text((70 + 17, y2 + 11), t, font=f, fill=BRANCO)
    y2 += 64
im.save(OUT + 'linkedin-1200x1200.png')
print('ok')
