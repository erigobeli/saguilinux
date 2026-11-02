#!/bin/bash
# Loop principal da Fase 2: roda os planos em ordem (ex.: rodar-blfs.sh B03 B04 B05).
# - tarball ainda não baixada -> sincroniza sources/ e espera 60 s (loop de espera de download)
# - qualquer outra falha -> para (logs/estado-build = FAIL) para o loop de correção do agente
cd "$(dirname "$0")/.."
for m in "$@"; do
  python3 scripts/status.py marco $m em_andamento 0.02 >/dev/null
  while true; do
    bash scripts/faltando.sh $m >/dev/null
    bash scripts/build.sh "$PWD/scripts/planos/$m.txt" $m && break
    id=$(awk '{print $2}' logs/estado-build)
    t=$(awk -F'|' -v i="$id" '$1==i{print $2}' scripts/planos/$m.txt)
    if [ -n "$t" ] && [ "$t" != "-" ] && [ ! -e /mnt/lfs/sources/$t ]; then
      echo "WAIT $id (aguardando download de $t)" > logs/estado-build
      sleep 60; continue
    fi
    exit 1
  done
done
echo "OK $*" > logs/estado-build
