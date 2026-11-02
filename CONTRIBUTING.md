# Como contribuir com o Sagui Linux

Obrigado pelo interesse! O Sagui Linux é um projeto **educacional**: a melhor contribuição é ajudar outras pessoas a aprender com ele.

## Formas de ajudar

1. **Relatar um teste em hardware** — funcionou (ou não) no seu computador? Abra uma *issue* com o modelo "Teste em hardware": máquina, placa de vídeo, BIOS/UEFI, como gravou o pendrive e o que aconteceu. Fotos da tela ajudam muito.
2. **Corrigir ou melhorar a documentação** — textos do site (`site/`), README, guias de gravação. Erros de português também contam.
3. **Melhorar os scripts** — correções no build (`scripts/`, `blfs/scripts/revisao.txt`), novos testes, portabilidade (tirar caminhos fixos como `/home/erigobeli`).
4. **Ideias** — abra uma *issue* do tipo "Ideia". Lembre que o escopo é um Linux leve e didático.

## Regras para mudanças no build

- **O livro é a referência.** Toda alteração em relação ao LFS/BLFS deve ser justificada em `docs/decisoes.md` ou `blfs/docs/decisoes.md` e marcada com `# DESVIO:` no script.
- Os comandos do BLFS ficam em **`blfs/scripts/revisao.txt`** (fonte única). Depois de editar, rode `python3 blfs/scripts/aplicar-revisao.py` e envie os arquivos gerados junto.
- Erros encontrados entram em `docs/erros.md`/`blfs/docs/erros.md` com **sintoma, causa e correção**.
- Nenhum binário copiado do sistema hospedeiro pode entrar na imagem.
- Teste em máquina virtual antes de enviar. **Nunca** teste scripts de build/partição numa máquina com dados importantes.

## Fluxo

1. Faça um *fork* e crie um *branch* (`git checkout -b minha-melhoria`).
2. Faça as alterações com mensagens de commit claras, em português.
3. Abra um *Pull Request* explicando o quê e por quê.

Ao contribuir, você concorda que seu código entra sob a licença [MIT](LICENSE) e seus textos/imagens sob [CC BY 4.0](LICENCAS.md), e declara ter o direito de enviá-los. Siga o [Código de Conduta](CODE_OF_CONDUCT.md).
