# Como gravar e usar o Sagui Linux 2.0

Arquivo: `sagui-linux-2.0-x86_64.iso` (~840 MB). ISO **híbrida**: dá boot como CD/DVD numa máquina virtual e pode ser gravada byte a byte num pendrive. Funciona em PCs com BIOS (Legacy/CSM) e com UEFI.

- Liga direto no **desktop XFCE** com o usuário `sagui` (sem tela de senha).
- Senhas: usuário **sagui / sagui** (tem `sudo` sem senha) · **root / sagui**.
- Teclado ABNT2 já configurado. Rede cabeada (DHCP) funciona sozinha.
- Programas: Firefox, Terminal, Thunar (arquivos), Mousepad (editor), Ristretto (imagens).
- É um sistema **live**: tudo fica na memória RAM e some ao desligar. Para instalar no disco: `sudo instalar-no-disco /dev/sdX` no terminal (apaga o disco escolhido).

> Gravar no pendrive **apaga tudo** que estiver nele. Use um pendrive de **2 GB ou mais**.

## 1. Conferir o arquivo (SHA-256)

O `sagui-linux-2.0-x86_64.iso.sha256`, ao lado da ISO, traz o hash esperado.

- **Windows (PowerShell):** `Get-FileHash .\sagui-linux-2.0-x86_64.iso -Algorithm SHA256`
- **Linux/macOS:** `sha256sum -c sagui-linux-2.0-x86_64.iso.sha256`

Se o hash não bater, baixe de novo (no FTP, modo **binário**).

## 2. Gravar no pendrive

### balenaEtcher (recomendado — foi o que funcionou no notebook do Eli na Fase 1)
1. **Flash from file** → escolha a ISO.
2. **Select target** → escolha o pendrive.
3. **Flash!** e espere a verificação terminar.
4. Se o Windows disser que o pendrive "precisa ser formatado", clique em **Cancelar** (é normal).

### Rufus (Windows)
Selecione a ISO, clique em **INICIAR** e, quando perguntar o modo, escolha **"Gravar no modo Imagem DD"**. O modo ISO (padrão) **não funciona** com esta ISO — provavelmente foi o que falhou no primeiro teste da Fase 1.

### dd (Linux)
```bash
lsblk                                   # descubra o pendrive, ex.: /dev/sdX
sudo dd if=sagui-linux-2.0-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## 3. Testar numa máquina virtual (opcional)

- **VirtualBox:** Tipo Linux / Other Linux (64-bit), **4 GB de RAM**, 2 CPUs, Vídeo **VMSVGA** com 64 MB+; em Armazenamento coloque a ISO no drive óptico. Para UEFI marque Sistema → Habilitar EFI.
- **QEMU:** `qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 -vga std -cdrom sagui-linux-2.0-x86_64.iso`

## 4. Preparar o PC e dar boot

1. **Secure Boot desligado** no firmware (F2/Del/F10/Esc ao ligar → Security/Boot → Secure Boot → Disabled). A ISO não é assinada.
2. Abra o **menu de boot** (Dell F12, HP F9, Lenovo F12, Acer F12, ASUS F8/Esc, Positivo F7/F12, Samsung F10) e escolha o pendrive (em UEFI aparece como "UEFI: <pendrive>").
3. Menu do GRUB (fundo com o logo do Sagui):

| Entrada | Para quê |
|---|---|
| **Sagui Linux 2.0 (XFCE)** | normal (padrão, em 8 s) |
| (XFCE, console serial ttyS0) | testes em VM sem tela |
| **(modo seguro de vídeo)** | se a tela ficar preta: usa `nomodeset` (vídeo genérico) |
| (modo texto) | só terminal, sem interface gráfica |

4. O desktop aparece em ~30 s a 1 min (mais lento pelo pendrive USB 2.0).

## 5. Problemas comuns

| Sintoma | O que fazer |
|---|---|
| Pendrive não aparece no menu de boot | Regrave com o balenaEtcher; outra porta USB; desligue o Secure Boot; ative "USB boot". |
| Tela preta depois do GRUB | Use **modo seguro de vídeo**. Placas AMD/Radeon usam vídeo genérico nesta versão (sem firmware AMD). |
| Ficou num terminal escrito "A sessão gráfica terminou" | Digite `startx`. O log fica em `~/.cache/xsession.log`. |
| Sem internet | Só rede **cabeada** (DHCP automático). Wi-Fi ainda não é suportado. Confira com `ip -br addr`. |
| Desligar | Menu Sagui → Sair → Desligar, ou `sudo poweroff` no terminal. |
| Firefox aparece como "Nightly" | Normal: é o Firefox ESR compilado do código-fonte sem a marca registrada da Mozilla (exigência para poder distribuir). |

## 6. Confirmar o teste (Eli)

Depois de testar numa VM e numa máquina real:

```bash
cd ~/distro-ai/blfs
bash scripts/confirmar-hardware.sh "VM: ... ok; Real: notebook ..., pendrive via balenaEtcher, desktop ok"
```

Isso fecha o B13 e deixa o dashboard em 100%.
