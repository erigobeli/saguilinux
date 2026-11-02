#!/bin/bash
# Copia para $LFS/sources só as tarballs completas (paradas há >2 min e íntegras) e lista as que faltam por plano
cd "$(dirname "$0")/.."
find sources -maxdepth 1 -type f -mmin +2 -printf '%f\n' | while read f; do
  d=/mnt/lfs/sources/$f
  [ -e "$d" ] && [ ! "$d" -ot "sources/$f" ] && [ "$(stat -c %s "$d")" = "$(stat -c %s "sources/$f")" ] && continue
  case $f in
    *.xz|*.txz) xz -t "sources/$f" 2>/dev/null || continue ;;
    *.gz|*.tgz) gzip -t "sources/$f" 2>/dev/null || continue ;;
    *.bz2) bzip2 -t "sources/$f" 2>/dev/null || continue ;;
  esac
  sudo cp -p "sources/$f" "$d"; sudo chown root:root "$d"
done
for p in "$@"; do
  falt=$(awk -F'|' '!/^#/ && $2!="-" {print $2}' scripts/planos/$p.txt | while read t; do [ -e /mnt/lfs/sources/$t ] || echo -n "$t "; done)
  echo "$p: ${falt:-completo}"
done
