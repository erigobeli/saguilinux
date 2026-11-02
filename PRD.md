# PRD: Distro Linux do Zero feita por IA

Documento de requisitos para o agente (Claude Code) construir, de forma autônoma, uma distribuição Linux a partir do Linux From Scratch (LFS), entregando uma ISO bootável em VM e em pendrive. Nome da distro: a definir.

## 1. Objetivo

Construir do zero um sistema Linux funcional seguindo o livro LFS e empacotá-lo como uma ISO live híbrida (BIOS e UEFI) que:

1. Dê boot numa máquina virtual (QEMU/KVM, VirtualBox).
2. Dê boot em hardware real a partir de um pendrive gravado com o Rufus (modo DD) ou balenaEtcher.
3. Inicie em modo texto, com login no terminal.

O agente trabalha sozinho: baixa o livro, lê, executa, corrige erros lendo os logs e documenta cada passo. O Eli apenas acompanha pela documentação e pelo dashboard.

## 2. Escopo

### Fase 1 (este PRD)

LFS puro, somente terminal, empacotado em ISO live bootável. Sem interface gráfica.

### Fase 2 (futura, fora deste PRD)

BLFS com Xorg e XFCE, gerando uma nova ISO. O agente deve deixar a Fase 1 organizada para que a Fase 2 parta dela, mas não deve iniciá-la sem autorização.

### Fora do escopo

Instalador gráfico, gerenciador de pacotes, Secure Boot assinado.

## 3. Ambiente

- Host: VPS Hostinger KVM 8, acesso via SSH com um usuário comum que tem sudo sem senha (NOPASSWD). O agente usa sudo nos passos que exigem root.
- Sessão: tudo roda dentro do tmux (sessão `distro`), para sobreviver a quedas de conexão.
- Diretório raiz do projeto: `~/distro`-ai.
- Diretório do sistema alvo: `LFS=/mnt/lfs` (diretório no próprio disco da VPS, sem partição dedicada).
- Usuário de build: criar o usuário `lfs` conforme o livro para as etapas de toolchain.
- Paralelismo: `MAKEFLAGS=-j$(nproc)`.
- Arquitetura alvo: x86\_64.

### Pré-requisito: sudo sem senha

O Eli configura isso uma única vez, no próprio terminal, antes de iniciar o agente. A senha nunca deve ir para o PRD, scripts, logs ou prompts.

```bash
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/distro
sudo chmod 440 /etc/sudoers.d/distro
```

Primeira ação do agente, antes de qualquer outra: rodar `sudo -n true`. Se falhar, não tentar contornar nem pedir a senha no chat; registrar `bloqueado` no `STATUS.md` com a instrução acima e parar até o Eli liberar.

### Estrutura de diretórios

```
~/distro-ai/
  PRD.md              cópia deste documento
  STATUS.md           resumo do andamento
  status.json         fonte de dados do dashboard
  historias/          uma história por marco (H01.md, H02.md...)
  docs/
    diario.md         log cronológico de tudo que foi feito
    decisoes.md       decisões técnicas e justificativas
    erros.md          cada erro, causa e correção (ciclos de correção)
  livro/              livro LFS baixado (HTML) e wget-list, md5sums
  sources/            tarballs e patches
  scripts/            scripts por capítulo/etapa, idempotentes
  logs/               saída completa de cada build (um arquivo por pacote)
  iso/                staging e ISO final
  dashboard/
    index.html        painel de acompanhamento
    status.json       cópia para o painel ler
```

## 4. Fontes

1. Baixar a versão estável mais recente do livro LFS em HTML (variante SysVinit, mais simples para live boot), além de `wget-list` e `md5sums` da mesma versão.
2. Registrar a versão exata em `docs/decisoes.md`.
3. Baixar todos os pacotes e patches em `sources/` e validar os checksums. Se algum espelho falhar, buscar espelho alternativo e registrar.
4. O livro local é a referência. Não improvisar versões diferentes das indicadas, salvo para corrigir erro documentado.

## 5. Marcos (histórias)

Cada marco vira um arquivo em `historias/` com: objetivo, passos, critério de aceite, status (`a fazer`, `em andamento`, `feito`, `bloqueado`), data de conclusão e link para os logs.

| ID | Marco | Peso |
| --- | --- | --- |
| H01 | Preparar host: verificar requisitos do host (script do livro), instalar ferramentas que faltarem, criar estrutura de diretórios e tmux | 3 |
| H02 | Baixar livro, pacotes e patches; validar checksums | 3 |
| H03 | Preparar `$LFS`, usuário `lfs`, ambiente (`.bashrc`, `.bash_profile`) | 2 |
| H04 | Toolchain cruzada (capítulo 5: binutils, gcc passo 1, headers, glibc, libstdc++) | 10 |
| H05 | Ferramentas temporárias (capítulo 6) | 10 |
| H06 | Chroot e ferramentas temporárias adicionais (capítulo 7), backup do estado | 6 |
| H07 | Software do sistema base (capítulo 8), com testes onde o livro recomenda como críticos (glibc, gcc, binutils) | 30 |
| H08 | Configuração do sistema (capítulo 9): bootscripts, rede, locale, inputrc, fstab de live | 4 |
| H09 | Kernel: configurar e compilar com suporte para VM e hardware real (ver seção 6) | 8 |
| H10 | Live system: initramfs, squashfs do rootfs, overlay em RAM | 8 |
| H11 | ISO híbrida BIOS + UEFI com GRUB | 6 |
| H12 | Testes automáticos em QEMU (BIOS e UEFI) | 6 |
| H13 | Entrega: ISO final, checksum, guia de gravação no pendrive e teste em hardware pelo Eli | 4 |

Porcentagem total = soma dos pesos dos marcos concluídos dividida por 100. Marcos em andamento podem contar proporcionalmente pelos subpassos concluídos.

## 6. Requisitos técnicos da ISO

### Kernel

Incluir embutido (não como módulo, para simplificar o boot): ISO9660, squashfs, overlayfs, tmpfs, ext4, vfat; USB (xHCI, EHCI), usb-storage, UAS; AHCI/SATA, NVMe; virtio (blk, net, scsi, pci) e drivers comuns de VM (e1000); EFI stub, framebuffer EFI e VESA; console serial (ttyS0), para testes em QEMU sem tela; devtmpfs com automount.

### Live boot

- Rootfs compactado em `live/rootfs.squashfs` (xz ou zstd).
- Initramfs próprio, mínimo (busybox estático compilado pelo agente ou script shell sobre ferramentas do próprio LFS): procura a mídia pelo label da ISO, monta o squashfs, monta overlay com camada gravável em tmpfs e faz `switch_root`.
- Sistema dá boot em runlevel texto com login em tty1 e ttyS0.
- Senha de root definida e documentada no `STATUS.md`.
- Remover símbolos de debug (strip) antes de compactar, para reduzir o tamanho.

### Bootloader

- GRUB compilado no próprio LFS (capítulo 8) com alvos `i386-pc` e `x86_64-efi`.
- ISO gerada com `grub-mkrescue` e `xorriso`, híbrida: bootável como CD em VM e gravável byte a byte em pendrive (Rufus em modo DD, balenaEtcher, `dd`).
- Menu com entrada normal e entrada com console serial.
- Secure Boot desativado é premissa; documentar isso no guia.

### Instalação opcional

Se sobrar tempo após H13, criar o script `instalar-no-disco`, executado pelo terminal da ISO live, que particiona um disco alvo, copia o sistema e instala o GRUB nele. Marco extra, não bloqueia a entrega.

## 7. Testes (H12)

Rodar na própria VPS, sem interface gráfica:

1. QEMU com BIOS (SeaBIOS) e `-nographic`, via console serial.
2. QEMU com UEFI (OVMF).
3. QEMU emulando o pendrive: a ISO anexada como disco USB (`-device usb-storage`), não como CD.

Critério de sucesso em cada teste: chegar ao prompt de login, logar como root e executar `uname -a`, `ls /`, `gcc --version` e `cat /etc/os-release`. Automatizar com `expect` ou script que lê o console serial, salvando a saída em `logs/testes/`. O agente só marca H12 como feito se os três passarem.

## 8. Documentação e dashboard

### Regras de documentação

- Toda ação relevante gera uma linha em `docs/diario.md`: data e hora, marco, o que foi feito, resultado.
- Todo erro gera uma entrada em `docs/erros.md` com: pacote, sintoma (trecho curto do log), causa, correção aplicada, tentativas. Cada entrada é um ciclo de correção.
- Decisões técnicas vão em `docs/decisoes.md`.
- `STATUS.md` sempre mostra: marco atual, porcentagem, último passo concluído, próximo passo, bloqueios.
- `status.json` é atualizado ao fim de cada passo, com marcos, status, pesos, porcentagem, data da última atualização, últimos erros e próximo passo.

### Dashboard

`dashboard/index.html` é um arquivo único, sem dependências externas, que lê `status.json` da mesma pasta e mostra: barra de progresso geral, lista de marcos com status colorido, linha do tempo das últimas ações, erros e correções recentes, próximo passo e horário da última atualização. Deve funcionar aberto localmente depois de baixado via FTP. Se a leitura do JSON for bloqueada ao abrir como arquivo local, gerar o HTML já com os dados embutidos a cada atualização.

## 9. Execução autônoma com /loop

O agente roda com `/loop` no Claude Code até concluir H13. Cada iteração:

1. Ler `STATUS.md` e `status.json` para saber onde parou.
2. Escolher o próximo passo pendente.
3. Executar via script em `scripts/`, salvando a saída em `logs/`.
4. Verificar o resultado pelo código de saída e por busca de erros no log.
5. Se falhar: ler só o trecho relevante do log, corrigir, registrar em `erros.md` e tentar de novo.
6. Atualizar diário, história, `STATUS.md`, `status.json` e dashboard.

### Loops de trabalho

O `/loop` não serve só para retomar depois do limite de uso: o agente deve criar os loops necessários para o projeto andar sozinho. A retomada após o limite da sessão já é automática no Claude Code; os loops abaixo são responsabilidade do agente.

1. **Loop principal de execução:** avança marco por marco até H13, seguindo os passos acima.
2. **Loop de monitoramento de build:** para compilações longas, verifica em intervalos espaçados se o processo terminou, sem ler a saída, e só acorda o loop principal quando houver resultado.
3. **Loop de correção:** quando um passo falha, tenta corrigir até resolver ou até atingir um número máximo de tentativas definido pelo agente; esgotado, marca como `bloqueado`, documenta e segue para o que não depende dele.
4. **Loop de documentação:** ao fim de cada passo, atualiza diário, histórias, `STATUS.md`, `status.json` e dashboard.
5. **Loop de testes:** a cada nova ISO gerada, roda os três testes em QEMU e, se algum falhar, devolve o problema para o loop de correção.

O agente pode criar outros loops se achar necessário, registrando cada um em `docs/decisoes.md` com o objetivo e o intervalo usado.

### Retomada e limites

- O estado fica todo em disco, então qualquer iteração pode recomeçar do zero de contexto lendo os arquivos de status.
- Scripts devem ser idempotentes: ao retomar, não refazer pacotes já marcados como concluídos (usar arquivos marcadores, por exemplo `logs/feito/<pacote>`).
- Ao atingir limite de uso, o agente espera o limite renovar e continua de onde parou. Antes de parar, deixar `STATUS.md` atualizado.
- Fazer backup do `$LFS` (tar) ao fim de H06 e de H07, para não perder horas de compilação se algo quebrar.

## 10. Economia de tokens

- Nunca acompanhar a compilação em tempo real nem imprimir saída de `make` no contexto.
- Builds longos rodam em segundo plano, redirecionando tudo para `logs/<pacote>.log`; o agente espera com `sleep` em intervalos longos e só confere se o processo terminou.
- Para verificar resultado, olhar o código de saída e no máximo as últimas linhas do log ou um `grep` por `error`.
- Agrupar pacotes de um mesmo capítulo num único script, em vez de um comando por vez.
- Ler o livro por seção, só a parte necessária para o passo atual, e guardar os comandos extraídos em `scripts/` para não reler.
- Suítes de teste longas: rodar só as que o livro considera críticas; nos demais pacotes, registrar que foram puladas.

## 11. Regras para o agente

- Seguir o livro LFS; desvios só com justificativa em `decisoes.md`.
- Ferramentas do host servem apenas para construir; o sistema final não pode conter binários copiados do host.
- Não pedir intervenção humana, exceto para o teste em hardware real (H13) ou bloqueio impossível de resolver, registrado como `bloqueado` com explicação.
- Não iniciar a Fase 2 sem autorização.

## 12. Critérios de aceite da Fase 1

1. ISO final em `iso/` com arquivo SHA-256 ao lado.
2. Testes em QEMU com BIOS, UEFI e USB emulado aprovados, com logs salvos.
3. Guia `iso/COMO-GRAVAR.md` explicando gravação com Rufus (modo DD) e balenaEtcher, desativar Secure Boot e escolher o boot pelo pendrive.
4. Documentação completa: todas as histórias fechadas, diário, erros e decisões preenchidos.
5. Dashboard mostrando 100%.
6. Boot confirmado pelo Eli numa VM local e numa máquina real via pendrive.

