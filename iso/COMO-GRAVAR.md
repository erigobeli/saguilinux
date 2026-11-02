# Como gravar e dar boot no Semente Linux 1.0

Arquivo: `semente-linux-1.0-x86_64.iso` (295 MB). É uma ISO **híbrida**: dá boot como CD/DVD numa máquina virtual e também pode ser gravada byte a byte num pendrive. Funciona em PCs com BIOS (Legacy/CSM) e com UEFI.

- Login: **root**
- Senha: **semente**
- Teclado: ABNT2 (`br-abnt2`). Para trocar para o americano: `loadkeys us`.
- É um sistema **live**: tudo que você grava fica na memória RAM e se perde ao desligar.

> Atenção: gravar no pendrive **apaga tudo** que estiver nele.

## 1. Conferir o arquivo baixado (SHA-256)

O arquivo `semente-linux-1.0-x86_64.iso.sha256`, ao lado da ISO, traz o hash esperado.

- **Windows (PowerShell):**
  ```powershell
  Get-FileHash .\semente-linux-1.0-x86_64.iso -Algorithm SHA256
  ```
- **Linux / macOS:**
  ```bash
  sha256sum -c semente-linux-1.0-x86_64.iso.sha256     # macOS: shasum -a 256 -c ...
  ```

O hash mostrado precisa ser igual ao que está no `.sha256`. Se for diferente, baixe de novo (no FTP, use o modo **binário**).

## 2. Testar numa máquina virtual (opcional, recomendado)

### VirtualBox
1. Novo → Tipo **Linux**, Versão **Other Linux (64-bit)**, 2 GB de RAM, sem disco (ou com qualquer disco).
2. Configurações → Armazenamento → no controlador IDE/SATA, escolha o drive óptico e selecione a ISO.
3. Para testar o modo UEFI: Configurações → Sistema → marque **Habilitar EFI**.
4. Inicie a VM. No menu do GRUB, Enter (ou espere 5 s) → aparece `semente login:` → `root` / `semente`.

### QEMU (Linux)
```bash
qemu-system-x86_64 -m 2048 -enable-kvm -cdrom semente-linux-1.0-x86_64.iso               # BIOS
qemu-system-x86_64 -m 2048 -enable-kvm -bios /usr/share/ovmf/OVMF.fd -cdrom semente-linux-1.0-x86_64.iso   # UEFI
```

## 3. Gravar no pendrive

Qualquer pendrive a partir de 512 MB serve.

### Rufus (Windows) — use o modo DD
1. Abra o Rufus e escolha o pendrive em **Dispositivo**.
2. Em **Seleção de boot**, clique em **SELECIONAR** e escolha a ISO.
3. Clique em **INICIAR**. O Rufus vai perguntar o modo de gravação: escolha **"Gravar no modo Imagem DD"** (não use o modo ISO, que copia arquivos e quebra o boot desta ISO).
4. Confirme que os dados do pendrive serão apagados e espere terminar.

### balenaEtcher (Windows, macOS, Linux)
1. **Flash from file** → escolha a ISO.
2. **Select target** → escolha o pendrive.
3. **Flash!** O Etcher sempre grava byte a byte, não há opção a escolher. Se o Windows disser depois que o pendrive "precisa ser formatado", clique em **Cancelar**: é normal, o Windows não entende o sistema de arquivos ISO.

### dd (Linux)
```bash
lsblk                                      # descubra o pendrive, por exemplo /dev/sdX
sudo dd if=semente-linux-1.0-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```
Use o **disco inteiro** (`/dev/sdX`), não uma partição (`/dev/sdX1`). Errar o dispositivo apaga outro disco.

## 4. Preparar o PC (firmware/BIOS)

1. **Secure Boot desligado.** A ISO não é assinada (Secure Boot está fora do escopo da Fase 1). Entre no setup do firmware (normalmente **F2**, **Del**, **F10** ou **Esc** ao ligar), procure **Security → Secure Boot** (ou Boot → Secure Boot) e coloque em **Disabled**. Salve e saia.
2. Se o PC só tiver modo Legacy/CSM, também funciona: a ISO tem boot BIOS.

## 5. Dar boot pelo pendrive

1. Com o pendrive conectado, ligue o PC e abra o **menu de boot** (tecla comum por fabricante):

   | Fabricante | Tecla do menu de boot |
   |---|---|
   | Dell | F12 |
   | HP | F9 (ou Esc → F9) |
   | Lenovo | F12 (ou o botão Novo) |
   | Acer | F12 |
   | ASUS | F8 (desktops) / Esc (notebooks) |
   | Gigabyte / MSI / ASRock | F12 / F11 / F11 |
   | Samsung, Positivo | F10 / F7 ou F12 |

2. Escolha a entrada do pendrive. Em PCs UEFI ela costuma aparecer como **"UEFI: <nome do pendrive>"**; prefira essa.
3. No menu do GRUB:
   - **Semente Linux 1.0 (live)**: boot normal (padrão, em 5 s).
   - **Semente Linux 1.0 (live, console serial ttyS0)**: igual, mas também abre login na porta serial (para testes em VM sem tela).
   - **Reiniciar** / **Desligar**.
4. Em cerca de 30 s aparece `semente login:`. Entre com **root** / **semente**.
5. Para desligar: `poweroff`. Para reiniciar: `reboot`.

## 6. Problemas comuns

| Sintoma | O que fazer |
|---|---|
| O pendrive não aparece no menu de boot | Grave de novo no modo **DD**; teste outra porta USB (prefira USB 2.0 traseira); em UEFI, desligue o Secure Boot; ative "USB boot" no firmware. |
| "Secure Boot violation" / "Invalid signature" | Desligue o Secure Boot (passo 4). |
| `[live] ERRO: mídia SEMENTE_LIVE não encontrada` e um shell | O kernel não enxergou o pendrive em 60 s. Tente outra porta USB e regrave a ISO. No shell, `ls /dev` mostra os discos detectados. |
| Tela preta depois do GRUB (UEFI) | Espere 1 minuto (o primeiro boot pelo USB pode demorar). Se continuar, ative o modo Legacy/CSM no firmware e dê boot pela entrada do pendrive sem "UEFI:". Anote o modelo da placa de vídeo para o agente investigar. |
| Teclado com acentos/símbolos trocados | `loadkeys us` (teclado americano) ou `loadkeys br-abnt2`. |
| Sem rede | Esperado nesta fase: o LFS não traz cliente DHCP (fica para a Fase 2). Rede manual: `ip link set enp0s3 up; ip addr add 192.168.0.50/24 dev enp0s3; ip route add default via 192.168.0.1` (ajuste nomes e endereços; `ip link` lista as placas). |

## 7. Confirmar o teste (Eli)

Depois de testar numa VM local e numa máquina real pelo pendrive, registre o resultado no servidor:

```bash
cd ~/distro-ai
bash scripts/confirmar-hardware.sh "VM: VirtualBox 7 UEFI ok; Real: notebook X, pendrive via Rufus DD, UEFI ok"
```

Isso fecha o H13 e deixa o dashboard em 100%. Se algo falhar, anote o sintoma e a foto da tela; o agente corrige na próxima rodada.
