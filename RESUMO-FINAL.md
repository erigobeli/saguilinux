# Resumo final da Fase 1

Terminei a Fase 1 do PRD. A ISO está pronta e passa em todos os testes automáticos. Ainda falta uma coisa que só você pode fazer: o teste em hardware real, que o PRD reserva para você.

## Entrega

- ISO: `~/distro-ai/iso/semente-linux-1.0-x86_64.iso` (295 MB), com o SHA-256 em `semente-linux-1.0-x86_64.iso.sha256` ao lado (`b42b3ec7…2363c`).
- Guia: `iso/COMO-GRAVAR.md`. Explica Rufus em modo DD, balenaEtcher e `dd`, como desligar o Secure Boot e a tecla do menu de boot por fabricante.
- Login: `root` / senha `semente`, também anotada no `STATUS.md`.
- Escolhi o nome provisório **Semente Linux 1.0**, já que o PRD deixava "a definir". Dá para trocar em `scripts/ch9/config.sh`.

## Testes na VPS (QEMU sem KVM, então emulação lenta)

- Passaram os três exigidos: BIOS, UEFI e a ISO como pendrive USB. Em cada um ele faz login como root e roda `uname -a`, `ls /`, `gcc --version` e `cat /etc/os-release`.
- Também passaram testes extras: pendrive em modo UEFI e o script opcional `instalar-no-disco`, instalando num disco virtual que depois deu boot em BIOS e em UEFI.
- Os logs estão em `logs/testes/`, com um resumo em `resumo.txt`.
- Conferi os 817 binários e bibliotecas do sistema final: nenhum foi compilado pelo host.

## O que falta (só você)

- O dashboard está em 99% porque o H13 depende do seu teste numa VM local e numa máquina real.
- Depois de testar, rode o comando abaixo. Ele fecha o H13 e leva o dashboard a 100%:

  ```
  bash scripts/confirmar-hardware.sh "o que testou e o resultado"
  ```

- Não comecei a Fase 2.

## Desvios do livro (todos justificados em `docs/decisoes.md`)

- Testes de pacotes só nos críticos: glibc, binutils e gcc. Tiveram poucas falhas, todas dentro do que o livro avisa.
- GMP e libffi foram compilados para x86_64 genérico, e não para o processador da VPS, para a ISO rodar em outro hardware.
- Incluí pacotes fora do livro, todos compilados a partir do código-fonte:
  - **FreeType e Unifont** (receita do BLFS): o GRUB precisa deles para gerar a ISO com boot UEFI.
  - **xorriso e mtools**: também são necessários para gerar a ISO.
- **Sem rede automática:** o LFS não tem cliente DHCP, então o live sobe sem rede (fica para a Fase 2). O guia mostra como configurar na mão.

## Documentação

- 8 ciclos de correção em `docs/erros.md`. O mais importante: o pendrive gravado em modo DD não era encontrado pelo boot. Corrigi e o teste USB passou.
- Diário completo em `docs/diario.md` e as 13 histórias fechadas, menos o H13.
- Backups do sistema ao fim dos capítulos 7 e 8 em `backups/`.
- O dashboard é `dashboard/index.html`, já com os dados embutidos, e funciona aberto localmente depois de baixado por FTP.
