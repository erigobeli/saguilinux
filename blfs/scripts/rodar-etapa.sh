#!/bin/bash
# Roda uma ou mais etapas (plano:marco) em sequência, dentro do tmux "distro".
# Uso: rodar-etapa.sh scripts/planos/ch5.txt:H04 scripts/planos/ch6.txt:H05
for pm in "$@"; do
  p=$(realpath "${pm%%:*}") || exit 1
  bash "$(dirname "$0")/build.sh" "$p" "${pm##*:}" || exit 1
done
