# Sagui Linux 2.0 — resumo da Fase 2

Terminei. O **Sagui Linux 2.0** liga direto no desktop XFCE, com o Firefox e as cores do Brasil, e passou nos três testes em QEMU: BIOS, UEFI e pendrive USB. Falta só o seu teste em hardware real.

## Entrega
- ISO: `~/distro-ai/blfs/iso/sagui-linux-2.0-x86_64.iso` (841 MB), SHA-256 no arquivo `.sha256` ao lado (`09d5d8cb…f634`).
- Guia: `blfs/iso/COMO-GRAVAR.md`. Recomenda o balenaEtcher, que funcionou no seu notebook; no Rufus, só no modo Imagem DD.
- Senhas: usuário `sagui` / `sagui` (entra sozinho no XFCE) e `root` / `sagui`.

## O que tem
- XFCE 4.20 completo: painel, Thunar, Terminal, Mousepad, Ristretto, notificações, som (PulseAudio) e gerenciamento de energia.
- Firefox ESR 140, que abre numa página de boas-vindas com o mascote. Aparece com o nome "Nightly", porque o livro proíbe distribuir o binário com a marca oficial.
- Rede cabeada com DHCP automático (dhcpcd): pegou IP nos três testes.
- Teclado ABNT2 e interface em português.

## Arte (Higgsfield)
- Gerei mascote, logo e wallpaper com cerca de 18 créditos (5 imagens; o logo precisou de uma segunda tentativa).
- Onde aparece:
  - Wallpaper do desktop.
  - Botão "Sagui" no painel.
  - Fundo do menu do GRUB.
  - Logo no boot do kernel, no lugar do pinguim.
  - `/etc/issue` em ASCII colorido.
- Painel azul, seleção verde e destaque amarelo.
- As capturas de tela dos testes estão em `blfs/logs/testes/*.png`.

## Limitações desta versão
- Sem Wi-Fi.
- Placas AMD/Radeon e GPUs Intel mais novas usam vídeo por software. Funciona, mas sem aceleração.
- O Firefox fica em inglês e mostra um aviso sobre o sandbox; funciona normalmente.

## Acompanhamento
- 18 ciclos de correção em `blfs/docs/erros.md`. O mais importante: o desktop não abria porque eu tinha sobrescrito um arquivo de configuração padrão do XFCE. Corrigi e testei de novo.
- Decisões em `blfs/docs/decisoes.md`, diário em `blfs/docs/diario.md`.
- Dashboard (com a arte embutida) em `blfs/dashboard/index.html`, mostrando 99%.

## Para fechar (100%)
Depois de testar numa VM e numa máquina real:

```
cd ~/distro-ai/blfs
bash scripts/confirmar-hardware.sh "VM ok; notebook ok"
```

Se aparecer tela preta, use a entrada "modo seguro de vídeo" do GRUB e me diga o modelo da máquina.
