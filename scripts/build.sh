#!/bin/bash
# Driver genérico de build. Uso: build.sh <arquivo-plano> <marco>
# Cada linha do plano: id|tarball|snippet|modo
#   id       nome único do passo (vira logs/<id>.log e logs/feito/<id>)
#   tarball  pacote em $LFS/sources a extrair ("-" = não extrair; o snippet cuida)
#   snippet  caminho relativo a scripts/ com os comandos do livro
#   modo     lfs (usuário lfs, cap. 5/6) | chroot (cap. 7/8+) | root (root no host)
# Idempotente: passos com marcador em logs/feito/ são pulados.
# Estado em logs/estado-build: RUNNING <id> | OK <plano> | FAIL <id>
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
PLAN=$1; MARCO=$2
[ -f "$PLAN" ] || { echo "FAIL plano inexistente: $PLAN" > "$(dirname "$0")/../logs/estado-build"; exit 1; }
LFS=/mnt/lfs
RUN=$LFS/sources/.run
ST=$ROOT/logs/estado-build
sudo mkdir -p $RUN; sudo chmod 1777 $RUN
mkdir -p "$ROOT/logs/feito"

mount_kernfs() {
  mountpoint -q $LFS/dev     || sudo mount -v --bind /dev $LFS/dev
  mountpoint -q $LFS/dev/pts || sudo mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
  mountpoint -q $LFS/proc    || sudo mount -vt proc proc $LFS/proc
  mountpoint -q $LFS/sys     || sudo mount -vt sysfs sysfs $LFS/sys
  mountpoint -q $LFS/run     || sudo mount -vt tmpfs tmpfs $LFS/run
  if [ -h $LFS/dev/shm ]; then sudo install -v -d -m 1777 $LFS$(realpath /dev/shm)
  else mountpoint -q $LFS/dev/shm || sudo mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm; fi
}

total=$(grep -cv '^\s*\(#\|$\)' "$PLAN"); n=0
while IFS='|' read -r id tarball snippet modo; do
  [[ -z "$id" || "$id" == \#* ]] && continue
  n=$((n+1))
  if [ -e "$ROOT/logs/feito/$id" ]; then continue; fi
  echo "RUNNING $id" > "$ST"
  if [ "$modo" = chroot ]; then SRC=/sources; else SRC=$LFS/sources; fi
  s=$RUN/$id.sh
  {
    echo '#!/bin/bash'
    echo 'set -e'
    echo "echo '### $id - inicio:' \$(date '+%F %T')"
    echo "cd $SRC"
    if [ "$tarball" != "-" ]; then
      dir=$(tar tf "$LFS/sources/$tarball" | head -1 | sed 's|^\./||' | cut -d/ -f1)
      echo "rm -rf '$dir'; tar xf '$tarball'; cd '$dir'"
    fi
    cat "$ROOT/scripts/$snippet"
    echo
    echo "cd $SRC"
    [ "$tarball" != "-" ] && echo "rm -rf '$dir'"
    echo "echo '### $id - fim OK:' \$(date '+%F %T')"
  } > "$s"
  chmod 755 "$s"
  case $modo in
    lfs)    sudo -u lfs env -i HOME=/home/lfs TERM=xterm bash -c "source ~/.bashrc; bash $s" ;;
    chroot) mount_kernfs >/dev/null
            sudo chroot "$LFS" /usr/bin/env -i HOME=/root TERM=xterm PS1='(lfs chroot) \u:\w\$ ' \
              PATH=/usr/bin:/usr/sbin MAKEFLAGS="-j$(nproc)" TESTSUITEFLAGS="-j$(nproc)" /bin/bash /sources/.run/$id.sh ;;
    root)   sudo env LFS=$LFS bash "$s" ;;
  esac > "$ROOT/logs/$id.log" 2>&1 < /dev/null
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "FAIL $id rc=$rc" > "$ST"
    python3 "$ROOT/scripts/status.py" diario "$MARCO" "Falha em $id (rc=$rc)" "erro - logs/$id.log"
    exit 1
  fi
  touch "$ROOT/logs/feito/$id"
  python3 "$ROOT/scripts/status.py" marco "$MARCO" em_andamento "$(python3 -c "print(round($n/$total*0.95,3))")"
  python3 "$ROOT/scripts/status.py" diario "$MARCO" "$id compilado e instalado" "ok - logs/$id.log"
done < "$PLAN"
echo "OK $PLAN" > "$ST"
